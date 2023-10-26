import 'package:faucet/home/sections/get_test_tokens.dart';
import 'package:flutter/material.dart';

import 'package:faucet/shared/providers/node_provider.dart';
import 'package:faucet/shared/utils/decode_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';
import 'utils/mock_node_utils.dart';

void main() {
  group('Requests Tests', () {
    testWidgets('Should show confirmation text request is made', (WidgetTester tester) async {
      await tester.pumpWidget(
        await essentialTestProviderWidget(
          overrides: [nodeProvider.overrideWith((ref, arg) => getMockRequestsNode())],
        ),
      );
      await tester.pumpAndSettle();

      var button = find.byKey(const Key('requestTokens'));
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('getTestTokensKey')), findsOneWidget);
    });
  });
}
