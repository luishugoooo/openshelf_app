import 'package:openshelf_app/api/auth/types.dart';
import 'package:openshelf_app/api/local/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'credentials.g.dart';

@riverpod
class AuthCredentialsNotifier extends _$AuthCredentialsNotifier {
  @override
  AuthCredentials? build() {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final accessToken = sharedPreferences.getString("accessToken");
    final refreshToken = sharedPreferences.getString("refreshToken");
    final instanceUrl = sharedPreferences.getString("instanceUrl");
    if (accessToken == null || refreshToken == null || instanceUrl == null) {
      return null;
    }
    return AuthCredentials(
      accessToken: accessToken,
      refreshToken: refreshToken,
      instanceUrl: instanceUrl,
    );
  }

  Future<void> saveCredentials(AuthCredentials credentials) async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.setString("accessToken", credentials.accessToken);
    await sharedPreferences.setString("refreshToken", credentials.refreshToken);
    await sharedPreferences.setString("instanceUrl", credentials.instanceUrl);
    ref.invalidateSelf();
  }

  Future<void> clearCredentials() async {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    await sharedPreferences.remove("accessToken");
    await sharedPreferences.remove("refreshToken");
    await sharedPreferences.remove("instanceUrl");
    await sharedPreferences.remove("user");
    ref.invalidateSelf();
  }
}
