import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/target/target_firebase.dart';

import 'target_class.dart';


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
    targets = await FSTarget.instance.fetchTarget(_groupName);
    notifyListeners();
  }

  Future<void> addTargetFs(_groupName, _timeStamp) async {
    if (target.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    target.targetId = _timeStamp.toString();
    await FSTarget.instance.setTargetFs(true, _groupName, target, _timeStamp);
    notifyListeners();
  }

  Future<void> updateTargetFs(_groupName, _timeStamp) async {
    if (target.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    await FSTarget.instance.setTargetFs(false, _groupName, target, _timeStamp);
    notifyListeners();
  }

  Future<void> deleteTargetFs(_groupName, _targetId) async {
    FSTarget.instance.deleteTarget(_groupName, _targetId);
    notifyListeners();
  }

}
