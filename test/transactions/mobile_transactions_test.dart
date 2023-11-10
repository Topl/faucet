import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'required_transactions_tests.dart';

void main() async {
  final transactionTableTests = RequiredTransactionsTest(
      transactionLoaded: (testScreenSize) => transactionLoaded(testScreenSize), testScreenSize: TestScreenSizes.mobile);
  await transactionTableTests.runTests();
}

Future<void> transactionLoaded(TestScreenSizes testScreenSize) async =>
    testWidgets('Mobile - Should show transaction table when transactions are loaded', (WidgetTester tester) async {
      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(TransactionTableScreen.transactionsTableKey), findsOneWidget);
    });
