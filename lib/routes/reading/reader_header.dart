import 'dart:ui';

import 'package:epub_pro/epub_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/router.dart';
import 'package:collection/collection.dart';
import 'package:openshelf_app/routes/reading/recursive_chapter_box.dart';

class ReaderHeader extends ConsumerWidget {
  final Function(EpubNavigationPoint) onNavigationPointSelected;
  final VoidCallback onNavigationOpen;
  final VoidCallback onNavigationClose;
  const ReaderHeader({
    super.key,
    required this.navigationMap,
    required this.onNavigationPointSelected,
    required this.onNavigationOpen,
    required this.onNavigationClose,
  });

  final EpubNavigationMap? navigationMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
                child: IconButton(
                  onPressed: () {
                    ref.read(goRouterProvider).go("/");
                  },
                  iconSize: 22,
                  icon: Icon(FIcons.house),
                ),
              ),
              FButton(
                onPress: () async {
                  onNavigationOpen();
                  await showFDialog(
                    context: context,
                    style: (p0) => p0.copyWith(
                      barrierFilter: (animation) => ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.srcOver,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    builder:
                        (
                          BuildContext context,
                          FDialogStyle style,
                          Animation<double> animation,
                        ) {
                          return FDialog(
                            animation: animation,
                            title: Text(
                              "Navigation",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            actions: [],

                            style: (p0) => p0.copyWith(
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),

                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: context.theme.colors.border,
                                ),
                                color: Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundFilter: (sigma) => ImageFilter.blur(
                                sigmaX: animation.value * 5,
                                sigmaY: animation.value * 5,
                              ),
                            ),
                            body: Column(
                              children: [
                                SizedBox(
                                  height: 500,
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(
                                      context,
                                    ).copyWith(scrollbars: false),
                                    child: ShaderMask(
                                      shaderCallback: (Rect rect) {
                                        return LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.purple,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.purple,
                                          ],
                                          stops: [
                                            0,
                                            0.1,
                                            0.9,
                                            1.0,
                                          ], // 10% purple, 80% transparent, 10% purple
                                        ).createShader(rect);
                                      },
                                      blendMode: BlendMode.dstOut,
                                      child: ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 30.0,
                                        ),
                                        itemBuilder: (context, index) =>
                                            navigationMap != null
                                            ? RecursiveChapterBox(
                                                onNavigationPointSelected:
                                                    (navigationPoint) {
                                                      onNavigationPointSelected(
                                                        navigationPoint,
                                                      );
                                                      onNavigationClose();
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                navigationPoint: navigationMap!
                                                    .points[index],
                                                topLevel: true,
                                              )
                                            : null,
                                        itemCount:
                                            navigationMap?.points.length ?? 0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                  );
                },
                child: Text("Chapters"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
