// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:faucet/main.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/shared/providers/node_provider.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mocks/genus_mocks.dart';
import 'mocks/hive_mocks.dart';
import 'mocks/node_config_mocks.dart';
import 'required_test_class.dart';

/// The entire application, wrapped in a [ProviderScope].
/// This function exposts a named parameter called [overrides]
/// which is fed forward to the [ProviderScope].
Future<Widget> essentialTestProviderWidget({
  List<Override> overrides = const [],
  required WidgetTester tester,
  required TestScreenSizes testScreenSize,
}) async {
  tester.binding.setSurfaceSize(testScreenSize.size);

  overrides = [
    genusProvider.overrideWith((ref, arg) => getMockGenus()),
    hivePackageProvider.overrideWithValue(getMockHive()),
    nodeProvider.overrideWith((ref, arg) => getMockNodeGRPCService()),
    ...overrides,
  ];
  TestWidgetsFlutterBinding.ensureInitialized();

  return ProviderScope(
    overrides: overrides,
    // child: const ResponsiveBreakPointsWrapper(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: const ResponsiveBreakPointsWrapper(),
      ),
    ),
  );
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final ByteData data = await load(key);
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<ByteData> load(String key) async => rootBundle.load(key);
}
