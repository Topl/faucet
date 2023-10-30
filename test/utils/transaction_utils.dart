import 'package:faucet/shared/utils/decode_id.dart';
import 'package:fixnum/fixnum.dart';
import 'package:topl_common/proto/brambl/models/address.pb.dart';
import 'package:topl_common/proto/brambl/models/box/value.pb.dart';
import 'package:topl_common/proto/brambl/models/datum.pb.dart';
import 'package:topl_common/proto/brambl/models/event.pb.dart';
import 'package:topl_common/proto/brambl/models/identifier.pb.dart';
import 'package:topl_common/proto/brambl/models/transaction/io_transaction.pb.dart';
import 'package:topl_common/proto/brambl/models/transaction/schedule.pb.dart';
import 'package:topl_common/proto/brambl/models/transaction/spent_transaction_output.pb.dart';
import 'package:topl_common/proto/brambl/models/transaction/unspent_transaction_output.pb.dart';
import 'package:topl_common/proto/node/services/bifrost_rpc.pb.dart';
import 'package:topl_common/proto/quivr/models/shared.pb.dart';

getMockIoTransaction({
  String id = '1',
}) {
  return IoTransaction(
    datum: Datum_IoTransaction(
      event: Event_IoTransaction(
        schedule: Schedule(
          max: Int64(2),
          min: Int64(1),
          timestamp: Int64(
            DateTime.now().millisecondsSinceEpoch,
          ),
        ),
        metadata: SmallData(
          value: [],
        ),
      ),
    ),
    inputs: [
      _getSpentTransactionOutput(id: id),
    ],
    outputs: [
      _getUnspentTransactionOutput(),
    ],
    transactionId: _getTransactionId(id),
  );
}

getMockBroadcastTransactionRes() {
  return BroadcastTransactionRes();
}

TransactionId _getTransactionId(String id) {
  return TransactionId(
    value: encodeId(id),
  );
}

UnspentTransactionOutput _getUnspentTransactionOutput() {
  return UnspentTransactionOutput(
    address: LockAddress.getDefault(),
    value: Value(
      lvl: Value_LVL(
        quantity: Int128(
          value: [100],
        ),
      ),
    ),
  );
}

SpentTransactionOutput _getSpentTransactionOutput({
  required String id,
}) {
  return SpentTransactionOutput(
    address: TransactionOutputAddress(
      id: TransactionId(value: encodeId(id)),
      index: 1,
      ledger: 1,
      network: 1,
    ),
    value: Value(
      lvl: Value_LVL(
        quantity: Int128(
          value: [100],
        ),
      ),
    ),
  );
}
