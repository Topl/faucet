import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/transactions/sections/transaction_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'utils/mock_request_hive_utils.dart';

class DesktopRequestSuccessTokensTest extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) requestTokenTest;

  DesktopRequestSuccessTokensTest({
    required this.requestTokenTest,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await requestTokenTest(testScreenSize);
  }
}

void main() async {
  final requestTests = DesktopRequestSuccessTokensTest(
    requestTokenTest: (testScreenSize) => requestTokenTest(testScreenSize),
    testScreenSize: TestScreenSizes.desktop,
  );

  await requestTests.runTests();
}

Future<void> requestTokenTest(TestScreenSizes testScreenSize) async =>
    testWidgets('Should confirm that tokens are requested ${testScreenSize.name}', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(
            tester: tester,
            testScreenSize: testScreenSize,
            overrides: [hivePackageProvider.overrideWithValue(getMockRequestHive().mockHive)],
          ),
        );
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        Future.delayed(Duration.zero, () {
          tester.ensureVisible(find.byKey(TransactionTableScreen.requestTokensKey));
        });

        await tester.pumpAndSettle();
        await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey), warnIfMissed: false);

        Future.delayed(Duration.zero, () {
          tester.tap(find.byKey(TransactionTableScreen.requestTokensKey), warnIfMissed: false);
        });
        await tester.tap(find.byKey(TransactionTableScreen.requestTokensKey), warnIfMissed: false);

        Future.delayed(Duration.zero, () {
          expect(find.byKey(GetTestTokens.getTestTokensKey), findsOneWidget);
        });

        Future.delayed(Duration.zero, () async {
          await tester.tap(find.byKey(GetTestTokens.requestTokenButtonKey), warnIfMissed: false);
        });
      });
    });
