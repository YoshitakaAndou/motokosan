import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/user_data/userdata_body.dart';
import '../user_data/userdata_class.dart';

class EmailModel extends ChangeNotifier {
  UserData userData = UserData();
  bool isLoading = false;
  bool isUpdate = false;
  bool currentUserSignIn = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn() async {
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

    // todo FB Usersのデータをmodelに格納
    final _userData =
        await FSUserData.instance.fetchUserData(user.uid, userData.userGroup);
    userData.userName = _userData.userName;

    return user.uid;
  }

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

    // authへの登録
    try {
      final User _user = (await _auth.createUserWithEmailAndPassword(
        email: userData.userEmail,
        password: userData.userPassword,
      ))
          .user;

      userData.uid = _user.uid;
      userData.userEmail = _user.email;
      await UserDataBody.instance.save(userData);
      // Authへ登録した際に発行されたUIDを元にデータベースUsersに登録する
      FSUserData.instance.setData(userData);
    } catch (e) {
      // authに登録済の場合はグループのUsersにのみ登録する
      if (e.toString().contains("email-already-in-use")) {
        // authにsignin
        final User user = (await _auth.signInWithEmailAndPassword(
          email: userData.userEmail,
          password: userData.userPassword,
        ))
            .user;
        // authから帰ってきたuid,emailを本体に保存
        userData.uid = user.uid;
        userData.userEmail = user.email;
        print("authに登録済だった");
        await UserDataBody.instance.save(userData);
        // グループのUsersに登録していなかったら登録する
        if (await FSUserData.instance
            .isContainsGroupUsersEmpty(userData.uid, userData.userGroup)) {
          print("Group.Usersに登録していなかったので登録する");
          FSUserData.instance.setData(userData);
        }
      }
    }

    notifyListeners();
  }
  //
  // void setEmail(String _email) {
  //   userData.userEmail = _email;
  //   notifyListeners();
  // }
  //
  // void setPassword(String _password) {
  //   userData.userPassword = _password;
  //   notifyListeners();
  // }

  void setIsLoading(bool _setData) {
    isLoading = _setData;
    notifyListeners();
  }

  void setIsUpdate(bool _setData) {
    isUpdate = _setData;
    notifyListeners();
  }
}
