import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'lec_model.dart';

Future<List<Lec>> lFetchFsCloud(_lecsId) async {
  final _docs = await FirebaseFirestore.instance
      .collection(_lecsId)
      .orderBy('lecNo', descending: false)
      .get();
  final _lectures = _docs.docs
      .map((doc) => Lec(
            lecId: doc["lecId"],
            category: doc["category"],
            subcategory: doc["subcategory"],
            lecTitle: doc["lecTitle"],
            videoUrl: doc["videoUrl"],
            lecNo: doc["lecNo"],
            description: doc["description"],
            correctQuestion: doc["correctQuestion"],
            correctAnswer: doc["correctAnswer"],
            incorrectQuestion: doc["incorrectQuestion"],
            incorrectAnswer: doc["incorrectAnswer"],
            slideUrl: doc["slideUrl"],
            updateAt: doc["upDate"],
            createAt: doc["createAt"],
          ))
      .toList();
  return _lectures;
}

Future<void> lAddFsCloud(_lecsId, _data, _timeStamp) async {
  final _lecId = _timeStamp.toString();
  await FirebaseFirestore.instance.collection(_lecsId).doc(_lecId).set({
    "lecId": _lecId,
    "category": _data.organizer,
    "subcategory": _data.subcategory,
    "lecTitle": _data.lecTitle,
    "videoUrl": _data.videoUrl,
    "lecNo": _data.lecNo,
    "description": _data.description,
    "correctQuestion": _data.correctQuestion,
    "correctAnswer": _data.correctAnswer,
    "incorrectQuestion": _data.incorrectQuestion,
    "incorrectAnswer": _data.incorrectAnswer,
    "slideUrl": _data.slideUrl,
    "update": ConvertDateTime.instance.dateToInt(_timeStamp),
    "createAt": ConvertDateTime.instance.dateToInt(_timeStamp),
  }).catchError((onError) {
    print(onError.toString());
  });
}

Future<void> lUpdateFsCloud(_lecsId, _lecId, _data) async {
  await FirebaseFirestore.instance.collection(_lecsId).doc(_lecId).set({
    "lecId": _lecId,
    "category": _data.organizer,
    "subcategory": _data.subcategory,
    "lecTitle": _data.lecTitle,
    "videoUrl": _data.videoUrl,
    "lecNo": _data.lecNo,
    "description": _data.description,
    "correctQuestion": _data.correctQuestion,
    "correctAnswer": _data.correctAnswer,
    "incorrectQuestion": _data.incorrectQuestion,
    "incorrectAnswer": _data.incorrectAnswer,
    "slideUrl": _data.slideUrl,
    "update": ConvertDateTime.instance.dateToInt(DateTime.now()),
    "createAt": _data.createAt,
  }).catchError((onError) {
    print(onError.toString());
  });
}

Future<void> lDeleteFsCloud(_lecsId, _lecId) async {
  await FirebaseFirestore.instance.collection(_lecsId).doc(_lecId).delete();
}

Future<String> lDeleteStorage(String url) async {
  if (url != "") {
    final ref = await FirebaseStorage.instance.getReferenceFromUrl(url);
    await ref.delete();
    print("deleteStorage:$url");
  }
  return "";
}

Future<String> lUploadStorage(Lec _data, File _imageFile) async {
  if (_imageFile == null) {
    return "";
  }
  final snapshot = await FirebaseStorage.instance
      .ref()
      .child("Slides/${_data.lecId}")
      .putFile(_imageFile)
      .onComplete;
  if (snapshot.error == null) {
    return await snapshot.ref.getDownloadURL();
  } else {
    return "";
  }
}
