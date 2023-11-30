import '../../required_test_class.dart';

class RequiredNetworkDropdownTests extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) clickNetworkDropdown;

  RequiredNetworkDropdownTests({
    required this.clickNetworkDropdown,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await clickNetworkDropdown(testScreenSize);
  }
}
