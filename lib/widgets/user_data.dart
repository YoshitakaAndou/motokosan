import 'package:motokosan/auth/signup_model.dart';

void userDataPrint(UserData _data, String _place) {
  print("----------------------------UserData:$_place");
  print("uid:${_data.uid}");
  print("userGroup:${_data.userGroup}");
  print("userName:${_data.userName}");
  print("userEmail:${_data.userEmail}");
  print("userPassword:${_data.userPassword}");
}
