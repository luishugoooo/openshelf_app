import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/api/library/books.dart';
import 'package:openshelf_app/routes/home/book_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksNotifierProvider);
    final isMobile =
        MediaQuery.of(context).size.width < context.theme.breakpoints.md;
    return books.when(
      data: (books) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        itemCount: books.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(4),
          child: BookCard(book: books[index], key: ValueKey(books[index].id)),
        ),
      ),

      error: (error, stack) => throw error,
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
