import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/widgets/convert_datetime.dart';

import 'target_class.dart';

class FSTarget {
  static final FSTarget instance = FSTarget();

  Future<List<Target>> fetchTarget(_groupName) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Target")
        .orderBy('targetNo', descending: false)
        .get();
    return _docs.docs
        .map((doc) => Target(
      targetId: doc["targetId"],
      targetNo: doc["targetNo"],
      title: doc["title"],
      subTitle: doc["subTitle"],
      option1: doc["option1"],
      option2: doc["option2"],
      option3: doc["option3"],
      updateAt: doc["upDate"],
      createAt: doc["createAt"],
    ))
        .toList();
  }

  Future<void> setTargetFs(
      bool _isAdd, String _groupName, Target _data, DateTime _timeStamp) async {
    final _targetId = _isAdd ? _timeStamp.toString() : _data.targetId;
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Target")
        .doc(_targetId)
        .set({
      "targetId": _targetId,
      "targetNo": _data.targetNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "upDate": ConvertDateTime.instance.dateToInt(_timeStamp),
      "createAt":
      _isAdd ? ConvertDateTime.instance.dateToInt(_timeStamp) : _data.createAt,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteTarget(_groupName, _targetId) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Target")
        .doc(_targetId)
        .delete();
  }

}