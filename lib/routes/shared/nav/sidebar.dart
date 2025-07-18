import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:openshelf_app/api/auth/auth.dart';
import 'package:openshelf_app/api/auth/credentials.dart';
import 'package:openshelf_app/api/library/books.dart';
import 'package:openshelf_app/router.dart';

class OpenShelfSidebar extends ConsumerWidget {
  final String currentPath;

  const OpenShelfSidebar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FSidebar.raw(
      header: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                spacing: 8,
                children: [
                  FAvatar.raw(
                    size: 32,
                    child: Icon(
                      FIcons.userRound,
                      size: 20,
                      color: context.theme.colors.mutedForeground,
                    ),
                  ),
                  Expanded(
                    child: ref
                        .watch(authNotifierProvider)
                        .when(
                          data: (user) {
                            if (user == null) {
                              return const SizedBox.shrink();
                            }
                            final instance = ref.watch(
                              authCredentialsNotifierProvider,
                            );
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      user.email,
                                      style: context.theme.typography.sm
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Icon(
                                      user.isOnline
                                          ? FIcons.cloud
                                          : FIcons.cloudOff,
                                      size: 16,

                                      color: user.isOnline
                                          ? Colors.green[600]
                                          : context
                                                .theme
                                                .colors
                                                .mutedForeground,
                                    ),
                                  ],
                                ),
                                Text(
                                  "${user.role}@${instance?.instanceUrl.replaceAll(RegExp(r"https?://"), "")}",
                                  style: context.theme.typography.xs.copyWith(
                                    color: context.theme.colors.mutedForeground,
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Loading...",
                                style: context.theme.typography.sm.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Authenticating...",
                                style: context.theme.typography.xs.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                          error: (error, stack) => const SizedBox.shrink(),
                        ),
                  ),
                ],
              ),
              FDivider(
                style: FDividerStyle(
                  color: context.theme.colors.border,
                  padding: EdgeInsets.only(top: 10),
                ).call,
              ),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          children: [
            FButton(
              style: FButtonStyle.secondary(),
              onPress: () {
                ref.invalidate(booksNotifierProvider);
              },
              child: const Text('Sync'),
            ),
            FButton(
              style: FButtonStyle.secondary(),
              onPress: () {
                ref.invalidate(authNotifierProvider);
              },
              child: const Text('Invalidate auth'),
            ),
            FButton(
              style: FButtonStyle.secondary(),
              onPress: () {
                ref.read(booksNotifierProvider.notifier).clearLocalCache();
              },
              child: const Text('Clear local cache'),
            ),
            FButton(
              style: FButtonStyle.secondary(),
              onPress: () {
                showFDialog(
                  context: context,
                  builder: (context, style, animation) => FDialog.adaptive(
                    style: style.call,
                    animation: animation,
                    //direction: Axis.horizontal,
                    title: const Text('Logout?  '),
                    body: const Text(
                      'This will disconnect you from the current instance. Local data will be removed and you will need to sync again on login.',
                    ),
                    actions: [
                      FButton(
                        style: FButtonStyle.outline(),
                        onPress: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      FButton(
                        onPress: () async {
                          Navigator.of(context).pop();
                          await ref
                              .read(authNotifierProvider.notifier)
                              .logout();
                          ref.read(goRouterProvider).go("/login");
                        },
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                );
                //ref.read(authNotifierProvider.notifier).logout();
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (final route in homeRoutes)
              FSidebarItem(
                selected: currentPath == route.path,
                icon: Icon(route.icon),
                label: Text(route.label),
                onPress: () {
                  context.go(route.path);
                  // Close the sheet if it's open (for mobile navigation)
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
