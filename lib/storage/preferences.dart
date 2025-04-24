import 'package:shared_preferences/shared_preferences.dart';

/// Constants for SharedPreferences
class SharedPrefKeys {
  SharedPrefKeys._();
  static const String languageCode = 'languageCode';
  static const String profilePreferenceCode = 'profilePreferenceCode';
}

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService?> get instance async {
    _instance ??= SharedPreferencesService._internal();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  Future<void> setLanguage(String langCode) async =>
      await _preferences!.setString(SharedPrefKeys.languageCode, langCode);

  ///Save Single Entry Shared preference
  saveData(String key, String value) async {
    _preferences!.setString(key, value);
  }

  ///Read Single Entry Shared preference
  Future readDate(String key) async {
    return _preferences!.getString(key) ?? "";
  }

  ///Find Contains Shared preference
  Future containsKey(String key) async {
    return _preferences!.containsKey(key);
  }

  ///Delete Single Entry Shared preference
  removeValue(String key) async {
    return _preferences!.remove(key);
  }

  ///Clear Shared preference
  removeAll() async {
    return _preferences!.clear();
  }

  Future<void> setProfilePreference(String profilePreferenceJson) async =>
      await _preferences!.setString(
          SharedPrefKeys.profilePreferenceCode, profilePreferenceJson);

  String? get languageCode =>
      _preferences!.getString(SharedPrefKeys.languageCode);

  String? get profilePreferenceCode =>
      _preferences!.getString(SharedPrefKeys.profilePreferenceCode);
}
