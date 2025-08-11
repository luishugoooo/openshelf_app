import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:epub_pro/epub_pro.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html;
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

class CustomReader extends StatefulWidget {
  final Uint8List epubBytes;
  const CustomReader({super.key, required this.epubBytes});

  @override
  State<CustomReader> createState() => _CustomReaderState();
}

class _CustomReaderState extends State<CustomReader> {
  EpubBook? epubBook;
  bool showCss = false;
  double fontSizeModifier = 1;
  PageController pageController = PageController();
  Future<void> _initEpubReader() async {
    final data = await EpubReader.readBook(widget.epubBytes);
    setState(() {
      epubBook = data;
    });
    // print all css
    // epubBook?.content?.css.values.forEach((element) {
    //   print(element.content);
    // });
    //print(epubBook?.content?.css.values.length);
  }

  @override
  void initState() {
    super.initState();
    _initEpubReader();
  }

  Map<String, Style> loadStyleFromCss(EpubBook? epubBook) {
    if (epubBook?.content?.css.values.isEmpty ?? true) {
      return {};
    }
    final style = <String, Style>{};
    epubBook?.content?.css.entries.forEach((element) {
      style.addAll(
        Style.fromCss(element.value.content ?? "", (error, _) {
          return "";
        }),
      );
    });

    return style;
  }

  final defaultStyle = {"body": Style(fontSize: FontSize(16))};

  Map<String, Style> transformStyle(Map<String, Style> style) {
    if (style.isEmpty) {
      style = defaultStyle;
    }
    return style.map((key, value) {
      double? fontValue = switch (value.fontSize?.unit) {
        Unit.px => (value.fontSize?.value ?? 16) * fontSizeModifier,
        Unit.em => (value.fontSize?.value ?? 1) * 16 * fontSizeModifier,
        Unit.percent => (value.fontSize?.value ?? 1) * 16 * fontSizeModifier,
        _ => null,
      };
      var mapEntry = MapEntry(key, value.copyWith(fontFamily: "Garamond"));

      if (fontValue != null) {
        mapEntry = MapEntry(
          key,
          mapEntry.value.copyWith(fontSize: FontSize(fontValue)),
        );
      }
      return mapEntry;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: SizedBox(
        height: 100,
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: showCss ? Colors.green : Colors.red,
              ),
              onPressed: () {
                setState(() {
                  showCss = !showCss;
                });
              },
              child: Text("Toggle CSS"),
            ),
            IconButton(
              onPressed: () {
                context.go("/");
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                pageController.jumpToPage(
                  (pageController.page?.toInt() ?? 0) - 1,
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: () {
                pageController.jumpToPage(
                  (pageController.page?.toInt() ?? 0) + 1,
                );
              },
              icon: const Icon(Icons.arrow_forward),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  fontSizeModifier += 0.1;
                });
              },
              icon: const Icon(Icons.zoom_in),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  fontSizeModifier -= 0.1;
                });
              },
              icon: const Icon(Icons.zoom_out),
            ),
          ],
        ),
      ),
      child: epubBook != null
          ? Center(
              child: PageView.builder(
                controller: pageController,
                itemCount: epubBook?.content?.html.length ?? 0,
                itemBuilder: (context, index) {
                  final style = loadStyleFromCss(epubBook);
                  return SingleChildScrollView(
                    child: Html(
                      data:
                          epubBook?.content?.html.values
                              .elementAt(index)
                              .content ??
                          '',
                      style: showCss ? transformStyle(style) : {},
                      extensions: [
                        TagExtension(
                          tagsToExtend: {"img"},

                          builder: (extensionContext) {
                            final src =
                                extensionContext.element?.attributes["src"];

                            //yeah this is hacky, but epub folder structures are weird
                            final image = epubBook?.content?.images.keys
                                .firstWhere(
                                  (key) =>
                                      key.split("/").last ==
                                      src?.split("/").last,
                                );
                            if (image != null) {
                              return Image.memory(
                                Uint8List.fromList(
                                  epubBook?.content?.images[image]?.content ??
                                      [],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                      onAnchorTap: (url, attributes, element) {
                        if (url != null) {
                          final index = epubBook?.content?.html.keys
                              .toList()
                              .indexWhere(
                                (key) => key.contains(
                                  url.split("#").first.split("/").last,
                                ),
                              );
                          print(index);

                          if (index != null) {
                            pageController.jumpToPage(index);
                            if (url.contains("#")) {
                              final anchor = url.split("#").last;
                              final element = epubBook?.content?.html.values
                                  .elementAt(index)
                                  .content
                                  ?.split("\n")
                                  .firstWhere(
                                    (element) => element.contains(anchor),
                                  );
                              print(element);
                            }
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
