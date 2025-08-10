import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/routes/reading/logic/epub_controller.dart';
import 'package:openshelf_app/routes/reading/reader_header.dart';

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
  InAppWebViewController? webViewController;

  loadBook() async {
    Uint8List data = widget.epubBytes;

    webViewController?.evaluateJavascript(source: 'loadBook($data)');
  }

  addJavascriptHandlers() {
    webViewController?.addJavaScriptHandler(
      handlerName: 'readyToLoad',
      callback: (args) {
        loadBook();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: ReaderHeader(chapters: [], onChapterSelected: (index) {}),
      footer: SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(FIcons.arrowLeft)),
            IconButton(onPressed: () {}, icon: Icon(FIcons.arrowRight)),
          ],
        ),
      ),
      child: Center(
        child: InAppWebView(
          initialFile: 'assets/epub_webview/dist/index.html',
          onConsoleMessage: (controller, consoleMessage) {
            if (kDebugMode) {
              debugPrint("JS_LOG: ${consoleMessage.message}");
              // debugPrint(consoleMessage.message);
            }
          },
          shouldOverrideUrlLoading: (controller, url) async {
            return NavigationActionPolicy.ALLOW;
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          onWebViewCreated: (controller) {
            webViewController = controller;
            widget.epubController.setWebViewController(webViewController!);
            addJavascriptHandlers();
          },
        ),
      ),
    );
  }
}
