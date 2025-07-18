import 'package:forui/forui.dart';
import 'package:flutter/material.dart';

void showAppToast({
  required String message,
  IconData? icon,
  required BuildContext context,
}) {
  final breakpoints = context.theme.breakpoints;
  final width = MediaQuery.sizeOf(context).width;
  final isMobile = width < breakpoints.md;
  final alignment = isMobile
      ? FToastAlignment.topCenter
      : FToastAlignment.bottomRight;

  showFToast(
    context: context,
    alignment: alignment,
    title: Text(message),
    icon: icon != null ? Icon(icon) : null,
  );
}
