import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';

import 'workshop_class.dart';
import 'workshop_database.dart';
import 'workshop_firebase.dart';

class WorkshopModel extends ChangeNotifier {
  List<Workshop> workshops = [];
  List<WorkshopList> workshopLists = [];
  Workshop workshop = Workshop();
  WorkshopList workshopList = WorkshopList();
  bool isLoading = false;
  bool isUpdate = false;
  bool isEditing = false;
  String lectureMess = "";
  // int lectureCount = 0;

  void initData(Organizer _organizer) {
    workshop.workshopId = "";
    workshop.workshopNo = "";
    workshop.title = "";
    workshop.subTitle = "";
    workshop.information = "";
    workshop.subInformation = "";
    workshop.option3 = "";
    workshop.isRelease = false;
    workshop.isExam = false;
    workshop.lectureLength = 0;
    workshop.questionLength = 0;
    workshop.numOfExam = 0;
    workshop.passingScore = 0;
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
    // lectureCount = 0;
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "title":
        workshop.title = _val;
        break;
      case "subTitle":
        workshop.subTitle = _val;
        break;
      case "information":
        workshop.information = _val;
        break;
      case "subInformation":
        workshop.subInformation = _val;
        break;
      case "option3":
        workshop.option3 = _val;
        break;
    }
    notifyListeners();
  }

  // void changeDeadlineAt(int _val) {
  //   workshop.deadlineAt = _val;
  //   notifyListeners();
  // }

  void changeIsRelease(bool _val) {
    workshop.isRelease = _val;
    notifyListeners();
  }

  void changeIsExam(bool _val) {
    workshop.isExam = _val;
    notifyListeners();
  }

  void setWorkshopResult(WorkshopResult _data, int _index) {
    workshopLists[_index].workshopResult = _data;
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

  Future<void> fetchLists(String _groupName) async {
    final List<Workshop> _workshops =
        await FSWorkshop.instance.fetchDatesAll(_groupName);
    if (_workshops.length > 0) {
      // workshopListを作成
      // listNoはorganizerNo+workshopNoです
      // それを作ります
      workshopLists = List();
      for (Workshop _workshop in _workshops) {
        // OrganizerからorganizerNoを取る
        final _doc = await FirebaseFirestore.instance
            .collection("Groups")
            .doc(_groupName)
            .collection("Organizer")
            .doc(_workshop.organizerId)
            .get();
        final _organizerNo = _doc["organizerNo"];
        final _organizerName = _doc["title"];
        final _workshopResults = await WorkshopDatabase.instance
            .getWorkshopResult(_workshop.workshopId);
        if (_workshopResults.length == 0) {
          // workshopResultが見つからなかった時
          workshopLists.add(WorkshopList(
            workshop: _workshop,
            organizerName: _organizerName,
            organizerTitle: "指定無し",
            listNo: "$_organizerNo${_workshop.workshopNo}",
            workshopResult: WorkshopResult(),
          ));
        } else {
          workshopLists.add(WorkshopList(
            workshop: _workshop,
            organizerName: _organizerName,
            organizerTitle: "指定無し",
            listNo: "$_organizerNo${_workshop.workshopNo}",
            workshopResult: _workshopResults[0],
          ));
        }
      }
      // workshopListsを番号順でソート
      workshopLists.sort((a, b) => a.listNo.compareTo(b.listNo));
    }
    notifyListeners();
  }

  Future<void> fetchListsByOrganizer(
      String _groupName, Organizer _organizer) async {
    List<Workshop> _workshops = await FSWorkshop.instance
        .fetchDates(_groupName, _organizer.organizerId);
    // workshopListを作成
    workshopLists = List();
    for (Workshop _workshop in _workshops) {
      // workshopListを作る
      final _workshopResults = await WorkshopDatabase.instance
          .getWorkshopResult(_workshop.workshopId);
      if (_workshopResults.length == 0) {
        // workshopResultが見つからなかった時
        workshopLists.add(WorkshopList(
          workshop: _workshop,
          organizerName: _organizer.title,
          organizerTitle: _organizer.title,
          listNo: _workshop.workshopNo,
          workshopResult: WorkshopResult(),
        ));
      } else {
        workshopLists.add(WorkshopList(
          workshop: _workshop,
          organizerName: _organizer.title,
          organizerTitle: _organizer.title,
          listNo: _workshop.workshopNo,
          workshopResult: _workshopResults[0],
        ));
      }
    }
    notifyListeners();
  }

  Future<void> fetchWorkshopByOrganizer(
      String _groupName, String _organizer) async {
    workshops = await FSWorkshop.instance.fetchDates(_groupName, _organizer);
    notifyListeners();
  }

  Future<void> fetchWorkshopMake(String _groupName, String _organizer) async {
    workshops =
        await FSWorkshop.instance.fetchDatesMake(_groupName, _organizer);
    notifyListeners();
  }

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
