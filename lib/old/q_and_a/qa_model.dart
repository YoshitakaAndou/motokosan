import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'qa_edit.dart';
import 'qa_firestore_model.dart';

class QuesAns {
  int id;
  String qaId;
  String category;
  String question;
  String answer;
  String description;
  String imageUrl;
  int updateAt;
  int createAt;
  String favorite;

  QuesAns({
    this.id,
    this.qaId = "",
    this.category = "",
    this.question = "",
    this.answer = "",
    this.description = "",
    this.imageUrl = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.favorite = "",
  });

  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'qaId': qaId,
      'category': category,
      'question': question,
      'answer': answer,
      'description': description,
      'imageUrl': imageUrl,
      'updateAt': updateAt,
      'createAt': createAt,
      'favorite': favorite,
    };
  }

  Map<String, dynamic> toMapQId() {
    return {
//      'id': id,
//      'qaId': qaId,
      'category': category,
      'question': question,
      'answer': answer,
      'description': description,
      'imageUrl': imageUrl,
      'updateAt': updateAt,
      'createAt': createAt,
//      'favorite': favorite,
    };
  }
}

class QaModel extends ChangeNotifier {
  List<QuesAns> dates = List();
  List<QuesAns> datesDb = List();
  List<QuesAns> datesFb = List();
  List<QuesAns> datesSg = List();
  QuesAns data = QuesAns();
  bool isUpdate = false;
  bool isLoading = false;
  bool isHelp = false;
  ImageUpType imageUpType;
  File imageFile;

  void initData() {
    data.id = 0;
    data.qaId = "";
    data.category = "";
    data.question = "";
    data.answer = "";
    data.description = "";
    data.imageUrl = "";
    data.updateAt = 0;
    data.createAt = 0;
    data.favorite = "";
    isUpdate = false;
    imageFile = null;
    notifyListeners();
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "question":
        data.question = _val;
        break;
      case "answer":
        data.answer = _val;
        break;
      case "description":
        data.description = _val;
        break;
      case "imageUrl":
        data.imageUrl = _val;
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

  void setIsHelp(bool _key) {
    isHelp = _key;
    notifyListeners();
  }

  void setImageFileNull() {
    // data.imageUrl = "";
    imageFile = null;
    notifyListeners();
  }

  void setImageUpType(ImageUpType _type) {
    imageUpType = _type;
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

  void initBeforeEditing(QuesAns _qa) {
    imageUpType = ImageUpType.NON;
    imageFile = null;
    data = _qa;
    notifyListeners();
  }

  void setCategory(String _category) {
    data.category = _category;
    notifyListeners();
  }

  void setDates(List<QuesAns> _dates) {
    dates = _dates;
    isLoading = false;
    notifyListeners();
  }

  void setDatesDb(List<QuesAns> _dates) {
    datesDb = _dates;
    notifyListeners();
  }

  void setDatesSg(List<QuesAns> _dates) {
    datesSg = _dates;
    notifyListeners();
  }

  void reBuild() {
    notifyListeners();
  }

  Future<void> fetchQasFsCloud(String _qasId) async {
    datesFb = await fetchFsCloud(_qasId);
    notifyListeners();
  }

  Future<void> addQaToFsCloud(_qasId, _timeStamp) async {
    if (data.question.isEmpty) {
      throw "Question が入力されていません！";
    }
    if (data.answer.isEmpty) {
      throw "Answer が入力されていません！";
    }
    if (data.description.isEmpty) {
      throw "description が入力されていません！";
    }
    data.imageUrl = await uploadStorage(data, imageFile);
    data.qaId = _timeStamp.toString();
    await addFsCloud(_qasId, data, _timeStamp);
    notifyListeners();
  }

  Future<void> updateQaAtFsCloud(String _qasId, String _qaId) async {
    if (data.question.isEmpty) {
      throw "Question が入力されていません！";
    }
    if (data.answer.isEmpty) {
      throw "Answer が入力されていません！";
    }
    if (data.description.isEmpty) {
      throw "description が入力されていません！";
    }
    if (imageUpType == ImageUpType.DELETE) {
      print("deleteStorage:${data.imageUrl}");
      data.imageUrl = await deleteStorage(data.imageUrl);
    }
    if (imageUpType == ImageUpType.CHANGE) {
      print("updateStorage:${data.imageUrl}");
      data.imageUrl = await uploadStorage(data, imageFile);
    }
    await updateFsCloud(_qasId, _qaId, data);
    notifyListeners();
  }

  Future<void> deleteQaAtFsCloud(_qasId, _qaId) async {
    await deleteFsCloud(_qasId, _qaId);
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile =
          await FlutterNativeImage.compressImage(pickedFile.path, quality: 70);
      setImageUpType(ImageUpType.CHANGE);
    }
    notifyListeners();
  }
}
