import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/datasave_widget.dart';

class UserData {
  String uid;
  String userGroup;
  String userName;
  String userEmail;
  String userPassword;

  UserData({
    this.uid = "",
    this.userGroup = "",
    this.userName = "",
    this.userEmail = "",
    this.userPassword = "",
  });
}

class SignupModel extends ChangeNotifier {
  UserData userData = UserData();
  bool isUpdate = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // void initUserData() {
  //   userData.userGroup = "";
  //   userData.userName = "";
  //   userData.userEmail = "";
  //   userData.userPassword = "";
  // }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "userGroup":
        userData.userGroup = _val;
        break;
      case "userName":
        userData.userName = _val;
        break;
      case "userEmail":
        userData.userEmail = _val;
        break;
      case "userPassword":
        userData.userPassword = _val;
        break;
    }
    notifyListeners();
  }

  Future signUp() async {
    if (userData.userGroup.isEmpty) {
      throw ("グループ名を入力してください");
    }
    if (userData.userName.isEmpty) {
      throw ("名前を入力してください");
    }
    if (userData.userEmail.isEmpty) {
      throw ("メールアドレスを入力してください");
    }
    if (userData.userPassword.contains("@") &&
        userData.userPassword.contains(".")) {
      throw ("メールアドレスを\naaaaaa@bbb.cc の形式で入力してください");
    }
    if (userData.userPassword.isEmpty) {
      throw ("パスワードを入力してください");
    }
    if (userData.userPassword.length < 6) {
      throw ("パスワードは６文字以上で入力してください");
    }
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: userData.userEmail,
      password: userData.userPassword,
    ))
        .user;
    userData.uid = user.uid;
    userData.userEmail = user.email;

    DataSave.saveString("_uid", userData.uid);
    DataSave.saveString("_group", userData.userGroup);
    DataSave.saveString("_name", userData.userName);
    DataSave.saveString("_email", userData.userEmail);
    DataSave.saveString("_password", userData.userPassword);

    // Authへ登録した際に発行されたUIDを元にデータベースUsersに登録する
    Firestore.instance
        .collection("Groups")
        .document(userData.userGroup)
        .collection("Users")
        .document(userData.uid)
        .setData({
      "uid": userData.uid,
      "group": userData.userGroup,
      "name": userData.userName,
      "email": userData.userEmail,
      "password": userData.userPassword,
      "createdAt": Timestamp.now(),
    });
  }
}
