import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/extended-libraries/webviewx/providers/webview_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod/src/state_notifier_provider.dart';
import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import '../utils/tester_utils.dart';
import 'utils/mock_request_hive_utils.dart';

class TabletRequestTokensTest extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize, String token) requestTokenTestTablet;

  TabletRequestTokensTest({
    required this.requestTokenTestTablet,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    const testToken = 'test_token_123';
    await requestTokenTestTablet(testScreenSize, testToken);
  }
}

void main() async {
  final requestTests = TabletRequestTokensTest(
    requestTokenTestTablet: (testScreenSize, token) => requestTokenTestTablet(testScreenSize, token),
    testScreenSize: TestScreenSizes.tablet,
  );

  await requestTests.runTests();
}

Future<void> requestTokenTestTablet(TestScreenSizes testScreenSize, String testToken) async =>
    testWidgets('Should confirm that tokens are requested ${testScreenSize.name}', (WidgetTester tester) async {
      final container = ProviderContainer();
      container.read(tokenProvider.notifier).setToken(testToken);
      await tester.runAsync(() async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(
            tester: tester,
            testScreenSize: testScreenSize,
            overrides: [
              hivePackageProvider.overrideWithValue(getMockRequestHive().mockHive),
            ],
          ),
        );
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();

        //   click request token button
        Future.delayed(Duration.zero, () {
          tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));
        });
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey), warnIfMissed: false);

        Future.delayed(Duration.zero, () {
          expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
        });
        Future.delayed(Duration.zero, () {
          tester.pumpAndSettle();
        });

        Future.delayed(Duration.zero, () async {
          await tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
        });

        Future.delayed(Duration.zero, () async {
          await tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
        });
        Future.delayed(Duration.zero, () {
          expect(find.byKey(SuccessDialog.requestSuccessDialogKey), findsOneWidget);
        });
      });
    });
