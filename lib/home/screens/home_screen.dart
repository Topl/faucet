import 'package:faucet/chain/sections/chainname_dropdown.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:faucet/shared/widgets/footer.dart';
import 'package:faucet/shared/widgets/header.dart';
import 'package:faucet/shared/widgets/layout.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import '../../main.dart';
import '../../shared/constants/strings.dart';
import '../../shared/constants/ui.dart';
import '../sections/get_test_tokens.dart';

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

          // child: TransactionTableScreen(),
          child: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xFF0DC8D4),
                    ),
                    child: TextButton(
                      key: TransactionTableScreen.requestTokensKey,
                      onPressed: () {
                        Navigator.of(context).pop();
                        showModalSideSheet(
                          context: context,
                          ignoreAppBar: true,
                          width: 640,
                          barrierColor: Colors.white.withOpacity(barrierOpacity),
                          barrierDismissible: true,
                          body: ResponsiveBreakPointsWrapper(
                            child: GetTestTokens(
                              // Assuming this is the content you want to display
                              colorTheme: colorTheme,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        Strings.requestTokens,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
      footer: Container(
        color: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
        child: const Footer(),
      ),
    );
  }
}
