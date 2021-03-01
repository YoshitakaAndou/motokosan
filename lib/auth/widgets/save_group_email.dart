import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants.dart';

Future<void> saveGroupEmail(String groupName, String email) async {
  await FirebaseFirestore.instance.collection('Groups').doc(groupName).update({
    'email': email,
  }).catchError((onError) {
    print(onError.toString());
  });
  if (Future.value() != null) {
    isGroupCreate = false;
    createGroupName = "";
  }
}
