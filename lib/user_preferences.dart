import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyBotName = "botName";
  static const String _keyTTSEnabled = "TTSEnabled";

  static Future<String> getBotName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBotName) ?? "Bob";
  }

  static Future<bool> setBotName(String botName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_keyBotName, botName);
  }

  static Future<bool> isTTSEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyTTSEnabled) ?? true;
  }

  static Future<bool> setTTSEnabled(bool enabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_keyTTSEnabled, enabled);
  }
}