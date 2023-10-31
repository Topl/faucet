import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
// import '../mocks/genus_mocks.dart';
import '../mocks/node_mocks.dart';
import '../required_test_class.dart';
import 'required_request_tests.dart';

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
          await essentialTestProviderWidget(
            tester: tester,
            testScreenSize: testScreenSize,
          ),
        );
        await tester.pumpAndSettle();
        //   click request token button
        await tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokenButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TransactionTableScreen.requestTokenButtonKey));
        await tester.pumpAndSettle();
        expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
        //   check that the drawer is displayed
        //   click the request token button

        //   check that the error message is displayed
      },
    );
