import 'package:faucet/chain/sections/chainname_dropdown.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:faucet/shared/widgets/footer.dart';
import 'package:faucet/shared/widgets/header.dart';
import 'package:faucet/shared/widgets/layout.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  static const route = '/';
  const HomeScreen({Key? key, required this.colorTheme}) : super(key: key);
  final ThemeMode colorTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = ref.watch(appThemeColorProvider);
    return CustomLayout(
      header: Header(
        logoAsset: colorTheme == ThemeMode.light ? 'assets/icons/logo.svg' : 'assets/icons/logo_dark.svg',
        onSearch: () {},
        onDropdownChanged: (String value) {},
      ),
      mobileHeader: ChainNameDropDown(
        colorTheme: colorTheme,
      ),
      content: Container(
        decoration: BoxDecoration(
          color: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
        ),
        child: const SizedBox(child: TransactionTableScreen()),
      ),
      footer: Container(
        color: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
        child: const Footer(),
      ),
    );
  }
}
