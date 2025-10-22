import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/routes/reading/logic/epub_controller.dart';
import 'package:openshelf_app/routes/reading/reader_header.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:epub_pro/epub_pro.dart' as ep;

class EpubReader extends ConsumerStatefulWidget {
  final Uint8List epubBytes;
  final EpubController epubController;
  const EpubReader({
    super.key,
    required this.epubBytes,
    required this.epubController,
  });

  @override
  ConsumerState<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends ConsumerState<EpubReader> {
  WebViewController? webViewController;
  ep.EpubBookRef? book;
  int currentPage = 1;
  int totalPages = 1;

  void parseBook() async {
    book = await ep.EpubReader.openBook(widget.epubBytes);
    setState(() {});
  }

  String _getMimeType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.svg')) return 'image/svg+xml';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.bmp')) return 'image/bmp';
    return 'image/jpeg'; // default
  }

  @override
  void initState() {
    parseBook();
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("DART RECEIVED PROGRESS: $progress");
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print("DART RECEIVED PAGE STARTED: $url");
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            print("DART RECEIVED HTTP ERROR: ${error.toString()}");
          },
          onWebResourceError: (WebResourceError error) {
            print("DART RECEIVED WEB RESOURCE ERROR: ${error.toString()}");
          },
        ),
      )
      ..addJavaScriptChannel(
        "PageCountChannel",
        onMessageReceived: (JavaScriptMessage message) {
          print("DART RECEIVED PAGE COUNT MESSAGE: ${message.message}");
          final data = jsonDecode(message.message) as Map<String, dynamic>;
          setState(() {
            currentPage = data['current'] as int;
            totalPages = data['total'] as int;
          });
        },
      )
      ..setOnConsoleMessage((message) {
        print("DART RECEIVED JS CONSOLE MESSAGE: ${message.message}");
      });

    if (kDebugMode) {
      webViewController?.loadRequest(Uri.parse("http://localhost:5173"));
    } else {
      webViewController?.loadFlutterAsset("assets/webview_new/dist/index.html");
    }
  }

  @override
  void dispose() {
    webViewController?.loadRequest(Uri.parse("about:blank"));
    webViewController?.setNavigationDelegate(NavigationDelegate());
    webViewController?.clearCache();
    super.dispose();
  }

  //TODO separate asset loading from chapter loading for better performance
  Future<void> loadChapter(ep.EpubNavigationPoint point) async {
    final src = point.content?.source;
    if (src == null) {
      return;
    }
    final htmlContent = await book?.content?.html[src]?.readContentAsText();
    if (htmlContent == null) {
      return;
    }
    final cssMap = <String, String>{};
    final cssRefs = book?.content?.css;
    if (cssRefs != null) {
      for (var cssEl in cssRefs.entries) {
        final cssContent = await cssEl.value.readContentAsText();
        cssMap[cssEl.key] = cssContent;
      }
    }

    // Prepare images as base64 data URIs
    final imageMap = <String, String>{};
    final imageRefs = book?.content?.images;
    if (imageRefs != null) {
      for (var imageEl in imageRefs.entries) {
        final imageBytes = await imageEl.value.readContentAsBytes();
        if (imageBytes.isNotEmpty) {
          final base64Image = base64Encode(imageBytes);
          final mimeType = _getMimeType(imageEl.key);
          imageMap[imageEl.key] = 'data:$mimeType;base64,$base64Image';
        }
      }
    }

    print('HTML Content length: ${htmlContent.length}');
    print('CSS files: ${cssMap.length}');
    print('Images: ${imageMap.length}');

    // Send everything to JavaScript
    await webViewController?.runJavaScript('''
                  window.epubResources = {
                    css: ${jsonEncode(cssMap)},
                    images: ${jsonEncode(imageMap)}
                  };
                  loadBookString(${jsonEncode(htmlContent)});
                  ''');
  }

  List<ep.EpubChapterRef> collectSubChapters(ep.EpubChapterRef chapter) {
    final List<ep.EpubChapterRef> subChapters = [];
    subChapters.add(chapter);
    if (chapter.subChapters.isNotEmpty) {
      for (var subChapter in chapter.subChapters) {
        subChapters.addAll(collectSubChapters(subChapter));
      }
    }
    return subChapters;
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: ReaderHeader(
        // TODO: SWITCH TO NAVIGATION SCHEMA / MAP
        navigationMap: book?.schema?.navigation?.navMap,
        onNavigationPointSelected: (navigationPoint) {
          loadChapter(navigationPoint);
        },
      ),
      footer: SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                await webViewController?.runJavaScript("prevPage()");
              },
              icon: Icon(FIcons.arrowLeft),
            ),
            IconButton(
              onPressed: () async {
                await webViewController?.runJavaScript("nextPage()");
              },
              icon: Icon(FIcons.arrowRight),
            ),
            Text("Page $currentPage / $totalPages"),
            SizedBox(width: 10),
          ],
        ),
      ),
      child: book == null
          ? Text("loading")
          : Center(
              child: Stack(
                children: [
                  WebViewWidget(
                    controller: webViewController!,
                    gestureRecognizers: {},
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        webViewController?.runJavaScript("nextPage()");
                      } else {
                        webViewController?.runJavaScript("prevPage()");
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
