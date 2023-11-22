import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import '../utils/tester_utils.dart';
import 'utils/mock_request_hive_utils.dart';

class MobileRequestSuccessTokensTest extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) requestTokenTest;

  MobileRequestSuccessTokensTest({
    required this.requestTokenTest,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await requestTokenTest(testScreenSize);
  }
}

void main() async {
  final requestTests = MobileRequestSuccessTokensTest(
    requestTokenTest: (testScreenSize) => requestTokenTest(testScreenSize),
    testScreenSize: TestScreenSizes.mobile,
  );
  await requestTests.runTests();
}

Future<void> requestTokenTest(TestScreenSizes testScreenSize) async =>
    testWidgets('Should confirm that tokens are requested ${testScreenSize.name}', (WidgetTester tester) async {
      (WidgetTester tester) async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(
            tester: tester,
            testScreenSize: testScreenSize,
            overrides: [hivePackageProvider.overrideWithValue(getMockRequestHive().mockHive)],
          ),
        );

        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));

        await customRunAsync(tester, test: () async {
          await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey));
        });
        await tester.pump();

        expect(find.byKey(GetTestTokens.getTestTokensKey), findsWidgets);
        await tester.pump();
        await tester.ensureVisible(find.byKey(GetTestTokens.requestTokenButtonKey));
        await tester.pump();

        await customRunAsync(tester, test: () async {
          await tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
        });
        await tester.pumpAndSettle();
        await tester.pump();
        await customRunAsync(tester, test: () async {
          expect((find.byKey(SuccessDialog.requestSuccessDialogKey)), findsOneWidget);
        });
        await tester.pumpAndSettle();
      };
    });
