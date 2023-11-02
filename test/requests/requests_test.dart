import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/requests/models/request.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/constants/network_name.dart';
import 'package:faucet/shared/constants/status.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../essential_test_provider_widget.dart';
// import '../mocks/genus_mocks.dart';
import '../mocks/node_mocks.dart';
import '../required_test_class.dart';
import '../shared/mocks/request_provider_mock.dart';
import 'required_request_tests.dart';
import 'utils/mock_request_hive_utils.dart';

void main() async {
  final requestTests = RequiredRequestsTests(
    menuOpened: (testScreenSize) => invalidTestTokenRequest(testScreenSize),
    testScreenSize: TestScreenSizes.desktop,
  );

  await requestTests.runTests();
}

Future<void> invalidTestTokenRequest(TestScreenSizes testScreenSize) async => testWidgets(
      'Should fail on invalid test token request',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(tester: tester, testScreenSize: testScreenSize, overrides: [
            hivePackageProvider.overrideWithValue(
              getMockRequestHive(),
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
        await tester.ensureVisible(find.byKey(ErrorDialog.requestErrorDialogKey));
        expect(find.byKey(ErrorDialog.requestErrorDialogKey), findsOneWidget);
        // await tester.pumpAndSettle();
        // await tester.tap(requestTokenButton);
        // expect(find.byKey(SuccessDialog.requestSuccessDialogKey), findsOneWidget);
        //   check that the error message is displayed
      },
    );
