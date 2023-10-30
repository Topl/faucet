import '../required_test_class.dart';

class RequiredRequestsTests extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) menuOpened;

  RequiredRequestsTests({
    required this.menuOpened,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await menuOpened(testScreenSize);
  }
}
