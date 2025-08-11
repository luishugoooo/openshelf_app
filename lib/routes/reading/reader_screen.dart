import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openshelf_app/api/library/books.dart';
import 'package:openshelf_app/routes/reading/custom_reader.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int bookId;
  const ReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(localFileProvider(widget.bookId))
        .when(
          data: (file) => CustomReader(epubBytes: file.readAsBytesSync()),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
