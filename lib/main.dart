import 'package:faucet/home/screens/home_screen.dart';
import 'package:faucet/shared/constants/ui.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vrouter/vrouter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  await Hive.initFlutter();

  runApp(
    ProviderScope(
      child: ResponsiveBreakpoints.builder(
        child: const FaucetRouter(),
        breakpoints: const [
          Breakpoint(start: 0, end: mobileBreak, name: MOBILE),
          Breakpoint(start: mobileBreak + 1, end: tabletBreak, name: TABLET),
          Breakpoint(start: tabletBreak + 1, end: double.infinity, name: DESKTOP),
        ],
      ),
    ),
  );
}

class FaucetRouter extends HookConsumerWidget {
  const FaucetRouter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VRouter(
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
