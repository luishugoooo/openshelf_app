import 'dart:convert';

import 'package:openshelf_app/api/auth/exceptions.dart';
import 'package:openshelf_app/api/auth/credentials.dart';
import 'package:openshelf_app/api/auth/types.dart';
import 'package:openshelf_app/api/local/shared_preferences.dart';
import 'package:openshelf_app/api/util/dio.dart';
import 'package:openshelf_app/api/util/connection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part 'auth.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<User?> build() async* {
    ref.listen(connectionProvider.future, (previous, next) async {
      if (await previous != await next) {
        ref.invalidateSelf();
      } else {
        print("AuthNotifier.build: no change");
      }
    });
    print("AuthNotifier.build");
    final prefs = ref.read(sharedPreferencesProvider);
    final credentials = ref.read(authCredentialsNotifierProvider);
    if (credentials == null) {
      print("AuthNotifier.build: no credentials");
      yield null;
      return;
    }

    final storedUser = prefs.getString("user");
    if (storedUser != null) {
      print("AuthNotifier.build: stored user");
      yield User.fromJson(jsonDecode(storedUser)).copyWith(isOnline: false);
    }
    print("AuthNotifier.build: fetching user");
    User? user;
    try {
      final response = await ref.read(dioProvider).get("/auth/me");
      user = User.fromJson(response.data);
      prefs.setString("user", jsonEncode(user.toJson()));
      yield user.copyWith(isOnline: true);
    } on Exception catch (_) {
      // TODO: Depending on the error, we might want to logout the user (instance reachable, expired token, etc.)
      print(
        "AuthNotifier.build: error fetching user, continue in offline mode",
      );
      user = User.fromJson(jsonDecode(storedUser!));
      yield user.copyWith(isOnline: false);
      return;
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String instanceUrl,
  }) async {
    final response = await ref
        .read(dioProvider)
        .post(
          "$instanceUrl/api/auth/login",
          data: {"email": email, "password": password},
        )
        .onError((error, stackTrace) {
          if (error is DioException) {
            switch (error.type) {
              case DioExceptionType.badResponse:
                switch (error.response?.data) {
                  case String data:
                    switch (jsonDecode(data)["name"]) {
                      case "INVALID_CREDENTIALS":
                        throw InvalidCredentialsException();
                      case "USER_NOT_FOUND":
                        throw UserNotFoundException();
                    }
                  default:
                    throw UnknownAuthException(error.response?.data);
                }
              case DioExceptionType.connectionError:
                throw InstanceNotFoundException();
              default:
                throw UnknownAuthException();
            }
          }
          throw UnknownAuthException(error.toString());
        });

    final accessToken = response.data["access_token"];
    final refreshToken = response.data["refresh_token"];
    if (accessToken == null || refreshToken == null) {
      throw Exception("Failed to login (Unknown error)");
    }
    await ref
        .read(authCredentialsNotifierProvider.notifier)
        .saveCredentials(
          AuthCredentials(
            accessToken: accessToken,
            refreshToken: refreshToken,
            instanceUrl: "$instanceUrl/api",
          ),
        );
    ref.invalidateSelf();
  }

  Future<void> logout() async {
    await ref.read(authCredentialsNotifierProvider.notifier).clearCredentials();
    ref.invalidateSelf();
  }
}
