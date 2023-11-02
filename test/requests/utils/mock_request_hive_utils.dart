import 'package:faucet/shared/services/hive/hives.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

import '../../shared/mocks/hive_mocks.dart';
import '../../shared/mocks/hive_mocks.mocks.dart';

HiveInterface getMockRequestHive() {
  HiveInterface mockHive = getMockHive();
  when(mockHive.box(HivesBox.rateLimit.id).get(any)).thenAnswer((realInvocation) => '');
  return mockHive;
}
