import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../mocks/genus_mocks.dart';
import '../required_test_class.dart';

void main() {
  group(
    'Request Tests',
    () {
      testWidgets(
        'Should fail on invalid test token request',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            await essentialTestProviderWidget(
              tester: tester,
              testScreenSize: TestScreenSizes.desktop,
              overrides: [
                genusProvider.overrideWith(
                  (ref, arg) => getMockGenus(),
                ),
              ],
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
    },
  );
}
