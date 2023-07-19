import 'package:faucet/chain/models/chains.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:topl_common/genus/services/node_grpc.dart';

final nodeProvider = Provider.family<NodeGRPCService, Chains>((ref, chain) {
  final NodeGRPCService service = NodeGRPCService(host: chain.host, port: chain.port);

  return service;
});