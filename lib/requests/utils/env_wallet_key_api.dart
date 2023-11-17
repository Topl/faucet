import 'dart:convert';
import 'dart:io';

import 'package:brambldart/brambldart.dart' show Either, Unit, VaultStore, WalletKeyApiAlgebra, WalletKeyException;

class JsonWalletKeyApi implements WalletKeyApiAlgebra {
  const JsonWalletKeyApi();

  WalletKeyException _vaultStoreDoesNotExist(name) =>
      WalletKeyException.vaultStoreDoesNotExist(context: "VaultStore at $name does not exist");

  Future<bool> doesEnvVarExist(String name) async {
    final keyFile = Platform.environment[name];
    return keyFile != null;
  }

  /// Updates the main key vault store.
  ///
  /// [mainKeyVaultStore] is the new VaultStore to update to.
  /// [name] is the filepath of the VaultStore to update.
  ///
  /// Returns nothing if successful. Throws an exception if the VaultStore does not exist.
  @override
  Future<Either<WalletKeyException, Unit>> updateMainKeyVaultStore(VaultStore mainKeyVaultStore, String name) async {
    return Either.unit();
  }

  /// Deletes the main key vault store.
  ///
  /// [name] is the filepath of the VaultStore to delete.
  ///
  /// Returns nothing if successful. Throws an exception if the VaultStore does not exist.
  @override
  Future<Either<WalletKeyException, Unit>> deleteMainKeyVaultStore(String name) async {
    return Either.unit();
  }

  /// Persists the main key vault store to disk.
  ///
  /// [mainKeyVaultStore] is the VaultStore to persist.
  /// [name] is the filepath to persist the VaultStore to.
  ///
  /// Returns nothing if successful. If persisting fails due to an underlying cause, returns a WalletKeyException.
  @override
  Future<Either<WalletKeyException, Unit>> saveMainKeyVaultStore(VaultStore mainKeyVaultStore, String name) async {
    return Either.unit();
  }

  /// Retrieves the main key vault store from disk.
  ///
  /// [name] is the filepath of the VaultStore to retrieve.
  ///
  /// Returns the VaultStore for the Topl Main Secret Key if it exists.
  /// If retrieving fails due to an underlying cause, returns a WalletKeyException.
  @override
  Future<Either<WalletKeyException, VaultStore>> getMainKeyVaultStore(String name) async {
    if (await doesEnvVarExist(name)) {
      final json = jsonDecode(Platform.environment[name]!);
      if (json == null) {
        return Either.left(
            WalletKeyException.decodeVaultStore(context: "Vault store {$name} is empty, thus undecodable"));
      }
      try {
        final vs = VaultStore.fromJson(json);
        return vs.isRight
            ? Either.right(vs.right)
            : Either.left(
                WalletKeyException.decodeVaultStore(context: "Vault store {$name} is undecodable, ${vs.left}"));
      } catch (e) {
        return Either.left(WalletKeyException.decodeVaultStore(context: "Vault store {$name} is undecodable"));
      }
    } else {
      return Either.left(WalletKeyException.vaultStoreDoesNotExist(context: name));
    }
  }

  /// Persists the mnemonic to disk.
  ///
  /// [mnemonic] is the mnemonic to persist.
  /// [mnemonicName] is the filepath to persist the mnemonic to.
  ///
  /// Returns nothing if successful. If persisting fails due to an underlying cause, returns a WalletKeyException.
  @override
  Future<Either<WalletKeyException, Unit>> saveMnemonic(List<String> mnemonic, String mnemonicName) async {
    return Either.unit();
  }
}
