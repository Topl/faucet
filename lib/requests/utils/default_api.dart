import 'package:brambldart/brambldart.dart';
import 'package:brambldart/src/crypto/encryption/vault_store.dart';

class defaultApi implements WalletKeyApiAlgebra {
  @override
  Future<Either<WalletKeyException, Unit>> saveMainKeyVaultStore(VaultStore mainKeyVaultStore, String name) async {
    // TODO: Implement the method to persist the VaultStore.
    throw UnimplementedError('saveMainKeyVaultStore() is not yet implemented');
  }

  @override
  Future<Either<WalletKeyException, Unit>> saveMnemonic(List<String> mnemonic, String mnemonicName) async {
    // TODO: Implement the method to persist the mnemonic.
    throw UnimplementedError('saveMnemonic() is not yet implemented');
  }

  @override
  Future<Either<WalletKeyException, VaultStore>> getMainKeyVaultStore(String name) async {
    // TODO: Implement the method to retrieve the VaultStore.
    throw UnimplementedError('getMainKeyVaultStore() is not yet implemented');
  }

  @override
  Future<Either<WalletKeyException, Unit>> updateMainKeyVaultStore(VaultStore mainKeyVaultStore, String name) async {
    // TODO: Implement the method to update the VaultStore.
    throw UnimplementedError('updateMainKeyVaultStore() is not yet implemented');
  }

  @override
  Future<Either<WalletKeyException, Unit>> deleteMainKeyVaultStore(String name) async {
    // TODO: Implement the method to delete the VaultStore.
    throw UnimplementedError('deleteMainKeyVaultStore() is not yet implemented');
  }
}
