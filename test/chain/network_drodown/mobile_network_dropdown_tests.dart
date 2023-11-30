import 'package:faucet/chain/models/chains.dart';
import 'package:faucet/chain/sections/chainname_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../essential_test_provider_widget.dart';
import '../../required_test_class.dart';
import '../../shared/navigation/header_navigation.dart';
import '../../utils/tester_utils.dart';
import 'required_network_dropdown_tests.dart';

void main() async {
  final chainTests = RequiredNetworkDropdownTests(
    clickNetworkDropdown: (testScreenSize) => clickNetworkDropdown(testScreenSize),
    testScreenSize: TestScreenSizes.mobile,
  );

  await chainTests.runTests();
}

Future<void> clickNetworkDropdown(testScreenSize) async =>
    testWidgets('Mobile : Ensures all networks are in the dropdown when clicked', (WidgetTester tester) async {
      await tester.pumpWidget(
        await essentialTestProviderWidget(
          tester: tester,
          testScreenSize: testScreenSize,
          overrides: [],
        ),
      );

      await tester.pumpAndSettle();

      await openMobileHeader(tester);
      await pumpTester(tester, loops: 100);

      expect(find.byKey(Key(const Chains.private_network().key)), findsNothing);
      expect(find.byKey(Key(const Chains.dev_network().key)), findsOneWidget);

      expect(find.byKey(ChainNameDropDown.mobileDropDownKey), findsOneWidget);

      await tester.tap(find.byKey(ChainNameDropDown.mobileDropDownKey));

      await tester.pumpAndSettle();

      expect(find.byKey(Key(const Chains.dev_network().key)),
          findsNWidgets(2)); // two because it has the selected network and another one on the dropdown
      expect(find.byKey(Key(const Chains.private_network().key)), findsOneWidget);
      expect(find.byKey(Key(const Chains.topl_mainnet().key)), findsOneWidget);
      expect(find.byKey(Key(const Chains.mock().key)), findsOneWidget);
      expect(find.byKey(Key(const Chains.valhalla_testnet().key)), findsOneWidget);
    });
