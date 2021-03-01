import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motokosan/data/group_data/group_data.dart';
import 'package:motokosan/data/user_data/userdata_body.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';

class AuthModel extends ChangeNotifier {
  UserData userData = UserData();
  GroupData groupData = GroupData();
  bool isLoading = false;
  bool isUpdate = false;
  bool currentUserSignIn = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

    // todo FB auth にログイン
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

  Future signUp() async {
    if (userData.userGroup.isEmpty) {
      throw ("グループ名を入力してください");
    }
    if (userData.userName.isEmpty) {
      throw ("ユーザー名を入力してください");
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
      throw ("パスワードは６文字以上でお願いします");
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

  Future<bool> googleLogin() async {
    if (userData.userGroup.isEmpty) {
      throw ("グループ名を入力してください");
    }
    if (userData.userName.isEmpty) {
      throw ("ユーザー名を入力してください");
    }
    try {
      GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: signInAuthentication.idToken,
          accessToken: signInAuthentication.accessToken);
      if (credential == null) {
        return false;
      }
      final User firebaseUser =
          (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return false;
      }

      // todo Users に登録
      final bool isUserInDb =
          await FSUserData.instance.searchUserInDb(firebaseUser);
      if (!isUserInDb) {
        userData.uid = firebaseUser.uid;
        userData.userEmail = firebaseUser.email;
        userData.userPassword = "google認証";
        UserDataBody.instance.save(userData);

        FirebaseFirestore.instance
            .collection("Groups")
            .doc(userData.userGroup)
            .collection("Users")
            .doc(userData.uid)
            .set({
          "uid": userData.uid,
          "group": userData.userGroup,
          "name": userData.userName,
          "email": userData.userEmail,
          "password": userData.userPassword,
          "createdAt": Timestamp.now(),
        });
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  void setIsLoading(bool _setData) {
    isLoading = _setData;
    notifyListeners();
  }

  void setIsUpdate(bool _setData) {
    isUpdate = _setData;
    notifyListeners();
  }

  Future<bool> isSignIn() async {
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
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
}
