import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/datasave_widget.dart';
import '../user_data/userdata_class.dart';

class LoginModel extends ChangeNotifier {
  UserData userData = UserData();
  bool isLoading = false;
  bool isUpdate = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> logIn() async {
    if (userData.userGroup.isEmpty) {
      throw ("グループ名を入力してください");
    }
    if (userData.userEmail.isEmpty) {
      throw ("メールアドレスを入力してください");
    }
    if (userData.userPassword.isEmpty) {
      throw ("パスワードを入力してください");
    }
    final User user = (await _auth.signInWithEmailAndPassword(
      email: userData.userEmail,
      password: userData.userPassword,
    ))
        .user;
    return user.uid;
  }

  Future<void> saveDataToPhone(UserData _data) async {
    DataSave.saveString("_uid", _data.uid);
    DataSave.saveString("_group", _data.userGroup);
    DataSave.saveString("_name", _data.userName);
    DataSave.saveString("_email", _data.userEmail);
    DataSave.saveString("_password", _data.userPassword);
  }

  void setEmail(String _email) {
    userData.userEmail = _email;
    notifyListeners();
  }

  void setPassword(String _password) {
    userData.userPassword = _password;
    notifyListeners();
  }

  void setIsLoading(bool _setData) {
    isLoading = _setData;
    notifyListeners();
  }

  void setIsUpdate(bool _setData) {
    isUpdate = _setData;
    notifyListeners();
  }
}
