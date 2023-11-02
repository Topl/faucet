import '../required_test_class.dart';

class RequiredChainTests extends RequiredTest {
  Future<void> Function(TestScreenSizes testScreenSize) changeSelectedChain;

  RequiredChainTests({
    required this.changeSelectedChain,
    required super.testScreenSize,
  });

  Future<void> runTests() async {
    await changeSelectedChain(testScreenSize);
  }
}
