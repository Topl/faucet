import '../required_test_class.dart';

class RequiredSearchTests extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) textEntered;

  RequiredSearchTests({
    required this.textEntered,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await textEntered(testScreenSize);
  }
}
