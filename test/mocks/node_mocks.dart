import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:topl_common/genus/services/node_grpc.dart';
import '../utils/transaction_utils.dart';
import 'node_mocks.mocks.dart';

@GenerateMocks([NodeGRPCService])
NodeGRPCService getMockGenus() {
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
