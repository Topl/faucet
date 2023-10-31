import 'package:faucet/chain/models/chains.dart';
import 'package:faucet/chain/sections/chainname_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import '../required_test_class.dart';
import 'required_chain_tests.dart';

void main() async {
  final chainTests = RequiredChainTests(
    changeSelectedChain: (testScreenSize) => changeSelectedChain(testScreenSize),
    testScreenSize: TestScreenSizes.desktop,
  );

  await chainTests.runTests();
}

Future<void> changeSelectedChain(testScreenSize) async =>
    testWidgets('Should change selected chain when a different chain is selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
          overrides: [],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(Key(const Chains.private_network().key)), findsNothing);
      expect(find.byKey(Key(const Chains.dev_network().key)), findsOneWidget);

      expect(find.byKey(ChainNameDropDown.desktopDropDownKey), findsOneWidget);

      await tester.tap(find.byKey(ChainNameDropDown.desktopDropDownKey));

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key(const Chains.private_network().key)));

      await tester.pumpAndSettle();

      expect(find.byKey(Key(const Chains.dev_network().key)), findsNothing);
      expect(find.byKey(Key(const Chains.private_network().key)), findsOneWidget);
    });
