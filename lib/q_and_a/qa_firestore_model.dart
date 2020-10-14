import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/convert_date_to_int.dart';
import 'qa_model.dart';

Future<List<QuesAns>> fetchFsCloud(String _qasId) async {
  final _docs = await Firestore.instance.collection(_qasId).getDocuments();
  final _questions = _docs.documents
      .map((doc) => QuesAns(
            qaId: doc["qaId"],
            category: doc["category"],
            question: doc["question"],
            answer: doc["answer"],
            description: doc["description"],
            imageUrl: doc["imageUrl"],
            updateAt: doc["upDate"],
            createAt: doc["createAt"],
            favorite: doc["favorite"],
          ))
      .toList();
  return _questions;
}

Future<void> addFsCloud(_qasId, _data, _timeStamp) async {
  final _qaId = _timeStamp.toString();
  await Firestore.instance.collection(_qasId).document(_qaId).setData({
    "qaId": _qaId,
    "category": _data.organizer,
    "question": _data.question,
    "answer": _data.answer,
    "description": _data.description,
    "imageUrl": _data.imageUrl,
    "update": convertDateToInt(_timeStamp),
    "createAt": convertDateToInt(_timeStamp),
  }).catchError((onError) {
    print(onError.toString());
  });
}

Future<void> updateFsCloud(_qasId, _qaId, _data) async {
  await Firestore.instance.collection(_qasId).document(_qaId).setData({
    "qaId": _qaId,
    "category": _data.organizer,
    "question": _data.question,
    "answer": _data.answer,
    "description": _data.description,
    "imageUrl": _data.imageUrl,
    "update": convertDateToInt(DateTime.now()),
    "createAt": _data.createAt,
  }).catchError((onError) {
    print(onError.toString());
  });
}

Future<void> deleteFsCloud(String _qasId, String _qaId) async {
  await Firestore.instance.collection(_qasId).document(_qaId).delete();
}

Future<String> deleteStorage(String url) async {
  if (url != "") {
    final ref = await FirebaseStorage.instance.getReferenceFromUrl(url);
    await ref.delete();
    print("deleteStorage:$url");
  }
  return "";
}

Future<String> uploadStorage(QuesAns _data, File _imageFile) async {
  if (_imageFile == null) {
    return "";
  }
  final storage = FirebaseStorage.instance;
  StorageTaskSnapshot snapshot = await storage
      .ref()
      .child("Images/${_data.qaId}")
      .putFile(_imageFile)
      .onComplete;
  if (snapshot.error == null) {
    final String _downloadUrl = await snapshot.ref.getDownloadURL();
    return _downloadUrl;
  } else {
    return "";
  }
}
