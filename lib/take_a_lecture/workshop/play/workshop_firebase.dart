
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_firebase.dart';
import 'package:motokosan/widgets/convert_items.dart';

import 'workshop_class.dart';

class FSWorkshop {
  static final FSWorkshop instance = FSWorkshop();

  Future<void> deleteData(_groupName, _workshopId) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Workshop")
        .doc(_workshopId)
        .delete();
  }

  Future<void> setData(bool _isAdd, String _groupName, Workshop _data,
      DateTime _timeStamp) async {
    final _workshopId = _isAdd ? _timeStamp.toString() : _data.workshopId;
    _data.lectureLength =
    await FSLecture.instance.getLectureLength(_groupName, _data.workshopId);
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Workshop")
        .doc(_workshopId)
        .set({
      "workshopId": _workshopId,
      "workshopNo": _data.workshopNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "isRelease": _data.isRelease,
      "lectureLength": _data.lectureLength,
      "upDate": ConvertItems.instance.dateToInt(_timeStamp),
      "createAt":
      _isAdd ? ConvertItems.instance.dateToInt(_timeStamp) : _data.createAt,
      "targetId": _data.targetId,
      "organizerId": _data.organizerId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<List<Workshop>> fetchDates(_groupName, _organizerId) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Workshop")
        .where("organizerId", isEqualTo: _organizerId)
        .get();
    List<Workshop> _results = List();
    final List<Workshop> _dates = _documentToList(_docs);
    _dates.forEach((_data) {
      if (_data.isRelease) {
        _results.add(_data);
      }
    });
    // 番号順でソートして返す
    _results.sort((a, b) => a.workshopNo.compareTo(b.workshopNo));
    return _results;
  }

  Future<List<Workshop>> fetchDatesMake(_groupName, _organizerId) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Workshop")
        .where("organizerId", isEqualTo: _organizerId)
    // .orderBy('workshopNo', descending: false)
        .get();

    final List<Workshop> _results = _documentToList(_docs);
    // 番号順でソートして返す
    _results.sort((a, b) => a.workshopNo.compareTo(b.workshopNo));
    return _results;
  }

  Future<List<Workshop>> fetchDatesAll(_groupName) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Workshop")
        .where("isRelease", isEqualTo: true)
        .get();
    final List<Workshop> _results = _documentToList(_docs);
    // 番号順でソートして返す
    _results.sort((a, b) => a.workshopNo.compareTo(b.workshopNo));
    return _results;
  }

  Future<Workshop> fetchData(_groupName, _workshopId) async {
    final _doc = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Workshop")
        .doc(_workshopId)
        .get();
    return Workshop(
      workshopId: _doc["workshopId"],
      workshopNo: _doc["workshopNo"],
      title: _doc["title"],
      subTitle: _doc["subTitle"],
      option1: _doc["option1"],
      option2: _doc["option2"],
      option3: _doc["option3"],
      isRelease: _doc["isRelease"],
      lectureLength: _doc["lectureLength"],
      updateAt: _doc["upDate"],
      createAt: _doc["createAt"],
      targetId: _doc["targetId"],
      organizerId: _doc["organizerId"],
    );
  }

  List<Workshop> _documentToList(QuerySnapshot _docs) {
    return _docs.docs
        .map((doc) => Workshop(
      workshopId: doc["workshopId"],
      workshopNo: doc["workshopNo"],
      title: doc["title"],
      subTitle: doc["subTitle"],
      option1: doc["option1"],
      option2: doc["option2"],
      option3: doc["option3"],
      isRelease: doc["isRelease"],
      lectureLength: doc["lectureLength"],
      updateAt: doc["upDate"],
      createAt: doc["createAt"],
      targetId: doc["targetId"],
      organizerId: doc["organizerId"],
    ))
        .toList();
  }
}