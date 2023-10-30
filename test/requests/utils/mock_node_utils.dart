import 'package:mockito/mockito.dart';
import 'package:topl_common/genus/services/node_grpc.dart';

import '../../mocks/node_mocks.mocks.dart';
import '../../utils/transaction_utils.dart';

NodeGRPCService getMockRequestsNode() {
  MockNodeGRPCService mockNode = MockNodeGRPCService();

  when(mockNode.broadcastTransaction(
    transaction: anyNamed('transaction'),
  )).thenAnswer(
    (realInvocation) async {
      return getMockBroadcastTransactionRes();
    },
  );

  return mockNode;
}
