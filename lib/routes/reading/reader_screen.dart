import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/api/library/books.dart';
import 'package:openshelf_app/routes/reading/reader_header.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int bookId;
  const ReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final epubController = EpubController();
  @override
  void dispose() {
    epubController.webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: ReaderHeader(chapters: [], onChapterSelected: (index) {}),
      footer: SizedBox(
        height: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                epubController.prev();
              },
              icon: Icon(FIcons.arrowLeft),
            ),
            IconButton(
              onPressed: () {
                try {
                  final r = epubController.next();
                  print(r);
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(FIcons.arrowRight),
            ),
          ],
        ),
      ),
      child: Center(
        child: ref
            .watch(localFileProvider(widget.bookId))
            .when(
              data: (file) => EpubViewer(
                epubController: epubController,
                epubSource: EpubSource.fromFile(file),
              ),
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      ),
    );
  }
}
