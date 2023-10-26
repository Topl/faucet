import 'package:faucet/shared/services/hive/hives.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'hive_mocks.mocks.dart';

@GenerateMocks([HiveInterface, Box])
HiveInterface getMockHive() {
  MockHiveInterface mockHive = MockHiveInterface();

  for (var element in HivesBox.values) {
    switch (element) {
      case HivesBox.customChains:
        when(mockHive.openBox(HivesBox.customChains.id)).thenAnswer((_) async {
          return getMockCustomChains();
        });
        break;
      case HivesBox.rateLimit:
        when(mockHive.openBox(HivesBox.rateLimit.id)).thenAnswer((_) async {
          return getMockRateLimit();
        });
        break;
    }
  }

  return mockHive;
}

Box getMockCustomChains() {
  MockBox mockCustomChainsBox = MockBox();

  when(mockCustomChainsBox.values).thenAnswer((realInvocation) {
    return [];
  });

  return mockCustomChainsBox;
}

Box getMockRateLimit() {
  MockBox mockRateLimitBox = MockBox();

  when(mockRateLimitBox.values).thenAnswer((realInvocation) {
    return [];
  });

  return mockRateLimitBox;
}
