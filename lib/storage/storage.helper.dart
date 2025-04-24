import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static StorageHelper? _instance;
  static FlutterSecureStorage? flutterSecureStorage;

  StorageHelper._internal();

  factory StorageHelper() {
    if (_instance == null) {
      flutterSecureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
            keyCipherAlgorithm:
                KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
            storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding),
      );
      _instance = StorageHelper._internal();
    }

    return _instance!;
  }

  get getSecureStorage {
    return flutterSecureStorage;
  }

  Future<void> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      prefs.setBool('first_run', false);
      await flutterSecureStorage!.deleteAll();
    }
  }

  static Future<StorageHelper?> get instance async {
    return _instance;
  }

  addSecuredData(String key, String value) async {
    if (!kIsWeb) {
      await checkFirstTime();
    }
    await flutterSecureStorage!.write(key: key, value: value);
  }

  Future<String> getSecureData(String key) async {
    if (!kIsWeb) {
      await checkFirstTime();
    }
    try {
      String? data = await flutterSecureStorage!.read(key: key);

      return data!;
    } catch (e) {
      return '';
    }
  }

  clearSecureData() async {
    await flutterSecureStorage?.deleteAll();
  }
}
