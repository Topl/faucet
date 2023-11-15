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
    await tester.runAsync(() async {
      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
      Future.delayed(Duration.zero, () {
        expect(find.byKey(const Key("transactionTableKey")), findsOneWidget);
      });
      await tester.pumpAndSettle();
      Future.delayed(Duration.zero, () {
        tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));
      });
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey), warnIfMissed: false);
      Future.delayed(Duration.zero, () {
        expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
      });
    });
  });
}
