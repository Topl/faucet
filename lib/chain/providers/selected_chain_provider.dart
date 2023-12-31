import 'package:faucet/chain/models/chains.dart';
import 'package:faucet/chain/utils/chain_utils.dart';
import 'package:faucet/shared/services/hive/hive_service.dart';
import 'package:faucet/shared/services/hive/hives.dart';
import 'package:faucet/shared/utils/get_dev_mode.dart';
import 'package:faucet/shared/utils/hive_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedChainProvider = StateProvider<Chains>((ref) {
  return getDefaultChain();
});

final chainsProvider = StateNotifierProvider<ChainsNotifier, AsyncValue<List<Chains>>>((ref) {
  return ChainsNotifier(ref);
});

class ChainsNotifier extends StateNotifier<AsyncValue<List<Chains>>> {
  final Ref ref;
  ChainsNotifier(this.ref) : super(const AsyncLoading()) {
    _getAvailableChains(setState: true);
  }

  /// It takes a bool [setState]
  ///
  /// If [setState] is true, it will update the state of the provider
  /// If [setState] is false, it will not update the state of the provider
  Future<List<Chains>> _getAvailableChains({
    bool setState = false,
  }) async {
    final List<Chains> customChains = [];
    final Iterable<dynamic> hiveData = await ref.read(hiveProvider).getAllItems(boxType: HivesBox.customChains);
    hiveData.toList().forEach((element) {
      final Map<String, dynamic> hiveJson = convertHashMapToMap(element);
      try {
        customChains.add(Chains.fromJson(hiveJson));
      } catch (e) {
        print('Error parsing custom chain: $e');
      }
    });

    final List<Chains> devChains = [const Chains.private_network(), const Chains.dev_network(), const Chains.mock()];
    // dev notes: This will have to be updated when we change the predetermined networks
    final List<Chains> standardChains = [
      const Chains.topl_mainnet(),
      const Chains.testnet(),
      if (getDevMode()) ...devChains
    ];

    //state holds both standard and custom chains
    final allChains = [...standardChains, ...customChains];

    if (setState) {
      state = AsyncData(allChains);
    }

    return allChains;
  }

  test() {
    switch (Chains) {
      case Chains.topl_mainnet:
        break;
      case Chains.testnet:
        break;
      case Chains.private_network:
        break;
      case Chains.dev_network:
        break;
      case Chains.mock:
        break;
      case Chains.custom:
        break;
    }
  }

  /// Add ad custom chain
  /// Make sure to add to state
  /// And make sure the input is a CustomNetwork (See the chains class)
  Future<void> addCustomChain({required CustomNetwork chain}) async {
    final chains = state.asData?.value;

    if (chains == null) {
      throw Exception('Error in chainsProvider: chains are null');
    }

    //validate chain
    validateCustomChain(chain);

    //search for duplicate
    // final dupeIndex = chains.indexWhere((element) => element.hostUrl == chain.hostUrl && element.port == chain.port);
    // if (dupeIndex >= 0) {
    //   throw Exception('Cannot add a duplicate chain');
    // }

    //add to cache
    await ref.read(hiveProvider).putItem(boxType: HivesBox.customChains, key: chain.chainId, value: chain.toJson());

    //add new custom chain to state
    state = AsyncData([...chains, chain]);
  }

  Future<void> removeCustomChain({required String chainId}) async {
    final chains = state.asData?.value;

    if (chains == null) {
      throw Exception('Error in chainsProvider: chains are null');
    }

    await ref.read(hiveProvider).deleteItem(boxType: HivesBox.customChains, key: chainId);

    chains.removeWhere((element) => element is CustomNetwork && element.chainId == chainId);
    state = AsyncData(chains);
    ref.read(selectedChainProvider.notifier).state = getDefaultChain();
  }
}
