import 'package:faucet/chain/models/chain.dart';
import 'package:faucet/chain/models/chains.dart';
import 'package:faucet/chain/utils/chain_utils.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/shared/providers/node_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:topl_common/genus/data_extensions.dart';
import 'package:topl_common/genus/services/node_grpc.dart';
import 'package:topl_common/genus/services/transaction_grpc.dart';
import 'package:topl_common/proto/consensus/models/block_header.pb.dart';
import 'package:topl_common/proto/node/services/bifrost_rpc.pbgrpc.dart';
import 'selected_chain_provider.dart';

final last10BlockHeadersProvider = FutureProvider<List<BlockHeader>>((ref) async {
  final selectedChain = ref.watch(selectedChainProvider);
  final GenusGRPCService genusClient = ref.read(genusProvider(selectedChain));

  final List<BlockHeader> last10Blocks = [];

  for (int i = 0; i < 10; i++) {
    final block = await genusClient.getBlockByDepth(depth: i);
    final blockHeader = block.block.header;
    last10Blocks.add(blockHeader);
  }

  return last10Blocks;
});

final chainProvider = StateNotifierProvider<ChainNotifier, AsyncValue<Chain>>((ref) {
  /// Adding some dev notes here
  ///
  /// THIS STILL NEEDS TO BE TESTED!
  ///
  /// Watching selected chain here and providing to the notifier
  /// Ideally, when the chain is changed, the notifier should be updated
  /// Since Annulus will support the ability to add new chains, we cant have pre-defined providers for each chain
  ///
  /// In Ribn we have a similar use case where we have a selected chain
  /// but we have individual providers for each chain since it currently only supports 3 chains
  final selectedChain = ref.watch(selectedChainProvider);

  return ChainNotifier(
    ref,
    selectedChain,
  );
});

class ChainNotifier extends StateNotifier<AsyncValue<Chain>> {
  final Chains selectedChain;
  final Ref ref;

  final GenusGRPCService genusClient;
  final NodeGRPCService nodeClient;

  ChainNotifier(
    this.ref,
    this.selectedChain,
  )   : genusClient = ref.read(genusProvider(selectedChain)),
        nodeClient = ref.read(nodeProvider(selectedChain)),
        super(
          const AsyncLoading(),
        ) {
    getSelectedChain(setState: true);
  }

  /// TODO: Implements with dart gRPC client
  ///
  /// It takes a bool [setState]
  ///
  /// If [setState] is true, it will update the state of the provider
  /// If [setState] is false, it will not update the state of the provider
  Future<Chain> getSelectedChain({bool setState = false}) async {
    if (setState) state = const AsyncLoading();

    final Chain chain = selectedChain == Chains.mock ? getMockChain() : await _getLiveChain();

    // Adding delay here to simulate API call
    if (setState) {
      state = AsyncData(chain);
    }

    return chain;
  }

  Future<Chain> _getLiveChain() async {
    try {
      final FetchEpochDataRes chainData = await nodeClient.fetchEpochData(epoch: 1);

      //////// Data Throughput ////////
      final int dataBytes = chainData.epochData.dataBytes.toInt();

      final int startTimestamp = chainData.epochData.startTimestamp.toInt();

      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

      final double dataThroughput =
          double.parse((dataBytes / ((currentTimestamp - startTimestamp) / 1000)).toStringAsFixed(2));

      //////// Average Transaction fee ////////
      final int totalTransactionsInEpoch = chainData.epochData.transactionCount.toInt();
      final totalTransactionReward = chainData.epochData.totalTransactionReward.toBigInt();

      final double averageTransactionFee = totalTransactionReward.toInt() / totalTransactionsInEpoch;

      //////// Average Block Time ////////

      final int totalBlocks = chainData.epochData.endHeight.toInt();

      final int averageBlockTime = ((currentTimestamp - startTimestamp) / 1000 / totalBlocks).round();

      //////// Others ////////
      final int eon = chainData.epochData.eon.toInt();

      final int era = chainData.epochData.era.toInt();

      final int epoch = chainData.epochData.epoch.toInt();

      final int endHeight = chainData.epochData.endHeight.toInt();

      final activeStakes = chainData.epochData.activeStake.toBigInt().toInt();

      final inactiveStakes = chainData.epochData.inactiveStake.toBigInt().toInt();

      final totalStakes = activeStakes + inactiveStakes;

      final Chain chain = Chain(
        dataThroughput: dataThroughput,
        averageTransactionFee: averageTransactionFee,
        // TODO: This is not yet implemented in the API
        uniqueActiveAddresses: 0,
        eon: eon,
        era: era,
        epoch: epoch,
        totalTransactionsInEpoch: totalTransactionsInEpoch,
        height: endHeight,
        averageBlockTime: averageBlockTime,
        totalStake: activeStakes / totalStakes,
        registeredStakes: totalStakes,
        activeStakes: activeStakes,
        inactiveStakes: inactiveStakes,
      );
      return chain;
    } catch (e) {
      throw ('Error retrieving chain data $e');
    }
  }
}
