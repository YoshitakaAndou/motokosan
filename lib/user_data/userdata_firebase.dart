import 'package:cloud_firestore/cloud_firestore.dart';
import 'userdata_class.dart';

class FSUserData {
  static final FSUserData instance = FSUserData();

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
}
