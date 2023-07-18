import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:flutter/material.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

import '../../shared/constants/ui.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/';
  const HomeScreen({Key? key, required this.colorTheme}) : super(key: key);
  final ThemeMode colorTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        showModalSideSheet(
          context: context,
          ignoreAppBar: true,
          width: 640,
          barrierColor: Colors.white.withOpacity(barrierOpacity),
          // with blur,
          barrierDismissible: true,
          body: GetTestTokens(
            colorTheme: colorTheme,
          ),
        );
      },
      child: Text('Get test tokens'),
    ));
  }
}
