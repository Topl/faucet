import 'package:faucet/blocks/models/block.dart';
import 'package:faucet/blocks/utils/utils.dart';
import 'package:topl_common/proto/genus/genus_rpc.pbgrpc.dart';

extension BlockResponseExtension on BlockResponse {
  Block toBlock() {
    return getMockBlock();
  }
}
