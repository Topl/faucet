import 'package:mockito/mockito.dart';

import '../../shared/mocks/hive_mocks.dart';

MockHiveResponse getMockRequestHive() {
  MockHiveResponse mockHiveResponse = getMockHive();

  when(mockHiveResponse.mockRateLimitBox.get('rateLimitHiveKey', defaultValue: null)).thenAnswer(
    (realInvocation) => DateTime.now(),
  );
  return mockHiveResponse;
}
