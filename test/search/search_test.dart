import 'package:flutter_test/flutter_test.dart';

import '../essential_test_provider_widget.dart';

void main() {
  testWidgets('Successful Search Query', (WidgetTester tester) async {
    await tester.pumpWidget(
      await essentialTestProviderWidget(),
    );
    await tester.pump();
  });
}
