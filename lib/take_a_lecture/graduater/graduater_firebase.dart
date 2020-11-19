import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/user_data/userdata_class.dart';

import '../workshop/workshop_class.dart';
import '../workshop/workshop_firebase.dart';
import 'graduater_class.dart';

class FSGraduater {
  static final FSGraduater instance = FSGraduater();

  Future<void> deleteGraduaterSelect(String _groupName) async {
    // List<workshopId>
    final _workshops = await FSWorkshop.instance.fetchDatesAll(_groupName);
    for (Workshop _workshop in _workshops) {
      // List<workshopResult>
      final _workshopResults = await WorkshopDatabase.instance
          .getWorkshopResult(_workshop.workshopId);
      for (WorkshopResult _data in _workshopResults) {
        await deleteGraduater(_groupName, _data.graduaterId);
      }
    }
  }

  Future<List<Graduater>> fetchDates(
      String _groupName, WorkshopList _workshopList) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Graduater")
        .where("workshopId", isEqualTo: _workshopList.workshop.workshopId)
        .get();
    final List<Graduater> _results = _docs.docs
        .map((doc) => Graduater(
              graduaterId: doc["graduaterId"] ?? "",
              uid: doc["uid"] ?? "",
              workshopId: doc["workshopId"] ?? "",
              takenAt: doc["takenAt"],
              sendAt: doc["sendAt"],
            ))
        .toList();
    return _results;
  }

  Future<List<Graduater>> fetchGraduater(
    UserData _userData,
  ) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_userData.userGroup)
        .collection("Graduater")
        .where("uid", isEqualTo: _userData.uid)
        .get();
    final List<Graduater> _results = _docs.docs
        .map((doc) => Graduater(
              graduaterId: doc["graduaterId"] ?? "",
              uid: doc["uid"] ?? "",
              workshopId: doc["workshopId"] ?? "",
              takenAt: doc["takenAt"],
              sendAt: doc["sendAt"],
            ))
        .toList();
    return _results;
  }

  Future<void> sendGraduaterData(_groupName, Graduater _data) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Graduater")
        .doc(_data.graduaterId)
        .set({
      "graduaterId": _data.graduaterId,
      "uid": _data.uid,
      "workshopId": _data.workshopId,
      "takenAt": _data.takenAt,
      "sendAt": _data.sendAt,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteGraduater(_groupName, _graduaterId) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Graduater")
        .doc(_graduaterId)
        .delete();
  }
}
