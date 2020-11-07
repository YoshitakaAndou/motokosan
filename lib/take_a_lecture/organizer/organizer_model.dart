import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'organizer_class.dart';
import 'play/organizer_firebase.dart';

class OrganizerModel extends ChangeNotifier {
  List<Organizer> organizers = [];
  List<Organizer> organizerList = [];
  Organizer organizer = Organizer();
  bool isLoading = false;
  bool isUpdate = false;
  bool isEditing = false;

  void initData() {
    organizer.organizerId = "";
    organizer.organizerNo = "";
    organizer.title = "";
    organizer.subTitle = "";
    organizer.option1 = "";
    organizer.option2 = "";
    organizer.option3 = "";
    organizer.updateAt = 0;
    organizer.createAt = 0;
  }

  void initProperties() {
    isLoading = false;
    isUpdate = false;
    isEditing = false;
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "title":
        organizer.title = _val;
        break;
      case "subTitle":
        organizer.subTitle = _val;
        break;
      case "option1":
        organizer.option1 = _val;
        break;
      case "option2":
        organizer.option2 = _val;
        break;
      case "option3":
        organizer.option3 = _val;
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

  Future<void> fetchOrganizer(String _groupName) async {
    organizers = await FSOrganizer.instance.fetchDates(_groupName);
    notifyListeners();
  }

  Future<void> fetchOrganizerList(String _groupName) async {
    organizerList = await FSOrganizer.instance.fetchDates(_groupName);
    // 先頭に"指定無し"を追加
    final _organizer = Organizer(
      title: "指定無し",
    );
    organizerList.insert(0, _organizer);
    notifyListeners();
  }

  Future<void> addOrganizerFs(_groupName, _timeStamp) async {
    if (organizer.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    organizer.organizerId = _timeStamp.toString();
    await FSOrganizer.instance.setData(true, _groupName, organizer, _timeStamp);
    notifyListeners();
  }

  Future<void> updateOrganizerFs(_groupName, _timeStamp) async {
    if (organizer.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    await FSOrganizer.instance
        .setData(false, _groupName, organizer, _timeStamp);
    notifyListeners();
  }

  Future<void> deleteOrganizerFs(_groupName, _organizerId) async {
    await FSOrganizer.instance.deleteData(_groupName, _organizerId);
    notifyListeners();
  }
}
