import 'package:faucet/requests/models/request.dart';
import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/shared/theme.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_web_view/easy_web_view.dart';

import '../../requests/providers/requests_provider.dart';
import '../../shared/constants/network_name.dart';
import '../../shared/constants/status.dart';

List<String> networks = [
  'Valhalla',
  'Topl Testnet',
];

class GetTestTokens extends HookConsumerWidget {
  static const getTestTokensKey = Key('getTestTokenKey');
  GetTestTokens({Key key = getTestTokensKey, required this.colorTheme}) : super(key: key);
  final TextEditingController textWalletEditingController = TextEditingController();
  final ThemeMode colorTheme;
  final toast = FToast();

  String? selectedNetwork = 'Valhalla';

  bool isCDropDownOpen = false;

  /// validate is used to validate the input field
  bool validate = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
    final notifier = ref.watch(requestProvider.notifier);

    return Container(
      decoration: BoxDecoration(color: getSelectedColor(colorTheme, 0xFFFFFFFF, 0xFF282A2C)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16.0 : 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.getTestNetwork,
              style: headlineLarge(context),
            ),
            const SizedBox(
              height: 48,
            ),
            Container(
              height: 64,
              width: 560,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(112, 64, 236, 0.04),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(
                    Icons.warning_amber,
                    color: getSelectedColor(colorTheme, 0xFF7040EC, 0xFF7040EC),
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      width: 450,
                      child: Text(
                        'Confirm details before submitting',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Rational Display',
                          fontWeight: FontWeight.w300,
                          color: getSelectedColor(colorTheme, 0xFF7040EC, 0xFF7040EC),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 48,
            ),
            TextField(
              controller: TextEditingController(text: 'LVL'),
              enabled: false,
              style: bodyMedium(context),
              decoration: InputDecoration(
                labelText: 'Tokens',
                labelStyle: bodyMedium(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF858E8E),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF858E8E),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF858E8E),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            DropdownButton2(
              hint: const Text(
                'Select a Network',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Rational Display',
                  color: Color(0xFF858E8E),
                ),
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
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              // TODO: Add to accept the address format only
              controller: textWalletEditingController,
              style: bodyMedium(context),
              decoration: InputDecoration(
                labelText: 'Wallet Address',
                labelStyle: bodyMedium(context),
                hintText: '0xxxxxxxxxxxxxxxxxxxxxxxxx',
                suffix: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFC0C4C4),
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    final copiedData = await Clipboard.getData('text/plain');
                    textWalletEditingController.value = TextEditingValue(
                      text: copiedData?.text ?? '',
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: copiedData?.text?.length ?? 0),
                      ),
                    );
                  },
                  child: const Text('Paste'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF858E8E),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF858E8E),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: getSelectedColor(colorTheme, 0xFFC0C4C4, 0xFF858E8E),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Stack(children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      validate ? "This field is required" : '',
                      style: titleSmall(context),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: !isMobile ? 30 : null,
              ),
              const SizedBox(
                  height: 200,
                  child: Positioned(
                      key: Key('recaptcha-widget'),
                      left: 0,
                      top: 0,
                      child: EasyWebView(
                        src:
                            'assets/webpages/index.html', //TODO: direct asset for testing use: http://localhost:PORT/assets/webpages/index.html
                        key: Key('recaptcha-widget'),
                        convertToMarkdown: false,
                        isMarkdown: false, // Use markdown syntax
                        convertToWidgets: false, // Try to convert to flutter widgets
                        height: 150,
                      ))),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: isMobile ? 100 : 272,
                      height: 56,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: titleSmall(context),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: isMobile ? 100 : 272,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          notifier.makeRequest(
                            context,
                            Request(
                              network: NetworkName.testnet,
                              walletAddress: textWalletEditingController.text,
                              status: Status.confirmed,
                              dateTime: DateTime.now(),
                              tokensDisbursed: 100,
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF0DC8D4),
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        child: Text(
                          Strings.getLVL,
                          style: titleSmall(context)!.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomToast extends StatelessWidget {
  const CustomToast({
    Key? key,
    required this.widget,
    required this.cancel,
    required this.isSuccess,
  }) : super(key: key);

  final GetTestTokens widget;
  final VoidCallback cancel;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBreakpoints.of(context).between(TABLET, DESKTOP);
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    return Container(
      height: 64,
      width: isTablet ? 500 : 345,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: getSelectedColor(widget.colorTheme, 0xFFFEFEFE, 0xFF282A2C),
        border: Border.all(
          color: getSelectedColor(widget.colorTheme, 0xFFE0E0E0, 0xFF858E8E),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          isSuccess
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 24,
                )
              : const Icon(
                  Icons.warning_amber,
                  color: Colors.red,
                  size: 24,
                ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              width: 450,
              child: Text(
                isSuccess
                    ? "Network was added ${isMobile ? '\n' : ""} successfully"
                    : "Something went wrong... ${isMobile ? '\n' : ""} Please try again later",
                style: bodyMedium(context),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: cancel,
          ),
        ],
      ),
    );
  }
}

// TODO: Recapcha implementation
//https://pub.dev/packages/easy_web_view
//https://developers.google.com/recaptcha/docs/v3
