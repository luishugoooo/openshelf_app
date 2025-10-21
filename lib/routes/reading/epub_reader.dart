import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
  ep.EpubBook? book;

  void parseBook() async {
    book = await ep.EpubReader.readBook(widget.epubBytes);

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
        "EpubChannel",
        onMessageReceived: (JavaScriptMessage message) {
          print("DART RECEIVED MESSAGE: ${message.message}");
        },
      )
      ..setOnConsoleMessage((message) {
        print("DART RECEIVED JS CONSOLE MESSAGE: ${message.message}");
      });

    if (kDebugMode) {
      webViewController?.loadRequest(Uri.parse("http://10.0.2.2:5173"));
    } else {
      webViewController?.loadFlutterAsset("assets/webview_new/dist/index.html");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: ReaderHeader(chapters: [], onChapterSelected: (index) {}),
      footer: SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                await webViewController?.runJavaScript("previousPage()");
              },
              icon: Icon(FIcons.arrowLeft),
            ),
            IconButton(
              onPressed: () async {
                await webViewController?.runJavaScript("nextPage()");
              },
              icon: Icon(FIcons.arrowRight),
            ),
            FButton(
              onPress: () async {
                final htmlContent =
                    book?.content?.html.entries.elementAt(10).value.content ??
                    '';

                // Prepare CSS as a map
                final cssMap = <String, String>{};
                book?.content?.css.forEach((key, value) {
                  final cssContent = value.content ?? '';
                  cssMap[key] = cssContent;
                });

                // Prepare images as base64 data URIs
                final imageMap = <String, String>{};
                book?.content?.images.forEach((key, value) {
                  try {
                    final imageBytes = value.content;
                    if (imageBytes != null && imageBytes.isNotEmpty) {
                      final base64Image = base64Encode(imageBytes);
                      final mimeType = _getMimeType(key);
                      imageMap[key] = 'data:$mimeType;base64,$base64Image';
                    }
                  } catch (e) {
                    print('Error encoding image $key: $e');
                  }
                });

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
              },
              child: Text("Load Book"),
            ),
          ],
        ),
      ),
      child: book == null
          ? Text("loading")
          : Center(child: WebViewWidget(controller: webViewController!)),
    );
  }
}
