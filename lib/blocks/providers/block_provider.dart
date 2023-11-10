import 'package:faucet/blocks/models/block.dart';
import 'package:faucet/blocks/utils/utils.dart';
import 'package:faucet/chain/models/chains.dart';
import 'package:faucet/chain/providers/selected_chain_provider.dart';
import 'package:faucet/chain/utils/constants.dart';
import 'package:faucet/shared/providers/config_provider.dart';
import 'package:faucet/shared/providers/genus_provider.dart';
import 'package:faucet/transactions/utils/utils.dart';
import 'package:topl_common/proto/node/services/bifrost_rpc.pb.dart';
import 'package:topl_common/proto/genus/genus_rpc.pb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Returns a block at the depth
///
/// IMPORTANT: Only use this provider AFTER the blockProvider has been initialized
/// Ex.
/// ```
/// final blockProvider = ref.watch(blockProvider);
/// blockProvider.when(
///   data: (data) {
///    // Use data here
///    ref.watch(blockStateAtDepthProvider(index));
///    ...
///   },
///   ...
///   );
/// ```
final blockStateAtDepthProvider = FutureProvider.family<Block, int>((ref, depth) async {
  return ref.watch(blockProvider.notifier).getBlockFromStateAtDepth(depth);
});

/// Returns a block at the height
///
/// IMPORTANT: Only use this provider AFTER the blockProvider has been initialized
/// Ex.
/// ```
/// final blockProvider = ref.watch(blockProvider);
/// blockProvider.when(
///   data: (data) {
///    // Use data here
///    ref.watch(blockStateAtHeightProvider(index));
///    ...
///   },
///   ...
///   );
/// ```
final blockStateAtHeightProvider = FutureProvider.family<Block, int>((ref, height) async {
  return ref.watch(blockProvider.notifier).getBlockFromStateAtHeight(height);
});

/// Returns a list of blocks since decentralization
///
/// The function calculates the spacing between elements and creates a list of
/// heights to get the blocks from. It then loops through the list and gets the
/// blocks at each height. If an error occurs, the loop is broken and the
/// function returns the blocks that were successfully retrieved.
///
/// The function requires a [Ref] object to be passed in.
Future<List<Block>> getBlocksSinceDecentralization({
  required Ref ref,
}) async {
  // Get the block at depth 0 to determine the current height
  final depth0Block = await ref.read(blockStateAtDepthProvider(0).future);
  final height = depth0Block.height;

  // Calculate the spacing between elements
  double spacing = height / (minimumResults - 1);

  // Create the list and add elements from quack to 0
  List<int> myList = List<int>.generate(minimumResults, (index) {
    if (index == 0) {
      return height;
    } else {
      int value = (height - (spacing * index)).round();
      return value >= 0 ? value : 0;
    }
  });

  List<Block> blocks = [];

  // Loop through the list and get the blocks
  for (int i = 0; i < myList.length - 1; i++) {
    try {
      final currentHeight = myList[i];
      final block = await ref.read(blockStateAtHeightProvider(currentHeight).future);
      blocks.add(block);
    } catch (e) {
      break;
    }
  }

  return blocks;
}

final getBlockByIdProvider = FutureProvider.family<Block, String>((ref, header) async {
  return ref.read(blockProvider.notifier).getBlockFromStateById(header);
});

final blockProvider = StateNotifierProvider<BlockNotifier, AsyncValue<Map<int, Block>>>((ref) {
  /// Notes:
  /// We'll need to watch for the selectedChain here since we will need to know which
  /// instance of Genus to target
  final selectedChain = ref.watch(selectedChainProvider);
  final config = ref.watch(configProvider.future);

  return BlockNotifier(
    ref,
    selectedChain,
    config,
  );
});

class BlockNotifier extends StateNotifier<AsyncValue<Map<int, Block>>> {
  final Chains selectedChain;
  final Ref ref;
  final Future<FetchNodeConfigRes> config;
  BlockNotifier(
    this.ref,
    this.selectedChain,
    this.config,
  ) : super(
          const AsyncLoading(),
        ) {
    // Commented out for now since blocks are not needed for the faucet
    // getLatestBlocks(setState: true);
  }

