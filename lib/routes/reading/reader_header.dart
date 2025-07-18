import 'package:epub_pro/epub_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/router.dart';
import 'package:collection/collection.dart';

class ReaderHeader extends ConsumerWidget {
  final Function(int) onChapterSelected;
  const ReaderHeader({
    super.key,
    required this.chapters,
    required this.onChapterSelected,
  });

  final List<EpubChapterRef>? chapters;

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
              SizedBox(
                width: 200,
                child: FSelect<int>(
                  onChange: (value) {
                    onChapterSelected(value ?? 0);
                  },
                  format: (s) => (s + 1).toString(),
                  children:
                      chapters
                          ?.mapIndexed<FSelectItem<int>>(
                            (index, e) => FSelectItem.from(
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${index + 1} | ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: e.title ?? "",
                                      style: TextStyle(
                                        color: context.theme.colors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              value: index,
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
