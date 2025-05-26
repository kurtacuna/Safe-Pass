import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Storage _instance = Storage._internal();
  late SharedPreferences _prefs;

  factory Storage() {
    return _instance;
  }

  Storage._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _prefs.getString(key);
  
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  
  Future<bool> remove(String key) => _prefs.remove(key);
  
  Future<bool> clear() => _prefs.clear();
} 