import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'required_request_tests.dart';
import 'utils/mock_request_hive_utils.dart';

void main() async {
  final requestTests = RequiredInvalidRequestsTests(
    invalidTestTokenRequest: (testScreenSize) => invalidTestTokenRequest(testScreenSize),
    testScreenSize: TestScreenSizes.tablet,
  );

  await requestTests.runTests();
}

Future<void> invalidTestTokenRequest(TestScreenSizes testScreenSize) async => testWidgets(
      'Tablet - Should fail on invalid test token request',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(tester: tester, testScreenSize: testScreenSize, overrides: [
            hivePackageProvider.overrideWithValue(
              getMockRequestHive().mockHive,
            ),
          ]),
        );
        await tester.pumpAndSettle();
        //   click request token button
        await tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey));
        await tester.pumpAndSettle();
        //   check that the drawer is displayed
        expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
        //   click the request token button
        var requestTokenButton = find.byKey(GetTestTokens.requestTokenButtonKey);

        await tester.ensureVisible(requestTokenButton);
        await tester.pumpAndSettle();
        await tester.tap(requestTokenButton);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(SuccessDialog.requestSuccessDialogKey));
        // first time success message
        expect(find.byKey(SuccessDialog.requestSuccessDialogKey), findsOneWidget);
        // find close button
        await tester.tap(find.byKey(SuccessDialog.closeSuccessDialogKey));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.tap(requestTokenButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.byKey(ErrorDialog.requestErrorDialogKey), findsOneWidget);
      },
    );
