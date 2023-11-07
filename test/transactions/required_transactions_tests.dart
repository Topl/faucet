import '../required_test_class.dart';

class RequiredTransactionsTest extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) menuOpened;

  RequiredTransactionsTest({
    required this.menuOpened,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await menuOpened(testScreenSize);
  }
}