  /// It takes a bool [setState]
  ///
  /// If [setState] is true, it will update the state of the provider
  /// If [setState] is false, it will not update the state of the provider
  Future<List<Block>> getLatestBlocks({bool setState = false}) async {
    if (selectedChain == const Chains.mock()) {
      if (setState) state = const AsyncLoading();
      final List<Block> blocks = List.generate(100, (index) => getMockBlock());
      if (setState) {
        state = AsyncData(
          blocks.asMap(),
        );
      }
      return blocks;
    }

    try {
      final genusClient = ref.read(genusProvider(selectedChain));

      if (setState) state = const AsyncLoading();
      //futures
      final List<Block> blocks = [];
      const pageLimit = 10;
      final presentConfig = await config;

      final block0Res = await genusClient.getBlockByDepth(depth: 0);
      blocks.add(
        Block.fromBlockRes(
          blockRes: block0Res,
          epochLength: presentConfig.config.epochLength.toInt(),
        ),
      );

      //fetch more blocks with block0 as the reference for a fixed depth
      for (int i = 1; i < pageLimit; i++) {
        final blockRes = await genusClient.getBlockByHeight(height: blocks[0].height - i);
        blocks.add(
          Block.fromBlockRes(
            blockRes: blockRes,
            epochLength: presentConfig.config.epochLength.toInt(),
          ),
        );
      }

      // Adding delay here to simulate API call
      if (setState) {
        state = AsyncData(blocks.asMap());
      }
      return blocks;
    } catch (e) {
      throw Exception('Error in blockProvider: $e');
    }
  }

  /// This method is used to get a block at a specific depth
  /// If the block is not in the state, it will fetch the block from Genus
  /// It takes an [index] as a parameter
  ///
  /// It returns a [Future<Block>]
  Future<Block> getBlockFromStateAtDepth(int depth) async {
    var blocks = state.asData?.value;

    if (blocks == null) {
      throw Exception('Error in blockProvider: blocks are null');
    }

    // If the index is less than the length of the list, return the block at that index
    if (blocks[depth] != null) {
      return blocks[depth]!;
    } else {
      blocks = {...blocks};
      // Get the next block by height from Genus
      final genusClient = ref.read(genusProvider(selectedChain));

      //convert depth to height (depth is fixed in reference to block0)
      final blockAtDepth0 = blocks[0];
      if (blockAtDepth0 == null) {
        throw Exception('Error in blockProvider: blockAtDepth0 is null');
      }
      final desiredHeight = blockAtDepth0.height - depth;

      final blockRes = await genusClient.getBlockByHeight(height: desiredHeight);
      final presentConfig = await config;
      // Add that block to state's list
      var newBlock = Block.fromBlockRes(
        blockRes: blockRes,
        epochLength: presentConfig.config.epochLength.toInt(),
      );
      blocks[depth] = newBlock;

      // Sort the blocks by depth so that they are in order
      final sortedBlocks = sortBlocksByDepth(blocks: blocks);
      state = AsyncData(sortedBlocks);

      // Return that block
      return newBlock;
    }
  }

