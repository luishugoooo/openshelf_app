import 'dart:convert';

import 'package:epub_pro/epub_pro.dart' as ep;
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<Map<String, String>> encodeImagesToDataUrls(
  Map<String, List<int>> byteMap,
) async {
  final result = <String, String>{};
  for (var imageEl in byteMap.entries) {
    final imageBytes = imageEl.value;
    final mimeType = getMimeType(imageEl.key);
    final base64Image = base64Encode(imageBytes);
    result[imageEl.key] = 'data:$mimeType;base64,$base64Image';
  }
  return result;
}

Future<Map<String, String>> createImageMap(ep.EpubBookRef book) async {
  final imageRefs = book.content?.images;
  if (imageRefs != null) {
    final byteMap = <String, List<int>>{};
    for (var imageEl in imageRefs.entries) {
      final imageBytes = await imageEl.value.readContentAsBytes();
      if (imageBytes.isNotEmpty) {
        byteMap[imageEl.key] = imageBytes;
      }
    }
    return await compute(encodeImagesToDataUrls, byteMap);
  }
  return {};
}

String getMimeType(String filename) {
  final lower = filename.toLowerCase();
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.svg')) return 'image/svg+xml';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.bmp')) return 'image/bmp';
  return 'image/jpeg'; // default
}

Future<void> loadResourcesIntoWebView(
  Map<String, String> imageMap,
  Map<String, String> cssMap,
  WebViewController webViewController,
) async {
  String encodedImages = await compute(jsonEncode, imageMap);
  String encodedCss = await compute(jsonEncode, cssMap);
  await webViewController.runJavaScript('''
                  window.epubResources = {
                    css: $encodedCss,
                    images: $encodedImages
                  };
                  ''');
}

Future<Map<String, String>> createCSSMap(ep.EpubBookRef book) async {
  final cssRefs = book.content?.css;
  if (cssRefs != null) {
    final cssMap = <String, String>{};
    for (var cssEl in cssRefs.entries) {
      final cssContent = await cssEl.value.readContentAsync();
      cssMap[cssEl.key] = cssContent;
    }
    return cssMap;
  }
  return {};
}
