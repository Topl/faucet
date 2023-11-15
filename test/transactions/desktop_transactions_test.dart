import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'required_transactions_tests.dart';

void main() async {
  final transactionTableTests = RequiredTransactionsTest(
      transactionLoaded: (testScreenSize) => transactionLoaded(testScreenSize),
      testScreenSize: TestScreenSizes.desktop);
  await transactionTableTests.runTests();
}

Future<void> transactionLoaded(TestScreenSizes testScreenSize) async =>
    testWidgets('Desktop - Should show transaction table when transactions are loaded', (WidgetTester tester) async {
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
      });
    });
