import 'package:faucet/home/screens/home_screen.dart';
import 'package:faucet/shared/constants/ui.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/theme.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vrouter/vrouter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ResponsiveBreakPointsWrapper(),
    ),
  );
}

class ResponsiveBreakPointsWrapper extends StatelessWidget {
  final Widget? child;
  const ResponsiveBreakPointsWrapper({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final targetChild = child ?? const FaucetRouter();

    return ResponsiveBreakpoints.builder(
      child: targetChild,
      breakpoints: const [
        Breakpoint(start: 0, end: mobileBreak, name: MOBILE),
        Breakpoint(start: mobileBreak + 1, end: tabletBreak, name: TABLET),
        Breakpoint(start: tabletBreak + 1, end: double.infinity, name: DESKTOP),
      ],
    );
  }
}

class FaucetRouter extends HookConsumerWidget {
  const FaucetRouter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakPoints = ResponsiveBreakpoints.of(context).breakpoints;
    return breakPoints.isEmpty
        ? Container()
        : VRouter(
            debugShowCheckedModeBanner: false,
            title: 'Faucet',
            initialUrl: HomeScreen.route,
            theme: lightTheme(context: context),
            darkTheme: darkTheme(context: context),
            themeMode: ref.watch(appThemeColorProvider),
            routes: [
              VWidget(
                path: HomeScreen.route,
                widget: HomeScreen(
                  colorTheme: ref.watch(appThemeColorProvider),
                ),
              ),
            ],
          );
  }
}
