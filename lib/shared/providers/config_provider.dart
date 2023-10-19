import 'package:faucet/chain/providers/selected_chain_provider.dart';
import 'package:faucet/shared/providers/node_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:topl_common/proto/node/services/bifrost_rpc.pb.dart';

final configProvider = StreamProvider<FetchNodeConfigRes>((ref) async* {
  final selectedChain = ref.watch(selectedChainProvider);
  final nodeClient = ref.watch(nodeProvider(selectedChain));
  final configStream = nodeClient.fetchNodeConfig();

  await for (var value in configStream) {
    yield value;
  }
});
