import '../required_test_class.dart';

class RequiredSelectedChainTest extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) changeNetwork;

  RequiredSelectedChainTest({
    required this.changeNetwork,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await changeNetwork(testScreenSize);
  }
}
