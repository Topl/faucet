import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';
import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import '../utils/tester_utils.dart';
import 'required_request_tests.dart';
import 'utils/mock_request_hive_utils.dart';

void main() async {
  final requestTests = RequiredInvalidRequestsTests(
    invalidTestTokenRequest: (testScreenSize) => invalidTestTokenRequest(testScreenSize),
    testScreenSize: TestScreenSizes.mobile,
  );

  await requestTests.runTests();
}

Future<void> invalidTestTokenRequest(TestScreenSizes testScreenSize) async =>
    testWidgets('Mobile - Should fail on invalid test token request', (WidgetTester tester) async {
      (WidgetTester tester) async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(
            tester: tester,
            testScreenSize: testScreenSize,
            overrides: [hivePackageProvider.overrideWithValue(getMockRequestHive().mockHive)],
          ),
        );

        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));

        await customRunAsync(tester, test: () async {
          await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey));
          await Future.delayed(const Duration(milliseconds: 700));
        });
        await tester.pump();

        expect(find.byKey(GetTestTokens.getTestTokensKey), findsWidgets);
        await tester.pump();
        await tester.ensureVisible(find.byKey(GetTestTokens.requestTokenButtonKey));
        await tester.pump();

        await customRunAsync(tester, test: () async {
          await tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
        });

        await tester.pumpAndSettle();
        await tester.pump();

        await customRunAsync(tester, test: () async {
          expect((find.byKey(SuccessDialog.requestSuccessDialogKey)), findsOneWidget);
        });

        await tester.pumpAndSettle();
        await tester.tap(find.byKey(SuccessDialog.closeSuccessDialogKey));
        await tester.pumpAndSettle();

        expect(find.byKey(GetTestTokens.getTestTokensKey), findsWidgets);
        await tester.pump();

        await tester.ensureVisible(find.byKey(GetTestTokens.requestTokenButtonKey));
        await tester.pump();

        await customRunAsync(tester, test: () async {
          await tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
        });
        await tester.pump();
        await customRunAsync(tester, test: () async {
          expect((find.byKey(ErrorDialog.requestErrorDialogKey)), findsOneWidget);
        });
      };
    });
