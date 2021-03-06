import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_firebase.dart';
import 'package:motokosan/take_a_lecture/question/question_firebase.dart';
import 'package:motokosan/widgets/convert_datetime.dart';

import 'workshop_class.dart';

class FSWorkshop {
  static final FSWorkshop instance = FSWorkshop();

  Future<void> deleteData(String _groupName, String _workshopId) async {
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
    //lectureLengthを取得
    _data.lectureLength =
        await FSLecture.instance.getLectureLength(_groupName, _data.workshopId);
    //questionLengthを取得
    _data.questionLength = await FSQuestion.instance
        .getQuestionLength(_groupName, _data.workshopId);
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
      "information": _data.information,
      "subInformation": _data.subInformation,
      "option3": _data.option3,
      "isRelease": _data.isRelease,
      "isExam": _data.isExam,
      "lectureLength": _data.lectureLength,
      "questionLength": _data.questionLength,
      "numOfExam": _data.numOfExam,
      "passingScore": _data.passingScore,
      "upDate": ConvertDateTime.instance.dateToInt(_timeStamp),
      "createAt":
          _isAdd ? ConvertDateTime.instance.dateToInt(_timeStamp) : _data.createAt,
      "deadlineAt": _data.deadlineAt,
      "targetId": _data.targetId,
      "organizerId": _data.organizerId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<List<Workshop>> fetchDates(
      String _groupName, String _organizerId) async {
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

  Future<List<Workshop>> fetchDatesMake(
      String _groupName, String _organizerId) async {
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

  Future<List<Workshop>> fetchDatesAll(String _groupName) async {
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

  Future<List<Workshop>> fetchDatesDeadlineAt(String _groupName) async {
    final int _todayInt = ConvertDateTime.instance.dateToInt(DateTime.now());
    final _docs = await fetchDatesAll(_groupName);
    // 期限が過ているものを弾きます
    final List<Workshop> _results =
        List.from(_docs.where((doc) => doc.deadlineAt >= _todayInt));
    // // 番号順でソートして返す
    _results.sort((a, b) => a.workshopNo.compareTo(b.workshopNo));
    return _results;
  }

  Future<Workshop> fetchData(String _groupName, String _workshopId) async {
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
      information: _doc["information"],
      subInformation: _doc["subInformation"],
      option3: _doc["option3"],
      isRelease: _doc["isRelease"],
      isExam: _doc["isExam"],
      lectureLength: _doc["lectureLength"],
      questionLength: _doc["questionLength"],
      numOfExam: _doc["numOfExam"],
      passingScore: _doc["passingScore"],
      updateAt: _doc["upDate"],
      createAt: _doc["createAt"],
      deadlineAt: _doc["deadlineAt"],
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
              information: doc["information"],
              subInformation: doc["subInformation"],
              option3: doc["option3"],
              isRelease: doc["isRelease"],
              isExam: doc["isExam"],
              lectureLength: doc["lectureLength"],
              questionLength: doc["questionLength"],
              numOfExam: doc["numOfExam"],
              passingScore: doc["passingScore"],
              updateAt: doc["upDate"],
              createAt: doc["createAt"],
              deadlineAt: doc["deadlineAt"],
              targetId: doc["targetId"],
              organizerId: doc["organizerId"],
            ))
        .toList();
  }
}
