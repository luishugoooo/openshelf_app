import 'package:collection/collection.dart';
import 'package:epub_pro/epub_pro.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class RecursiveChapterBox extends StatelessWidget {
  final EpubNavigationPoint navigationPoint;
  final bool topLevel;
  final Function(EpubNavigationPoint) onNavigationPointSelected;
  const RecursiveChapterBox({
    super.key,
    required this.navigationPoint,
    this.topLevel = true,
    required this.onNavigationPointSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0),
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.fromHeight(40),
              alignment: Alignment.centerLeft,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight:
                    navigationPoint.childNavigationPoints.isNotEmpty || topLevel
                    ? FontWeight.w700
                    : FontWeight.normal,
              ),
            ),
            onPressed: () {
              onNavigationPointSelected(navigationPoint);
            },
            child: Text(navigationPoint.navigationLabels.first.text ?? ""),
          ),
          if (navigationPoint.childNavigationPoints.isNotEmpty)
            ...navigationPoint.childNavigationPoints
                .mapIndexed(
                  (index, subNavigationPoint) => RecursiveChapterBox(
                    navigationPoint: subNavigationPoint,
                    topLevel: false,
                    onNavigationPointSelected: onNavigationPointSelected,
                  ),
                )
                .where(
                  (navigationPoint) =>
                      navigationPoint
                          .navigationPoint
                          .navigationLabels
                          .first
                          .text !=
                      null,
                ),
        ],
      ),
    );
  }
}
