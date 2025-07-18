import 'package:dio/dio.dart';
import 'package:openshelf_app/api/auth/credentials.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();
  final credentials = ref.read(authCredentialsNotifierProvider);
  if (credentials != null) {
    dio.options.baseUrl = credentials.instanceUrl;
  }
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final credentials = ref.read(authCredentialsNotifierProvider);
        if (credentials != null) {
          options.headers["Authorization"] =
              "Bearer ${credentials.accessToken}";
        }
        return handler.next(options);
      },
    ),
  );
  return dio;
}
