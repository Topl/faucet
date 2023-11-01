import '../required_test_class.dart';

class RequiredSearchTests extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) textEntered;
  Future<void> Function(TestScreenSizes testScreenSize) successfulTransactionSearch;
  Future<void> Function(TestScreenSizes testScreenSize) successfulBlockSearch;

  RequiredSearchTests({
    required this.textEntered,
    required super.testScreenSize,
    required this.successfulTransactionSearch,
    required this.successfulBlockSearch,
  });

  Future<void> runTests() async {
    // await textEntered(testScreenSize);
    await successfulTransactionSearch(testScreenSize);
    // await successfulBlockSearch(testScreenSize);
  }
}
