import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();

  SharedPreferences? _preferences;
  static LocaleManager get instance => _instance;

  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static Future preferencesInit() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> setStringValue(PreferencesKeys key, String value) async {
    await _preferences!.setString(key.toString(), value);
  }

  String? getStringValue(PreferencesKeys key) =>
      _preferences!.getString(key.toString());

  Future<void> setIntValue(PreferencesKeys key, int value) async {
    await _preferences!.setInt(key.toString(), value);
  }

  int? getIntValue(PreferencesKeys key) => _preferences!.getInt(key.toString());

  Future<void> setBoolValue(PreferencesKeys key, bool value) async {
    await _preferences!.setBool(key.toString(), value);
  }

  bool? getBoolValue(PreferencesKeys key) =>
      _preferences!.getBool(key.toString());

  Future<void> clearAllValues() async => await _preferences!.clear();

  Future<void> removeValue(PreferencesKeys key) async =>
      await _preferences!.remove(key.toString());
}
