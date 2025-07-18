import 'package:flutter/widgets.dart';

abstract class SplittedContent {
  List<String> getSplittedContent(
    Size pageSize,
    TextStyle textStyle,
    String text,
  );
}

class SplittedContentImpl extends SplittedContent {
  @override
  List<String> getSplittedContent(
    Size pageSize,
    TextStyle textStyle,
    String text,
  ) {
    final List<String> pageTexts = [];
    return pageTexts;
  }
}
