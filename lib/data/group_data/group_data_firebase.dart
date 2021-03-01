import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/data/group_data/group_data.dart';

class FSGroupData {
  static final FSGroupData instance = FSGroupData();

  Future<GroupData> fetchGroupData(String _groupName) async {
    final doc = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .get();
    return Future.value(convert(doc));
  }

  Future<List<GroupData>> createDates() async {
    final _docs = await FirebaseFirestore.instance.collection("Groups").get();
    return _docs.docs.map((doc) => convert(doc)).toList();
  }

  GroupData convert(DocumentSnapshot doc) {
    return GroupData(
      name: doc["name"],
      password: doc["password"],
      groupCode: doc["groupCode"],
      email: doc["email"],
    );
  }
}