  /// This will get a block at a specific height
  /// If the block is not in the state, it will fetch the block from Genus
  /// It takes an [index] as a parameter
  ///
  /// It returns a [Future<Block>]
  Future<Block> getBlockFromStateAtHeight(int height) async {
    var blocks = state.asData?.value;

    if (blocks == null) {
      throw Exception('Error in blockProvider: blocks are null');
    }

    final blockAtDepth0 = blocks[0];

    if (blockAtDepth0 == null) {
      throw Exception('Error in blockProvider: blockAtDepth0 is null');
    }

    if (blockAtDepth0.height < height) {
      throw Exception('Error in blockProvider: height is greater than the height of the latest block');
    }

    final depth = blockAtDepth0.height - height;

    // If the index is less than the length of the list, return the block at that index
    if (blocks[depth] != null) {
      return blocks[depth]!;
    } else {
      blocks = {...blocks};
      // Get the next block by height from Genus
      final genusClient = ref.read(genusProvider(selectedChain));
      final blockRes = await genusClient.getBlockByHeight(height: height);
      final presentConfig = await config;
      // Add that block to state's list
      var newBlock = Block.fromBlockRes(
        blockRes: blockRes,
        epochLength: presentConfig.config.epochLength.toInt(),
      );
      blocks[depth] = newBlock;

      // Sort the blocks by depth so that they are in order
      final sortedBlocks = sortBlocksByDepth(blocks: blocks);
      state = AsyncData(sortedBlocks);

      // Return that block
      return newBlock;
    }
  }

  Future<BlockResponse> getNextPopulatedBlock({required int height}) async {
    var blocks = state.asData?.value;
    if (blocks == null) {
      throw Exception('Error in blockProvider: blocks are null');
    }

    final genusClient = ref.read(genusProvider(selectedChain));
    var nextBlock = await genusClient.getBlockByHeight(height: height);
    //check that block has transactions
    while (!nextBlock.block.fullBody.hasField(1)) {
      height--;
      nextBlock = await genusClient.getBlockByHeight(height: height);
    }

    final blockAtDepth0 = blocks[0];
    if (blockAtDepth0 == null) {
      throw Exception('Error in blockProvider: blockAtDepth0 is null');
    }

    final depth = blockAtDepth0.height - height;

    //not in state
    if (blocks[depth] == null) {
      blocks = {...blocks};
      final sortedBlocks = sortBlocksByDepth(blocks: blocks);
      state = AsyncData(sortedBlocks);
    }

    return nextBlock;
  }

  Future<Block> getBlockFromStateById(String header) async {
    var blocks = state.asData?.value;

    if (blocks == null) {
      throw Exception('Error in block provider: blocks are null');
    }

    // If the state contains the block, return it

    try {
      return blocks.values.firstWhere((element) => element.header == header);
    } catch (e) {
      final genusClient = ref.read(genusProvider(selectedChain));

      final config = ref.read(configProvider.future);
      final presentConfig = await config;

      var blockRes = await genusClient.getBlockById(blockIdString: header);

      final block = Block.fromBlockRes(
        blockRes: blockRes,
        epochLength: presentConfig.config.epochLength.toInt(),
      );

      // Set the state
      blocks = {...blocks};
      // Get blocks depth
      final depth = blocks[0]!.height - block.height;
      if (depth < 0) {
        blocks[0] = block;
      } else {
        blocks[depth] = block;
      }
      final sortedBlocks = sortBlocksByDepth(blocks: blocks);
      state = AsyncData(sortedBlocks);

      return block;

      // Set the state to the new block
    }
  }
}

final getFirstPopulatedBlockProvider =
    FutureProvider.autoDispose.family<BlockResponse, Chains>((ref, selectedChain) async {
  int depth = 0;
  final genusClient = ref.read(genusProvider(selectedChain));
  var nextBlock = await genusClient.getBlockByDepth(depth: depth);

  // Get the current time
  final startTime = DateTime.now();

  //check that block has transactions
  while (!nextBlock.block.fullBody.hasField(1)) {
    // This will break the loop after 20 seconds
    // Get the current time in each iteration
    final currentTime = DateTime.now();
    // Calculate the elapsed time
    final elapsedTime = currentTime.difference(startTime);
    // If the elapsed time is greater than the desired duration, break the loop
    if (elapsedTime > const Duration(seconds: 20)) {
      print('QQQQ overtime');
      // replace 10 with your desired duration in seconds
      throw ('Error in blockProvider: getFirstPopulatedBlockProvider took too long');
    }

    depth++;
    nextBlock = await genusClient.getBlockByDepth(depth: depth);
  }

  return nextBlock;
});
