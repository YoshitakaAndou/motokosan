import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/widgets/convert_items.dart';

class Organizer {
  String organizerId;
  String organizerNo;
  String title;
  String subTitle;
  String option1;
  String option2;
  String option3;
  int updateAt;
  int createAt;
  String key;

  Organizer({
    this.organizerId = "",
    this.organizerNo = "",
    this.title = "",
    this.subTitle = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.key = "",
  });
}

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

  Future<void> deleteCategoryFs(_groupName, _organizerId) async {
    await FSOrganizer.instance.deleteData(_groupName, _organizerId);
    notifyListeners();
  }
}

class FSOrganizer {
  static final FSOrganizer instance = FSOrganizer();

  Future<List<Organizer>> fetchDates(
    String _groupName,
  ) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Organizer")
        .orderBy('organizerNo', descending: false)
        .getDocuments();
    return _docs.documents
        .map((doc) => Organizer(
              organizerId: doc["organizerId"],
              organizerNo: doc["organizerNo"],
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

  Future<void> setData(
    bool _isAdd,
    String _groupName,
    Organizer _data,
    DateTime _timeStamp,
  ) async {
    final _organizerId = _isAdd ? _timeStamp.toString() : _data.organizerId;
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Organizer")
        .document(_organizerId)
        .setData({
      "organizerId": _organizerId,
      "organizerNo": _data.organizerNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "upDate": ConvertItems.instance.dateToInt(_timeStamp),
      "createAt":
          _isAdd ? ConvertItems.instance.dateToInt(_timeStamp) : _data.createAt,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteData(
    String _groupName,
    String _organizerId,
  ) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Organizer")
        .document(_organizerId)
        .delete();
  }
}
