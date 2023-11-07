import '../required_test_class.dart';

class RequiredTransactionsTest extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) transactionLoaded;

  RequiredTransactionsTest({
    required this.transactionLoaded,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await transactionLoaded(testScreenSize);
  }
}
