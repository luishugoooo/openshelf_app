import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openshelf_app/api/library/types.dart';
import 'package:openshelf_app/api/local/library_db.dart';
import 'package:openshelf_app/api/util/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'books.g.dart';

@Riverpod(keepAlive: true)
class BooksNotifier extends _$BooksNotifier {
  @override
  Stream<List<Book>> build() async* {
    final db = ref.read(libraryDatabaseProvider);
    final res = await db.select(db.storedBooks).get();
    final cachedBooks = res
        .map(
          (e) => Book(
            id: e.id,
            title: e.title,
            author: e.author,
            publisher: e.publisher,
            year: e.year,
            progress: e.progress,
            type: e.type,
          ),
        )
        .toList();
    yield cachedBooks;
    List<Book> books = [];
    try {
      books = await sync();
    } on Exception catch (e) {
      print(e);
      print(
        "BooksNotifier.build: error syncing books, continue in offline mode",
      );
      return;
    }
    if (listEquals(cachedBooks, books)) {
      return;
    } else {
      yield books;
    }
  }

  Future<List<Book>> sync() async {
    final res =
        (await ref.read(dioProvider).get("/library/books")).data as List;
    print(res);
    final db = ref.read(libraryDatabaseProvider);
    final books = res.map((e) => Book.fromJson(e)).toList();
    await db.batch((b) {
      b.insertAllOnConflictUpdate(
        db.storedBooks,
        books.map(
          (e) => StoredBooksCompanion(
            id: Value(e.id),
            title: Value(e.title),
            author: Value(e.author),
            publisher: Value(e.publisher),
            year: Value(e.year),
            progress: Value(e.progress),
            type: Value(e.type ?? BookType.epub),
          ),
        ),
      );
    });
    return books;
  }

  Future<void> clearLocalCache() async {
    final db = ref.read(libraryDatabaseProvider);
    await db.delete(db.storedBooks).go();
    ref.invalidateSelf();
  }

  Stream<int> downloadBook(Book book) async* {
    final progress = StreamController<int>();

    // Start the download and handle completion
    final downloadFuture = ref
        .read(dioProvider)
        .get(
          "/library/download/${book.id}",
          options: Options(
            responseType: ResponseType.bytes,
            receiveTimeout: const Duration(seconds: 1),
          ),
          onReceiveProgress: (received, total) {
            if (!progress.isClosed) {
              progress.add((received / total * 100).toInt());
            }
          },
        )
        .then((res) async {
          // Close progress stream when download completes
          progress.close();

          // Save file
          final bytes = res.data;
          final dir = await getApplicationDocumentsDirectory();
          final file = File("${dir.path}/${book.id}.epub");
          await file.writeAsBytes(bytes);
          print(
            "BooksNotifier.downloadBook: downloaded book ${book.id}, file exists: ${await file.exists()}",
          );
        })
        .catchError((e) {
          progress.addError(e);
          progress.close();
        });

    // Yield all progress updates
    yield* progress.stream;

    // Wait for download to complete (this ensures file operations finish)
    await downloadFuture;
  }

  Future<bool> localFileExists(int bookId) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$bookId.epub");
    return await file.exists();
  }

  Future<void> deleteLocalFile(int bookId) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$bookId.epub");
    await file.delete();
    ref.invalidateSelf();
  }
}

@riverpod
Future<File> localFile(Ref ref, int bookId) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File("${dir.path}/$bookId.epub");
  if (await file.exists()) {
    return file;
  }
  throw Exception("File not found");
}
