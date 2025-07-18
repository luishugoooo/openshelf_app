import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:openshelf_app/routes/shared/nav/sidebar.dart';

class HomeScreenShell extends ConsumerWidget {
  final Widget body;

  const HomeScreenShell({super.key, required this.body});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakpoints = context.theme.breakpoints; // FBreakpoints
    final width = MediaQuery.sizeOf(context).width; // double
    final currentPath = GoRouterState.of(context).uri.path;

    return FScaffold(
      childPad: false,
      header: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: width < breakpoints.md
              ? SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: () {
                            showFSheet(
                              context: context,
                              builder: (context) => OpenShelfSidebar(
                                currentPath: currentPath,
                                key: key,
                              ),
                              side: FLayout.ltr,
                            );
                          },
                          iconSize: 22,
                          icon: Icon(FIcons.menu),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "OpenShelf",
                            style: context.theme.typography.xl.copyWith(
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                    ],
                  ),
                )
              : null,
        ),
      ),
      sidebar: width > breakpoints.md
          ? OpenShelfSidebar(key: key, currentPath: currentPath)
          : null,

      child: body,
    );
  }
}
