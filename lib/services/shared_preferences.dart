import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? prefs;

  static Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await prefs!.setString(key, value);
  }

  static Future<String> getString(String key) async {
    final String action = prefs!.getString(key) ?? '';
    return action;
  }

  static Future<void> clearStorage() async {
    prefs!.clear();
  }
}
