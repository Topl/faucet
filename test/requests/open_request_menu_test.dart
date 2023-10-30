import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import './required_request_tests.dart';

void main() async {
  final requestsTests = RequiredRequestsTests(
    menuOpened: (testScreenSize) => menuOpened(testScreenSize),
    testScreenSize: TestScreenSizes.desktop,
  );

  await requestsTests.runTests();
}

Future<void> menuOpened(TestScreenSizes testScreenSize) async {
  testWidgets('Request tokens menu should appear', (WidgetTester tester) async {
    await tester.pumpWidget(
      await essentialTestProviderWidget(
        tester: tester,
        testScreenSize: testScreenSize,
      ),
    );
    await tester.pumpAndSettle();

    final scrollable = find.byKey(const Key("transactionTableKey"));
    expect(scrollable, findsOneWidget);
    var button = find.byKey(TransactionTableScreen.requestTokensKey);
    await tester.ensureVisible(button);
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
  });
}
