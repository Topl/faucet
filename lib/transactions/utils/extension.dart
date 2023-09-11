import 'package:faucet/transactions/models/transaction.dart';
import 'package:topl_common/proto/genus/genus_rpc.pbgrpc.dart';

import 'utils.dart';

extension TransactionResponseExtension on TransactionResponse {
  // TODO: Implement once response models are finalized
  Transaction toTransaction() {
    return getMockTransaction();
  }
}
