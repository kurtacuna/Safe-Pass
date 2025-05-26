import 'package:shared_preferences/shared_preferences.dart';

class StorageKeys {
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
}

class Storage {
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}