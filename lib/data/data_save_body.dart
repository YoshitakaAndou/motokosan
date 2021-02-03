import 'package:shared_preferences/shared_preferences.dart';

class DataSaveBody {
  static final DataSaveBody instance = DataSaveBody();

  Future<bool> getIsHideWSBS() async {
    final result = await DataSave.getBool("isHideWSBS");
    return result ?? false;
  }

  Future<void> saveIsHideWSBS(bool _data) async {
    await DataSave.saveBool("isHideWSBS", _data);
  }

  Future<bool> getIsHideOBS() async {
    final result = await DataSave.getBool("isHideOBS");
    return result ?? false;
  }

  Future<void> saveIsHideOBS(bool _data) async {
    await DataSave.saveBool("isHideOBS", _data);
  }

  Future<bool> getIsHideLBS() async {
    final result = await DataSave.getBool("isHideLBS");
    return result ?? false;
  }

  Future<void> saveIsHideLBS(bool _data) async {
    await DataSave.saveBool("isHideLBS", _data);
  }

  Future<bool> getPolicy() async {
    final result = await DataSave.getBool("_policy");
    return result ?? false;
  }

  Future<void> savePolicy(bool _data) async {
    await DataSave.saveBool("_policy", _data);
  }
}

class DataSave {
  static saveBool(_key, bool _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, _value);
  }

  static saveString(_key, String _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, _value);
  }

  static Future<bool> getBool(_key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key);
  }

  static Future<String> getString(_key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
