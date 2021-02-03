import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/user_data/userdata_body.dart';
import '../user_data/userdata_class.dart';

class GoogleModel extends ChangeNotifier {
  UserData userData = UserData();
  bool isLoading = false;
  bool isUpdate = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }

  Future<bool> googleSignin() async {
    if (userData.userGroup.isEmpty) {
      throw ("グループ名を入力してください");
    }
    if (userData.userName.isEmpty) {
      throw ("名前を入力してください");
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
        // DataSave.saveString("_uid", userData.uid);
        // DataSave.saveString("_group", userData.userGroup);
        // DataSave.saveString("_name", userData.userName);
        // DataSave.saveString("_email", userData.userEmail);
        // DataSave.saveString("_password", userData.userPassword);

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

  void setIsUpdate(bool _setData) {
    isUpdate = _setData;
    notifyListeners();
  }

  void setIsLoading(bool _setData) {
    isLoading = _setData;
    notifyListeners();
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
