// create HookConsumerWidget
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/shared/providers/app_theme_provider.dart';
import 'package:faucet/shared/theme.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<String> networks = [
  'TestNet',
  'Topl Testnet',
];

class CustomTestNetwork extends HookConsumerWidget {
  // create const constructor
  CustomTestNetwork({Key? key}) : super(key: key);
  bool isCDropDownOpen = false;
  String? selectedNetwork = 'TestNet';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return the widget
    final colorTheme = ref.watch(appThemeColorProvider);

    return Container(
        child: DropdownButton2(
      hint: Text(
        Strings.selectANetwork,
        style: bodyMedium(context),
      ),
      style: bodyMedium(context),
      underline: Container(
        height: 0,
      ),
      buttonStyleData: ButtonStyleData(
        height: 56,
        width: 560,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF4B4B4B),
          ),
          color: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        decoration: BoxDecoration(
          color: getSelectedColor(colorTheme, 0xFFFEFEFE, 0xFF282A2C),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
      ),
      iconStyleData: IconStyleData(
        icon: isCDropDownOpen
            ? const Icon(
                Icons.keyboard_arrow_up,
                color: Color(0xFF858E8E),
              )
            : const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF858E8E),
              ),
        iconSize: 20,
      ),
      value: selectedNetwork,
      // Array list of items
      items: networks.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (value) {
        selectedNetwork = value as String;
      },
      onMenuStateChange: (isOpen) {
        isCDropDownOpen = !isCDropDownOpen;
      },
    ));
  }
}
