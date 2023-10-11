// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:faucet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final ByteData data = await load(key);
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<ByteData> load(String key) async => rootBundle.load(key);
}

Future<void> main({
  List<Override> overrides = const [],
}) async {
  runApp(DefaultAssetBundle(
    bundle: TestAssetBundle(),
    child: await essentialTestProviderWidget(overrides: overrides),
  ));
}

/// The entire application, wrapped in a [ProviderScope].
/// This function exposts a named parameter called [overrides]
/// which is fed forward to the [ProviderScope].
Future<Widget> essentialTestProviderWidget({
  List<Override> overrides = const [],
}) async {
  overrides = [
    ...overrides,
  ];
  WidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: const ResponsiveBreakPointsWrapper(),
      ),
    ),
  );
}
