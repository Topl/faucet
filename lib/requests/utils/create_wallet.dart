import 'package:brambldart/brambldart.dart';
import 'package:dotenv/dotenv.dart';
import './json_wallet_key_api.dart';
import 'dart:io';

Future<void> createWallet() async {
  //load in variables needed
  final dotenv = DotEnv(includePlatformEnvironment: true);
  dotenv.load();

  //make wallet
  const walletKeyApi = JsonWalletKeyApi();
  final walletApi = WalletApi(walletKeyApi);
  final walletResult = await walletApi.createAndSaveNewWallet(
    dotenv['PASSWORD']!.toUtf8(),
    passphrase: dotenv['PASSPHRASE']!,
    name: dotenv['NAME']!,
  );
  walletResult.right;
}

Future<void> createLockAddress(KeyPair keypair) async {
  final signatureTemplate = SignatureTemplate("ExtendedEd25519", 0);
  final locktemplate = PredicateTemplate([signatureTemplate], 1);
  final lock = locktemplate.build([keypair.verificationKey]);

  final transactionBuilderApi = TransactionBuilderApi(0x934b1900, 0);
  transactionBuilderApi.lockAddress(lock.get());
}
