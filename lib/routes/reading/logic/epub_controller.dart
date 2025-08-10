import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class EpubController {
  InAppWebViewController? webViewController;

  setWebViewController(InAppWebViewController controller) {
    webViewController = controller;
  }

  display({
    ///Cfi String of the desired location, also accepts chapter href
    required String cfi,
  }) {
    checkEpubLoaded();
    webViewController?.evaluateJavascript(source: 'toCfi("$cfi")');
  }

  checkEpubLoaded() {
    if (webViewController == null) {
      throw Exception(
        "Epub viewer is not loaded, wait for onEpubLoaded callback",
      );
    }
  }

  InAppLocalhostServer? server;
}
