import 'package:faucet/blocks/models/block.dart';
import 'package:faucet/transactions/models/transaction.dart';
import 'package:faucet/transactions/models/utxo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult.transaction(
    Transaction transaction,
    String id,
  ) = TransactionResult;
  const factory SearchResult.block(
    Block block,
    String id,
  ) = BlockResult;

  const factory SearchResult.uTxO(
    UTxO utxo,
    String id,
  ) = UTxOResult;
}
