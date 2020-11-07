import 'package:motokosan/user_data/userdata_class.dart';

import 'datasave_widget.dart';

class BodyData {
  static final BodyData instance = BodyData();

  Future<void> saveDataToPhone(UserData _data) async {
    DataSave.saveString("_uid", _data.uid);
    DataSave.saveString("_group", _data.userGroup);
    DataSave.saveString("_name", _data.userName);
    DataSave.saveString("_email", _data.userEmail);
    DataSave.saveString("_password", _data.userPassword);
  }

  Future<bool> getIsHideWSBS() async {
    final result = await DataSave.getBool("isHideWSBS");
    return result ?? false;
  }

  Future<void> saveIsHideWSBS(bool _data) async {
    await DataSave.saveBool("isHideWSBS", _data);
  }

  Future<bool> getIsHideLBS() async {
    final result = await DataSave.getBool("isHideLBS");
    return result ?? false;
  }

  Future<void> saveIsHideLBS(bool _data) async {
    await DataSave.saveBool("isHideLBS", _data);
  }
}
