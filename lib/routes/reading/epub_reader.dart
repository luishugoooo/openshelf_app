import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/routes/reading/logic/epub_controller.dart';
import 'package:openshelf_app/routes/reading/reader_header.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  @override
  void initState() {
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
      })
      ..loadFlutterAsset("assets/epub_webview/dist/index.html");
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
                await webViewController?.runJavaScript(
                  "loadBook(${widget.epubBytes})",
                );
              },
              child: Text("Load Book"),
            ),
          ],
        ),
      ),
      child: Center(child: WebViewWidget(controller: webViewController!)),
    );
  }
}
