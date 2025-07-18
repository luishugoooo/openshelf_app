import 'package:openshelf_app/api/auth/credentials.dart';
import 'package:openshelf_app/api/util/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection.g.dart';

@riverpod
Stream<bool> connection(Ref ref) async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 5));
    final instanceUrl = ref.read(authCredentialsNotifierProvider)?.instanceUrl;
    if (instanceUrl == null) {
      yield false;
      return;
    }
    final dio = ref.read(dioProvider);
    try {
      await dio.get("/ping");
      yield true;
    } on Exception catch (_) {
      yield false;
    }
  }
}
