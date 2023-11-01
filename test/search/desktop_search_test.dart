import 'package:faucet/search/models/search_result.dart';
import 'package:faucet/search/sections/custom_search_bar.dart';
import 'package:faucet/search/sections/search_results.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/shared/utils/decode_id.dart';
import 'package:faucet/transactions/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'required_search_tests.dart';
import 'utils/genus_mock_utils.dart';

void main() async {
  final searchTests = RequiredSearchTests(
    textEntered: (testScreenSize) => textEntered(testScreenSize),
    successfulTransactionSearch: (testScreenSize) => successfulTransactionSearch(testScreenSize),
    successfulBlockSearch: (testScreenSize) => successfulBlockSearch(testScreenSize),
    testScreenSize: TestScreenSizes.desktop,
  );

  await searchTests.runTests();
}

Future<void> textEntered(TestScreenSizes testScreenSize) async =>
    testWidgets('Should show Search Results when text is entered', (WidgetTester tester) async {
      final blockId = createId();
      final transactionId = createId();

      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
          overrides: [
            genusProvider.overrideWith((ref, arg) => getMockSearchGenus(blockId: blockId, transactionId: transactionId))
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(SearchResults.searchResultsKey), findsNothing);

      await tester.enterText(find.byKey(CustomSearchBar.searchKey), blockId);

      await tester.pumpAndSettle();

      expect(find.byKey(SearchResults.searchResultsKey), findsOneWidget);
    });

Future<void> successfulTransactionSearch(TestScreenSizes testScreenSize) async =>
    testWidgets('Should show Transaction when transaction id is Searched', (WidgetTester tester) async {
      final blockId = createId();
      final transactionId = createId();

      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
          overrides: [
            genusProvider.overrideWith((ref, arg) => getMockSearchGenus(blockId: blockId, transactionId: transactionId))
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(SearchResults.searchResultsKey), findsNothing);

      await tester.enterText(find.byKey(CustomSearchBar.searchKey), transactionId);

      await tester.pumpAndSettle();

      expect(find.byKey(SearchResults.searchResultsKey), findsOneWidget);

      final searchItemKey = SearchResultItem(
        colorTheme: ThemeMode.dark,
        resultSelected: (_) {},
        suggestion: TransactionResult(getMockTransaction(), transactionId),
      ).searchResultItemKey();
      print('QQQQ key in test: $searchItemKey');

      expect(find.byKey(searchItemKey), findsOneWidget);
    });

Future<void> successfulBlockSearch(TestScreenSizes testScreenSize) async =>
    testWidgets('Should show Block when block id is Searched', (WidgetTester tester) async {
      final blockId = createId();
      final transactionId = createId();

      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
          overrides: [
            genusProvider.overrideWith((ref, arg) => getMockSearchGenus(blockId: blockId, transactionId: transactionId))
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(SearchResults.searchResultsKey), findsNothing);

      await tester.enterText(find.byKey(CustomSearchBar.searchKey), blockId);

      await tester.pumpAndSettle();

      expect(find.byKey(SearchResults.searchResultsKey), findsOneWidget);
    });
