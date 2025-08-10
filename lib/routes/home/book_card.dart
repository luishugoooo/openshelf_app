import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/api/library/books.dart';
import 'package:openshelf_app/api/library/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openshelf_app/api/util/dio.dart';
import 'package:openshelf_app/router.dart';
import 'package:path_provider/path_provider.dart';

class BookCard extends ConsumerStatefulWidget {
  const BookCard({super.key, required this.book});
  final Book book;

  @override
  ConsumerState<BookCard> createState() => _BookCardState();
}

class _BookCardState extends ConsumerState<BookCard> {
  Uint8List? coverImage;
  bool localFileExists = false;
  bool localFileLoading = true;
  Stream<int>? downloadProgress;

  Future<Uint8List?> getCachedImage() async {
    final cacheDir = await getApplicationDocumentsDirectory();
    final file = File("${cacheDir.path}/cover_${widget.book.id}.cache_image");
    if (await file.exists()) {
      print(
        "BookCard.getCachedImage: found cached image for ${widget.book.id}",
      );
      return file.readAsBytes();
    }
    print(
      "BookCard.getCachedImage: no cached image found for ${widget.book.id}",
    );
    return null;
  }

  Future<void> loadCoverImage() async {
    final cachedImage = await getCachedImage();
    if (!mounted) return;
    if (cachedImage != null) {
      setState(() => coverImage = cachedImage);
      return;
    }
    Uint8List? image;

    await ref
        .read(dioProvider)
        .get(
          "/library/cover/${widget.book.id}",
          options: Options(responseType: ResponseType.bytes),
        )
        .then((value) {
          image = value.data as Uint8List;
        })
        .onError((error, stackTrace) {
          print(
            "BookCard.loadCoverImage: error fetching cover image for ${widget.book.id} with error $error",
          );
          return null;
        });
    if (image == null) {
      return;
    }
    setState(() => coverImage = image);
    final cacheDir = await getApplicationDocumentsDirectory();
    final file = File("${cacheDir.path}/cover_${widget.book.id}.cache_image");
    file.writeAsBytesSync(coverImage!);
  }

  Future<void> loadLocalFile() async {
    final exists = await ref
        .read(booksNotifierProvider.notifier)
        .localFileExists(widget.book.id);
    setState(() {
      localFileExists = exists;
      localFileLoading = false;
    });
  }

  @override
  void initState() {
    loadCoverImage();
    loadLocalFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (localFileExists) {
          ref.read(goRouterProvider).go("/read/${widget.book.id}");
        } else {
          setState(() {
            downloadProgress = ref
                .read(booksNotifierProvider.notifier)
                .downloadBook(widget.book)
                .asBroadcastStream();
          });
          downloadProgress!.listen(
            null,
            onDone: () {
              setState(() {
                downloadProgress = null;
                loadLocalFile();
              });
            },
            onError: (error, stackTrace) {
              print(error);
              if (mounted) {
                showFToast(
                  // ignore: use_build_context_synchronously
                  context: context,
                  duration: const Duration(seconds: 7),
                  title: Text(
                    "Unable to download book. Check your internet connection and try again.",
                  ),
                );
              }
            },
          );
        }
      },
      onLongPress: () {
        if (localFileExists) {
          ref
              .read(booksNotifierProvider.notifier)
              .deleteLocalFile(widget.book.id);
          loadLocalFile();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on the left
            Container(
              width: 85,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: coverImage != null
                    ? Image.memory(
                        coverImage!,
                        fit: BoxFit.cover,
                        // headers: {
                        //   "Authorization":
                        //       "Bearer ${ref.read(authCredentialsNotifierProvider)?.accessToken}",
                        // },
                        errorBuilder: (context, error, stackTrace) {
                          //(error);
                          return const Icon(Icons.book, size: 30);
                        },
                      )
                    : const Icon(Icons.book, size: 30),
              ),
            ),
            const SizedBox(width: 12.0),
            // Text content on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "${widget.book.title ?? "Untitled Book"}(${widget.book.id})",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.book.title == null ? Colors.grey : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.book.author ?? "Unknown Author",
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.book.author == null
                          ? Colors.grey
                          : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Builder(
                    builder: (context) {
                      if (localFileLoading) {
                        return const Icon(FIcons.loader, size: 18);
                      }

                      if (downloadProgress != null) {
                        return StreamBuilder(
                          stream: downloadProgress!,
                          builder: (context, snapshot) {
                            return SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                backgroundColor: Colors.grey[200],
                                color: context.theme.colors.primary,
                                value: snapshot.data != null
                                    ? snapshot.data! / 100
                                    : 0,
                              ),
                            );
                          },
                        );
                      }
                      if (!localFileExists) {
                        return Icon(
                          FIcons.cloudDownload,
                          size: 18,
                          color: Colors.blue[600],
                        );
                      }
                      return Icon(
                        FIcons.folderCheck,
                        size: 18,
                        color: Colors.green[800],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
