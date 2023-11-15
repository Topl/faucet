import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';
import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
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
      await tester.runAsync(
        () async {
          await tester.pumpWidget(
            await essentialTestProviderWidget(tester: tester, testScreenSize: testScreenSize, overrides: [
              hivePackageProvider.overrideWithValue(
                getMockRequestHive().mockHive,
              ),
            ]),
          );
          await tester.pumpAndSettle();
          await tester.pumpAndSettle();
          //   click request token button
          await tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));
          await tester.pumpAndSettle();
          await tester.pumpAndSettle();
          Future.delayed(Duration.zero, () {
            tester.tap(find.byKey(TransactionTableScreen.requestTokensKey));
          });

          await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey));
          Future.delayed(Duration.zero, () {
            tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
          });
          Future.delayed(Duration.zero, () {
            expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
          });
          Future.delayed(Duration.zero, () {
            tester.ensureVisible(find.byKey(GetTestTokens.requestTokenButtonKey));
          });
          Future.delayed(Duration.zero, () {
            tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey));
          });

          Future.delayed(Duration.zero, () {
            tester.ensureVisible(find.byKey(SuccessDialog.requestSuccessDialogKey));
          });

          Future.delayed(Duration.zero, () {
            expect(find.byKey(SuccessDialog.requestSuccessDialogKey), findsOneWidget);
          });
          Future.delayed(Duration.zero, () {
            tester.tap(find.bySemanticsLabel('Close'), warnIfMissed: false);
          });
          Future.delayed(Duration.zero, () {
            tester.ensureVisible(find.byKey(GetTestTokens.requestTokenButtonKey));
          });
          Future.delayed(Duration.zero, () {
            tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey));
          });
          Future.delayed(Duration.zero, () {
            expect(find.byKey(ErrorDialog.requestErrorDialogKey), findsOneWidget);
          });
        },
      );
    });
