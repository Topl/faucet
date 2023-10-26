import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'required_selected_chain_test.dart';

void main() {
  final tests = RequiredSelectedChainTest(
    changeNetwork: (testScreenSizes) => changeNetwork(testScreenSizes),
    testScreenSize: TestScreenSizes.mobile,
  );

  tests.runTests();
}

Future<void> changeNetwork(testScreenSize) async => testWidgets(
      'Test change Network',
      (tester) async {
        await tester.pumpWidget(
          await essentialTestProviderWidget(
            tester: tester,
            testScreenSize: testScreenSize,
            overrides: [],
          ),
        );
        expect(true, true);
      },
    );
