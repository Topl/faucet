import 'package:flutter_test/flutter_test.dart';

import 'essential_test_provider_widget.dart';
import 'utils/tester_utils.dart';

void main() {
  testWidgets(
    'Example test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        await essentialTestProviderWidget(),
      );

      await tester.pump();
      await pendingTimersFix(tester);
    },
  );
}
