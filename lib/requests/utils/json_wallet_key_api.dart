import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:brambldart/brambldart.dart'
    show Either, Unit, VaultStore, WalletKeyApiAlgebra, WalletKeyException, WithResultExtension;

class JsonWalletKeyApi implements WalletKeyApiAlgebra {
  const JsonWalletKeyApi();

  WalletKeyException _vaultStoreDoesNotExist(name) =>
      WalletKeyException.vaultStoreDoesNotExist(context: "VaultStore at $name does not exist");

  Future<void> writeToJSONFile(String name, dynamic data) async {
    // final directory = await getApplicationDocumentsDirectory();
    // final filePath = File('${directory.path}/$name.json');
    final scriptPath = Platform.script.toFilePath();
    final scriptDirectory = Directory(File(scriptPath).parent.path);

    final filePath = File('${scriptDirectory.path}/$name.json');

    final jsonString = jsonEncode(data);

    await filePath.writeAsString(jsonString);
  }

  Future<bool> doesFileExist(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = File('${directory.path}/$name.json');

    return filePath.exists();
  }

  Future<void> deleteFile(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = File('${directory.path}/$name.json');

    if (await filePath.exists()) {
      await filePath.delete();
    }
  }

  Future<dynamic> readJSONFile(String name) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = File('${directory.path}/$name.json');

      if (!(await filePath.exists())) {
        // Handle the case where the file doesn't exist
        return null;
      }

      final jsonString = await filePath.readAsString();
      return jsonDecode(jsonString);
    } catch (e) {
      // Handle any errors that occur during file reading or JSON decoding
      return null;
    }
  }

  /// Updates the main key vault store.
  ///
  /// [mainKeyVaultStore] is the new VaultStore to update to.
  /// [name] is the filepath of the VaultStore to update.
  ///
  /// Returns nothing if successful. Throws an exception if the VaultStore does not exist.
  @override
  Future<Either<WalletKeyException, Unit>> updateMainKeyVaultStore(VaultStore mainKeyVaultStore, String name) async {
    if (await doesFileExist(name)) {
      (await saveMainKeyVaultStore(mainKeyVaultStore, name)).withResult((res) => res);
      return Either.unit();
    } else {
      return Either.left(_vaultStoreDoesNotExist(name));
    }
  }

  /// Deletes the main key vault store.
  ///
  /// [name] is the filepath of the VaultStore to delete.
  ///
  /// Returns nothing if successful. Throws an exception if the VaultStore does not exist.
  @override
  Future<Either<WalletKeyException, Unit>> deleteMainKeyVaultStore(String name) async {
    if (await doesFileExist(name)) {
      await deleteFile(name);
      return Either.unit();
    } else {
      return Either.left(_vaultStoreDoesNotExist(name));
    }
  }

  /// Persists the main key vault store to disk.
  ///
  /// [mainKeyVaultStore] is the VaultStore to persist.
  /// [name] is the filepath to persist the VaultStore to.
  ///
  /// Returns nothing if successful. If persisting fails due to an underlying cause, returns a WalletKeyException.
  @override
  Future<Either<WalletKeyException, Unit>> saveMainKeyVaultStore(VaultStore mainKeyVaultStore, String name) async {
    await writeToJSONFile(name, mainKeyVaultStore.toJson());
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
    if (await doesFileExist(name)) {
      final json = await readJSONFile(name);
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
    if (await doesFileExist(mnemonicName)) {
      await writeToJSONFile(mnemonicName, jsonEncode(mnemonic));
      return Either.unit();
    } else {
      return Either.left(WalletKeyException.mnemonicDoesNotExist(context: mnemonicName));
    }
  }
}
