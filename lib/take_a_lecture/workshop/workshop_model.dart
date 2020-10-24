import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_model.dart';
import 'package:motokosan/widgets/convert_items.dart';

class Workshop {
  String workshopId;
  String workshopNo;
  String title;
  String subTitle;
  String option1;
  String option2;
  String option3;
  int updateAt;
  int createAt;
  String targetId;
  String organizerId;
  String key;

  Workshop({
    this.workshopId = "",
    this.workshopNo = "",
    this.title = "",
    this.subTitle = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.targetId = "",
    this.organizerId = "",
    this.key = "",
  });
}

class WorkshopList {
  String workshopId;
  String workshopNo;
  String title;
  String targetId;
  String organizerId;
  String organizerName;
  String listNo;

  WorkshopList({
    this.workshopId,
    this.workshopNo,
    this.title,
    this.targetId,
    this.organizerId,
    this.organizerName,
    this.listNo,
  });
}

class WorkshopModel extends ChangeNotifier {
  List<Workshop> workshops = [];
  List<WorkshopList> workshopLists = [];
  Workshop workshop = Workshop();
  WorkshopList workshopList = WorkshopList();
  bool isLoading = false;
  bool isUpdate = false;
  bool isEditing = false;
  String lectureMess = "";

  void initData(Organizer _organizer) {
    workshop.workshopId = "";
    workshop.workshopNo = "";
    workshop.title = "";
    workshop.subTitle = "";
    workshop.option1 = "";
    workshop.option2 = "";
    workshop.option3 = "";
    workshop.updateAt = 0;
    workshop.createAt = 0;
    workshop.targetId = "";
    workshop.organizerId = _organizer.organizerId;
  }

  void initProperties() {
    isLoading = false;
    isUpdate = false;
    isEditing = false;
    lectureMess = "";
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "title":
        workshop.title = _val;
        break;
      case "subTitle":
        workshop.subTitle = _val;
        break;
      case "option1":
        workshop.option1 = _val;
        break;
      case "option2":
        workshop.option2 = _val;
        break;
      case "option3":
        workshop.option3 = _val;
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

  void lecMess() {
    notifyListeners();
  }

  Future<void> fetchLists(String _groupName, Organizer _organizer) async {
    final List<Workshop> _workshops =
        await FSWorkshop.instance._fetchDatesAll(_groupName);
    // workshopListを作成
    workshopLists = List();
    for (Workshop _workshop in _workshops) {
      // CategoryからcategoryNoを取る
      final _doc = await Firestore.instance
          .collection("Groups")
          .document(_groupName)
          .collection("Organizer")
          .document(_workshop.organizerId)
          .get();
      final _organizerNo = _doc["organizerNo"];
      final _organizerName = _doc["title"];
      // workshopListを作る
      final WorkshopList _workshopList = WorkshopList(
          workshopId: _workshop.workshopId,
          workshopNo: _workshop.workshopNo,
          title: _workshop.title,
          targetId: _workshop.targetId,
          organizerId: _workshop.organizerId,
          organizerName: _organizerName,
          listNo: "$_organizerNo${_workshop.workshopNo}");
      workshopLists.add(_workshopList);
    }
    // workshopListsを番号順でソート
    workshopLists.sort((a, b) => a.listNo.compareTo(b.listNo));
    notifyListeners();
  }

  Future<void> fetchListsByCategory(
      String _groupName, Organizer _organizer) async {
    List<Workshop> _workshops = await FSWorkshop.instance
        ._fetchDates(_groupName, _organizer.organizerId);
    // workshopListを作成
    workshopLists = List();
    for (Workshop _workshop in _workshops) {
      // workshopListを作る
      final WorkshopList _workshopList = WorkshopList(
        workshopId: _workshop.workshopId,
        workshopNo: _workshop.workshopNo,
        title: _workshop.title,
        targetId: _workshop.targetId,
        organizerId: _workshop.organizerId,
        organizerName: _organizer.title,
        listNo: _workshop.workshopNo,
      );
      workshopLists.add(_workshopList);
    }
    notifyListeners();
  }

  Future<void> fetchWorkshopByOrganizer(
      String _groupName, String _organizer) async {
    workshops = await FSWorkshop.instance._fetchDates(_groupName, _organizer);
    notifyListeners();
  }

  // Future<void> fetchWorkshopAll(String _groupName) async {
  //   workshops = await _fetchWorkshopAll(_groupName);
  //   notifyListeners();
  // }

  // Future<String> getOrganizerName(_groupName, _organizerId) async {
  //   final _doc = await Firestore.instance
  //       .collection("Groups")
  //       .document(_groupName)
  //       .collection("Organizer")
  //       .document(_organizerId)
  //       .get();
  //   return _doc["title"];
  // }

  Future<void> addWorkshopFs(_groupName, _timeStamp) async {
    if (workshop.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    workshop.workshopId = _timeStamp.toString();
    await FSWorkshop.instance.setData(true, _groupName, workshop, _timeStamp);
    notifyListeners();
  }

  Future<void> updateWorkshopFs(_groupName, _timeStamp) async {
    if (workshop.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    await FSWorkshop.instance.setData(false, _groupName, workshop, _timeStamp);
    notifyListeners();
  }
}

class FSWorkshop {
  static final FSWorkshop instance = FSWorkshop();

  Future<void> deleteData(_groupName, _workshopId) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Workshop")
        .document(_workshopId)
        .delete();
  }

  Future<void> setData(bool _isAdd, String _groupName, Workshop _data,
      DateTime _timeStamp) async {
    final _workshopId = _isAdd ? _timeStamp.toString() : _data.workshopId;
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Workshop")
        .document(_workshopId)
        .setData({
      "workshopId": _workshopId,
      "workshopNo": _data.workshopNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "upDate": ConvertItems.instance.dateToInt(_timeStamp),
      "createAt":
          _isAdd ? ConvertItems.instance.dateToInt(_timeStamp) : _data.createAt,
      "targetId": _data.targetId,
      "organizerId": _data.organizerId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<List<Workshop>> _fetchDates(_groupName, _organizerId) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Workshop")
        .where("organizerId", isEqualTo: _organizerId)
        // .orderBy('workshopNo', descending: false)
        .getDocuments();

    final List<Workshop> _results = _documentToList(_docs);
    // 番号順でソートして返す
    _results.sort((a, b) => a.workshopNo.compareTo(b.workshopNo));
    return _results;
  }

  Future<List<Workshop>> _fetchDatesAll(_groupName) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Workshop")
        .orderBy('workshopNo', descending: false)
        .getDocuments();
    final List<Workshop> _results = _documentToList(_docs);
    return _results;
  }

  List<Workshop> _documentToList(QuerySnapshot _docs) {
    return _docs.documents
        .map((doc) => Workshop(
              workshopId: doc["workshopId"],
              workshopNo: doc["workshopNo"],
              title: doc["title"],
              subTitle: doc["subTitle"],
              option1: doc["option1"],
              option2: doc["option2"],
              option3: doc["option3"],
              updateAt: doc["upDate"],
              createAt: doc["createAt"],
              targetId: doc["targetId"],
              organizerId: doc["organizerId"],
            ))
        .toList();
  }
}
