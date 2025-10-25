import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/routes/reading/logic/epub_controller.dart';
import 'package:openshelf_app/routes/reading/reader_header.dart';
import 'package:openshelf_app/routes/reading/utils/resources.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:epub_pro/epub_pro.dart' as ep;
import 'package:webview_flutter_android/webview_flutter_android.dart';

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

// Consider keeping the reader offstage for super fast startup times
class _EpubReaderState extends ConsumerState<EpubReader> {
  WebViewController? webViewController;
  late Future<ep.EpubBookRef> book;
  bool readerReady = false;

  /// Whether to use hybrid composition for Android.
  /// Hybrid composition improves WebView performance (smoother swiping), but decreases Flutter performance.
  /// For now, it is disabled by default.
  static const bool ANDROID_HYBRID_COMPOSITION = false;
  int currentPage = 1;
  int totalPages = 1;

  void parseBook() async {
    book = ep.EpubReader.openBook(widget.epubBytes);
  }

  Future<void> initializeReader() async {
    parseBook();
    initWebView(
      onReady: () async {
        final book = await this.book;
        final cssMap = await createCSSMap(book);
        final imageMap = await createImageMap(book);
        await loadResourcesIntoWebView(imageMap, cssMap, webViewController!);
        await loadChapter(book.schema?.navigation?.navMap?.points.first);
        setState(() {
          readerReady = true;
        });
      },
    );
  }

  void initWebView({required VoidCallback onReady}) async {
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
      ..addJavaScriptChannel(
        "ContentControlChannel",
        onMessageReceived: (JavaScriptMessage message) {
          print("DART RECEIVED CONTENT CONTROL MESSAGE: ${message.message}");
        },
      )
      ..addJavaScriptChannel(
        "InterfaceControlChannel",
        onMessageReceived: (JavaScriptMessage message) async {
          print("DART RECEIVED INTERFACE CONTROL MESSAGE: ${message.message}");
          if (message.message == "ready") {
            onReady();
          }
        },
      )
      ..setOnConsoleMessage((message) {
        print("DART RECEIVED JS CONSOLE MESSAGE: ${message.message}");
      });

    if (webViewController?.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
    if (kDebugMode) {
      webViewController?.loadRequest(Uri.parse("http://10.0.2.2:5173"));
    } else {
      webViewController?.loadFlutterAsset("assets/webview_new/dist/index.html");
    }
  }

  @override
  void initState() {
    parseBook();
    super.initState();
    initializeReader();
  }

  @override
  void dispose() {
    webViewController?.loadRequest(Uri.parse("about:blank"));
    webViewController?.setNavigationDelegate(NavigationDelegate());
    webViewController?.clearCache();
    super.dispose();
  }

  //TODO separate asset loading from chapter loading for better performance

  Future<void> loadChapter(ep.EpubNavigationPoint? point) async {
    if (point == null) {
      return;
    }
    final src = point.content?.source?.split("#").first;
    final anchor = point.content?.source?.split("#").last;
    if (src == null) {
      return;
    }
    final book = await this.book;
    final htmlContent = await book.content?.html[src]?.readContentAsText();
    if (htmlContent == null) {
      return;
    }

    String htmlContentEncoded;
    if (kDebugMode) {
      htmlContentEncoded = jsonEncode(htmlContent);
    } else {
      htmlContentEncoded = await compute(jsonEncode, htmlContent);
    }

    await webViewController?.runJavaScript('''
    loadBookString($htmlContentEncoded, ${jsonEncode(anchor)});
    ''');
  }

  Widget buildWebViewWidget(WebViewController controller) {
    if (controller.platform is AndroidWebViewController) {
      return WebViewWidget.fromPlatformCreationParams(
        params: AndroidWebViewWidgetCreationParams(
          controller: controller.platform,
          displayWithHybridComposition: ANDROID_HYBRID_COMPOSITION,
        ),
      );
    }
    return WebViewWidget(controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FutureBuilder(
        future: book,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return ReaderHeader(
              onNavigationOpen: () {},
              onNavigationClose: () {},
              navigationMap: null,
              onNavigationPointSelected: (navigationPoint) {},
            );
          }
          final book = asyncSnapshot.data;
          return ReaderHeader(
            onNavigationOpen: () {},
            onNavigationClose: () {},
            navigationMap: book?.schema?.navigation?.navMap,
            onNavigationPointSelected: (navigationPoint) {
              loadChapter(navigationPoint);
            },
          );
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
      child: Center(
        child: readerReady
            ? Stack(
                children: [
                  buildWebViewWidget(webViewController!),
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
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
