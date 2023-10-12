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
      print('QQQQ 1');
      await tester.pump();
      print('QQQQ 2');
      await pendingTimersFix(tester);
      print('QQQQ 3');
    },
  );
}
