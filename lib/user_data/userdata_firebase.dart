import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userdata_class.dart';

class FSUserData {
  static final FSUserData instance = FSUserData();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserData> fetchUserData(String _uid, String _groupName) async {
    final doc = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Users")
        .doc(_uid)
        .get();
    return Future.value(convert(doc));
  }

  UserData convert(DocumentSnapshot doc) {
    return UserData(
      uid: doc["uid"],
      userGroup: doc["group"],
      userName: doc["name"],
      userEmail: doc["email"],
      userPassword: doc["password"],
    );
  }

  Future<void> setData(UserData _userData) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_userData.userGroup)
        .collection("Users")
        .doc(_userData.uid)
        .set(
      {
        "uid": _userData.uid,
        "group": _userData.userGroup,
        "name": _userData.userName,
        "email": _userData.userEmail,
        "password": _userData.userPassword,
        "createdAt": Timestamp.now(),
      },
    );
  }

  Future<bool> searchUserInDb(User firebaseUser) async {
    final query = await _db
        .collection("Users")
        .where("uid", isEqualTo: firebaseUser.uid)
        .get();
    if (query.docs.length > 0) {
      return true;
    }
    return false;
  }

  Future<bool> isContainsGroupUsersEmpty(String _uid, String _groupName) async {
    final doc = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Users")
        .get();
    return doc.docs.where((element) => element.id == _uid).isEmpty;
  }

  bool isCurrentUserSignIn() {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  User getCurrentUser() {
    return _auth.currentUser;
  }
}
