import 'package:faucet/shared/utils/decode_id.dart';
import 'package:mockito/mockito.dart';
import 'package:topl_common/genus/services/transaction_grpc.dart';

import '../../shared/mocks/genus_mocks.mocks.dart';
import '../../utils/block_utils.dart';
import '../../utils/transaction_utils.dart';

GenusGRPCService getMockSearchGenus({
  required String blockId,
  required String transactionId,
}) {
  MockGenusGRPCService mockGenus = MockGenusGRPCService();

  when(mockGenus.getBlockByDepth(
    confidence: anyNamed('confidence'),
    depth: anyNamed('depth'),
    options: anyNamed('options'),
  )).thenAnswer(
    (realInvocation) async {
      return getMockBlockResponse(blockId: blockId, transactionId: createId());
    },
  );

  when(mockGenus.getBlockByHeight(
    confidence: anyNamed('confidence'),
    height: anyNamed('height'),
    options: anyNamed('options'),
  )).thenAnswer(
    (realInvocation) async {
      return getMockBlockResponse(blockId: blockId, transactionId: createId());
    },
  );

  when(mockGenus.getTransactionById(transactionIdString: transactionId)).thenAnswer((realInvocation) async {
    return getMockTransactionResponse(id: transactionId, blockId: blockId);
  });

  when(mockGenus.getTransactionById(transactionIdString: anyNamed('transactionIdString')))
      .thenAnswer((realInvocation) async {
    return getMockTransactionResponse(id: transactionId, blockId: blockId);
  });

  when(mockGenus.getBlockById(blockIdString: blockId)).thenAnswer((realInvocation) async {
    return getMockBlockResponse(blockId: blockId, transactionId: transactionId);
  });

  return mockGenus;
}
