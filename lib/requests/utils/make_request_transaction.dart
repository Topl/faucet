import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:brambldart/brambldart.dart';
import 'package:servicekit/servicekit.dart';
import 'package:topl_common/proto/brambl/models/address.pb.dart';
import 'package:topl_common/proto/brambl/models/identifier.pb.dart';
import 'package:topl_common/proto/brambl/models/indices.pb.dart';
import 'package:topl_common/proto/brambl/models/transaction/io_transaction.pb.dart';

import '../../chain/models/chains.dart';
import 'native_grpc_channel.dart' if (dart.library.html) 'web_grpc_channel.dart';

Future<IoTransaction> makeRequestTransaction(Chains selectedChain, int amount, String toAddress) async {
  const testnetId = 0x934b1900;
  final transactionBuilderAPI = TransactionBuilderApi(testnetId, 0);

  const walletKeyApi = WalletKeyApi(FlutterSecureStorage());
  final walletApi = WalletApi(walletKeyApi);

  final mainKey = getFaucetMainKey();
  final childKeys = walletApi.deriveChildKeys(mainKey, Indices(x: 0, y: 0, z: 0));
  final signatureTemplate = SignatureTemplate("ExtendedEd25519", 0);

  final lockTemplate = PredicateTemplate([signatureTemplate], 1);
  final lock = lockTemplate.build([childKeys.vk]);
  final lockAddress = await transactionBuilderAPI.lockAddress(lock.get());
  final toLockAddress = LockAddress(network: testnetId, ledger: 0, id: LockId(value: toAddress.toUtf8()));

  final channel = getChannel(selectedChain);

  LockAddress.

  final utxos = await GenusQueryAlgebra(channel).queryUtxo(fromAddress: lockAddress);
  final transaction = await transactionBuilderAPI.buildSimpleLvlTransaction(
      utxos, lock.get().predicate, lock.get().predicate, toLockAddress, amount);

  return transaction;
}
