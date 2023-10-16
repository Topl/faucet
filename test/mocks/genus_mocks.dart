import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:topl_common/genus/services/transaction_grpc.dart';
import 'package:topl_common/proto/consensus/models/block_header.pb.dart';
import 'package:topl_common/proto/genus/genus_rpc.pb.dart';
import 'package:topl_common/proto/node/models/block.pb.dart';

import 'genus_mocks.mocks.dart';

@GenerateMocks([GenusGRPCService])
GenusGRPCService getMockGenus() {
  MockGenusGRPCService mockGenus = MockGenusGRPCService();

  when(mockGenus.getBlockByDepth(
    confidence: anyNamed('confidence'),
    depth: anyNamed('depth'),
    options: anyNamed('options'),
  )).thenAnswer(
    (realInvocation) async => BlockResponse(
      block: FullBlock(
        header: BlockHeader(),
        fullBody: FullBlockBody(),
      ),
    ),
  );

  return mockGenus;
}
