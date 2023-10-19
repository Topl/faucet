import 'package:faucet/search/sections/custom_search_bar.dart';
import 'package:faucet/search/sections/search_results.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/shared/utils/decode_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import 'utils/genus_mock_utils.dart';

void main() {
  group('Search Tests', () {
    testWidgets('Should show Search Results when text is entered', (WidgetTester tester) async {
      final blockId = createId();
      final transactionId = createId();
      await tester.pumpWidget(
        await essentialTestProviderWidget(
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
  });
}
