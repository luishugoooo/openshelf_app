import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:openshelf_app/api/auth/auth.dart';
import 'package:openshelf_app/router.dart';
import 'package:openshelf_app/routes/shared/util.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final instanceUrlController = TextEditingController(
    text: "http://localhost:3000",
  );
  final emailController = TextEditingController(text: "test@test.com");
  final passwordController = TextEditingController(text: "password");
  @override
  Widget build(BuildContext context) {
    return FScaffold(
      child: SizedBox(
        width: 500,
        child: Column(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ref
                .watch(authNotifierProvider)
                .when(
                  data: (data) => Text(data?.email ?? "Logged out"),
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const Text("Loading..."),
                ),
            FTextField(
              label: Text("Instance URL"),
              controller: instanceUrlController,
              keyboardType: TextInputType.url,
            ),
            FTextField(
              label: Text("Email"),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            FTextField(label: Text("Password"), controller: passwordController),
            SizedBox(height: 16),
            Builder(
              builder: (context) {
                return FButton(
                  onPress: () async {
                    try {
                      await ref
                          .read(authNotifierProvider.notifier)
                          .login(
                            email: emailController.text,
                            password: passwordController.text,
                            instanceUrl: instanceUrlController.text,
                          );
                      ref.read(goRouterProvider).go("/");
                    } on Exception catch (e) {
                      if (context.mounted) {
                        final message = e.toString();
                        showAppToast(
                          message: message,
                          icon: FIcons.triangleAlert,
                          context: context,
                        );
                      }
                    }
                  },
                  child: Text("Login"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
