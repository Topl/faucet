import 'package:faucet/home/widgets/custom_dropdown.dart';
import 'package:faucet/requests/models/request.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/constants/network_name.dart';
import 'package:faucet/shared/constants/status.dart';
import 'package:faucet/shared/constants/strings.dart';
import 'package:faucet/shared/theme.dart';
import 'package:faucet/shared/utils/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/utils/source_type.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/utils/utils.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/view/impl/web.dart';
import 'package:faucet/shared/extended-libraries/webviewx/src/controller/controller.dart';

class GetTestTokens extends HookConsumerWidget {
  static const getTestTokensKey = Key('getTestTokensKey');
  static const lvlInputKey = Key('lvlInputKey');
  static const selectNetworkKey = Key('selectNetworkKey');
  static const addressInputKey = Key('addressInputKey');
  static const recaptchaWidgetKey = Key('recaptcha-widget');
  static const requestTokenButtonKey = Key('requestTokenButtonKey');
  GetTestTokens({Key key = getTestTokensKey, required this.colorTheme}) : super(key: key);
  final TextEditingController textWalletEditingController = TextEditingController();
  final ThemeMode colorTheme;
  final toast = FToast();

  String? selectedNetwork = 'Valhalla';

  late WebViewXController webviewController;
  final initialContent = '<div></div>';

  /// validate is used to validate the input field
  bool validate = false;

  /// validate is used to validate the input field
  Future<void> verifyToken(token) async {
    final callbackResponse = await webviewController.callJsMethod('callDartCallback', []);
    token.value = callbackResponse.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
    final notifier = ref.watch(requestProvider.notifier);
    final token = useState('');

    useEffect(() {
      Future.delayed(const Duration(seconds: 1), () {
        webviewController.loadContent(
          'http://localhost:PORT/assets/webpages/index.html', //REPLACE PORT with local port
          SourceType.url,
        );
      });
      return null;
    }, []);

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
              key: lvlInputKey,
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
            CustomTestNetwork(
              key: selectNetworkKey,
            ),
            const SizedBox(
              height: 24,
            ),
            TextField(
              key: addressInputKey,
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
              WebViewX(
                key: recaptchaWidgetKey,
                initialContent: initialContent,
                initialSourceType: SourceType.html,
                height: 220,
                width: 400,
                onWebViewCreated: (controller) => webviewController = controller,
                dartCallBacks: const {},
              ),
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
                        key: requestTokenButtonKey,
                        onPressed: () async {
                          await verifyToken(token);
                          if (token.value.isEmpty) {
                            // ignore: use_build_context_synchronously
                            errorDialogBuilder(context, 'Please verify reCaptcha');
                          } else {
                            // ignore: use_build_context_synchronously
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
                          }
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
