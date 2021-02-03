import 'package:motokosan/data/data_save_body.dart';
import 'userdata_class.dart';

class UserDataBody {
  static final UserDataBody instance = UserDataBody();

  Future<void> save(UserData _userData) async {
    await DataSave.saveString("_uid", _userData.uid);
    await DataSave.saveString("_group", _userData.userGroup);
    await DataSave.saveString("_name", _userData.userName);
    await DataSave.saveString("_email", _userData.userEmail);
    await DataSave.saveString("_password", _userData.userPassword);
  }

  Future<UserData> loadUserData() async {
    final UserData _userData = UserData();
    _userData.uid = await DataSave.getString("_uid");
    _userData.userGroup = await DataSave.getString("_group");
    _userData.userName = await DataSave.getString("_name");
    _userData.userEmail = await DataSave.getString("_email");
    _userData.userPassword = await DataSave.getString("_password");
    return _userData;
  }
}
