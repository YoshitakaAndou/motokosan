import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/widgets/convert_date_to_int.dart';

class Target {
  String targetId;
  String targetNo;
  String title;
  String subTitle;
  String option1;
  String option2;
  String option3;
  int updateAt;
  int createAt;
  String key;

  Target({
    this.targetId = "",
    this.targetNo = "",
    this.title = "",
    this.subTitle = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.key = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'targetId': targetId,
      'targetNo': targetNo,
      'title': title,
      'subTitle': subTitle,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'updateAt': updateAt,
      'createAt': createAt,
    };
  }
}

class TargetModel extends ChangeNotifier {
  List<Target> targets = [];
  Target target = Target();
  bool isLoading = false;
  bool isUpdate = false;
  bool isEditing = false;

  void initData() {
    target.targetId = "";
    target.targetNo = "";
    target.title = "";
    target.subTitle = "";
    target.option1 = "";
    target.option2 = "";
    target.option3 = "";
    target.updateAt = 0;
    target.createAt = 0;
  }

  void initProperties() {
    isLoading = false;
    isUpdate = false;
    isEditing = false;
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "title":
        target.title = _val;
        break;
      case "subTitle":
        target.subTitle = _val;
        break;
      case "option1":
        target.option1 = _val;
        break;
      case "option2":
        target.option2 = _val;
        break;
      case "option3":
        target.option3 = _val;
        break;
    }
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setUpdate() {
    isUpdate = true;
    notifyListeners();
  }

  void resetUpdate() {
    isUpdate = false;
    notifyListeners();
  }

  Future<void> fetchTarget(String _groupName) async {
    targets = await _fetchTarget(_groupName);
    notifyListeners();
  }

  Future<List<Target>> _fetchTarget(_groupName) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Target")
        .orderBy('targetNo', descending: false)
        .getDocuments();
    return _docs.documents
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

  Future<void> addTargetFs(_groupName, _timeStamp) async {
    if (target.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    target.targetId = _timeStamp.toString();
    await setTargetFs(true, _groupName, target, _timeStamp);
    notifyListeners();
  }

  Future<void> updateTargetFs(_groupName, _timeStamp) async {
    if (target.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    await setTargetFs(false, _groupName, target, _timeStamp);
    notifyListeners();
  }

  Future<void> setTargetFs(
      bool _isAdd, String _groupName, Target _data, DateTime _timeStamp) async {
    final _targetId = _isAdd ? _timeStamp.toString() : _data.targetId;
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Target")
        .document(_targetId)
        .setData({
      "targetId": _targetId,
      "targetNo": _data.targetNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "upDate": convertDateToInt(_timeStamp),
      "createAt": _isAdd ? convertDateToInt(_timeStamp) : _data.createAt,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteTargetFs(_groupName, _targetId) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Target")
        .document(_targetId)
        .delete();
    notifyListeners();
  }
}
