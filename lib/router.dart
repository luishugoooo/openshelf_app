import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:openshelf_app/api/auth/auth.dart';
import 'package:openshelf_app/routes/home/home.dart';
import 'package:openshelf_app/routes/home/search.dart';
import 'package:openshelf_app/routes/home/shell.dart';
import 'package:openshelf_app/routes/loading.dart';
import 'package:openshelf_app/routes/login.dart';
import 'package:openshelf_app/routes/reading/reader_screen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.freezed.dart';
part 'router.g.dart';

@freezed
abstract class HomeRoute with _$HomeRoute {
  const factory HomeRoute({
    required String path,
    required String label,
    required IconData icon,
  }) = _HomeRoute;
}

final homeRoutes = [
  HomeRoute(path: "/", label: "Home", icon: FIcons.library),
  HomeRoute(path: "/search", label: "Search", icon: FIcons.search),
];

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final routerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "goRouter");
  final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "homeRouter");

  final router = GoRouter(
    navigatorKey: routerNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: "/loading",
    routes: [
      GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
      GoRoute(path: "/loading", builder: (context, state) => LoadingScreen()),
      ShellRoute(
        navigatorKey: homeNavigatorKey,
        builder: (context, state, child) => HomeScreenShell(body: child),
        routes: [
          GoRoute(
            path: "/",
            pageBuilder: (context, state) =>
                NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: "/search",
            pageBuilder: (context, state) =>
                NoTransitionPage(child: SearchScreen()),
          ),
        ],
      ),
      GoRoute(
        path: "/read/:bookId",
        builder: (context, state) =>
            ReaderScreen(bookId: int.parse(state.pathParameters["bookId"]!)),
      ),
    ],
    redirect: (context, state) async {
      final authedUser = await ref.read(authNotifierProvider.future);
      if (authedUser == null) {
        return "/login";
      }
      if (state.uri.path == "/loading") {
        return "/";
      }

      return null;
    },
  );
  ref.onDispose(router.dispose);
  return router;
}
