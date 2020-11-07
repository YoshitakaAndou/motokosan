import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userdata_class.dart';

class FSUserData {
  static final FSUserData instance = FSUserData();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserData> fetchUserData(_uid, _groupName) async {
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
