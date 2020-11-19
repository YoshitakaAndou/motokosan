import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_firebase.dart';
import 'package:motokosan/widgets/convert_items.dart';

import 'lecture_class.dart';

class FSLecture {
  static final FSLecture instance = FSLecture();

  Future<List<Lecture>> fetchDates(
    String _groupName,
    String _workshopId,
  ) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .where("workshopId", isEqualTo: _workshopId)
        // .orderBy('trainingNo', descending: false)
        .get();
    final List<Lecture> _results = _docs.docs
        .map((doc) => Lecture(
              lectureId: doc["lectureId"] ?? "",
              lectureNo: doc["lectureNo"] ?? "",
              title: doc["title"] ?? "",
              subTitle: doc["subTitle"] ?? "",
              description: doc["description"] ?? "",
              videoUrl: doc["videoUrl"] ?? "",
              thumbnailUrl: doc["thumbnailUrl"] ?? "",
              videoDuration: doc["videoDuration"] ?? "",
              allAnswers: doc["allAnswers"] ?? "",
              passingScore: doc["passingScore"],
              slideLength: doc["slideLength"],
              questionLength: doc["questionLength"],
              updateAt: doc["upDate"],
              createAt: doc["createAt"],
              targetId: doc["targetId"],
              organizerId: doc["organizerId"] ?? "",
              workshopId: doc["workshopId"] ?? "",
            ))
        .toList();
    // lectureNoでソートして配列に入れる
    _results.sort((a, b) => a.lectureNo.compareTo(b.lectureNo));
    return _results;
  }

  Future<void> setData(
    bool _isAdd,
    String _groupName,
    Lecture _data,
    DateTime _timeStamp,
  ) async {
    final _lectureId = _isAdd ? _timeStamp.toString() : _data.lectureId;
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .doc(_lectureId)
        .set({
      "lectureId": _lectureId,
      "lectureNo": _data.lectureNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "description": _data.description,
      "videoUrl": _data.videoUrl,
      "thumbnailUrl": _data.thumbnailUrl,
      "videoDuration": _data.videoDuration,
      "allAnswers": _data.allAnswers,
      "passingScore": _data.passingScore,
      "slideLength": _data.slideLength,
      "questionLength": _data.questionLength,
      "upDate": ConvertItems.instance.dateToInt(_timeStamp),
      "createAt":
          _isAdd ? ConvertItems.instance.dateToInt(_timeStamp) : _data.createAt,
      "targetId": _data.targetId,
      "organizerId": _data.organizerId,
      "workshopId": _data.workshopId,
    }).catchError((onError) {
      print(onError.toString());
    });
    // workshop.lectureLengthを保存する
    final _workshop =
        await FSWorkshop.instance.fetchData(_groupName, _data.workshopId);
    final _lectureLength = await getLectureLength(_groupName, _data.workshopId);
    _workshop.lectureLength = _lectureLength;
    await FSWorkshop.instance.setData(false, _groupName, _workshop, _timeStamp);
  }

  Future<void> deleteData(
    String _groupName,
    String _lectureId,
  ) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .doc(_lectureId)
        .delete();
  }

  Future<int> getLectureLength(_groupName, _workshopId) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .where("workshopId", isEqualTo: _workshopId)
        .get();
    return _docs.docs.length;
  }
}

class FSStorage {
  static final FSStorage instance = FSStorage();

  Future<String> uploadFile(
    String _fileName,
    File _imageFile,
  ) async {
    if (_imageFile == null) {
      return "";
    }
    final snapshot = await FirebaseStorage.instance
        .ref()
        .child("Slides/$_fileName")
        .putFile(_imageFile)
        .onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    } else {
      return "";
    }
  }

  Future<void> deleteFile(
    String url,
  ) async {
    if (url != "") {
      final ref = await FirebaseStorage.instance.getReferenceFromUrl(url);
      await ref.delete();
    }
  }
}

class FSSlide {
  static final FSSlide instance = FSSlide();

  Future<List<Slide>> fetchDates(
    String _groupName,
    String _lectureId,
  ) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .doc(_lectureId)
        .collection("Slide")
        .get();
    return _docs.docs
        .map((doc) => Slide(
              slideNo: doc["slideNo"] ?? "",
              slideUrl: doc["slideUrl"] ?? "",
            ))
        .toList();
  }

  Future<void> setData(
    String _groupName,
    String _lectureId,
    String _slideNo,
    String _slideUrl,
  ) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .doc(_lectureId)
        .collection("Slide")
        .doc(_slideNo)
        .set({
      "slideNo": _slideNo,
      "slideUrl": _slideUrl,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteData(
    String _groupName,
    String _lectureId,
    String _slideNo,
  ) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Lecture")
        .doc(_lectureId)
        .collection("Slide")
        .doc(_slideNo)
        .delete();
  }
}
