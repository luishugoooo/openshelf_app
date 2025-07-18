import 'package:flutter/widgets.dart';

abstract class DynamicSize {
  Size getSize(GlobalKey pagekeys);
}

class DynamicSizeImpl extends DynamicSize {
  @override
  Size getSize(GlobalKey<State<StatefulWidget>> pageKey) {
    RenderBox pageBox =
        pageKey.currentContext!.findRenderObject()! as RenderBox;
    return pageBox.size;
  }
}
