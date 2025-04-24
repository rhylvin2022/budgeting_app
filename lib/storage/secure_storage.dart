import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;
  static FlutterSecureStorage? flutterSecureStorage;
  SecureStorage._internal();

  factory SecureStorage() {
    if (_instance == null) {
      flutterSecureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          keyCipherAlgorithm:
              KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        ),
      );
      _instance = SecureStorage._internal();
    }

    return _instance!;
  }

  get getSecureStorage {
    return flutterSecureStorage;
  }

  static Future<SecureStorage?> get instance async {
    return _instance;
  }
}
