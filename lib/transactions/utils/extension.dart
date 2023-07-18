import 'package:faucet/transactions/models/transaction.dart';
import 'package:faucet/transactions/utils/utils.dart';
import 'package:topl_common/proto/genus/genus_rpc.pbgrpc.dart';

extension TransactionResponseExtension on TransactionResponse {
  // TODO: Implement once response models are finalized
  Transaction toTransaction() {
    return getMockTransaction();
  }
}
