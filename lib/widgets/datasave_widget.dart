import 'package:shared_preferences/shared_preferences.dart';

String userGroup = "";

class DataSave {
  static saveBool(_key, bool _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, _value);
  }

  static Future<bool> getBool(_key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key);
  }

  static saveString(_key, String _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, _value);
  }

  static Future<String> getString(_key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
