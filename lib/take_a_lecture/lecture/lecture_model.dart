import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import '../../widgets/convert_date_to_int.dart';

class Lecture {
  String lectureId;
  String lectureNo;
  String title;
  String subTitle;
  String description;
  String videoUrl;
  int slideLength;
  int updateAt;
  int createAt;
  String targetId;
  String organizerId;
  String workshopId;

  Lecture({
    this.lectureId = "",
    this.lectureNo = "",
    this.title = "",
    this.subTitle = "",
    this.description = "",
    this.videoUrl = "",
    this.slideLength = 0,
    this.updateAt = 0,
    this.createAt = 0,
    this.targetId = "",
    this.organizerId = "",
    this.workshopId = "",
  });
}

class LectureResult {
  int id;
  String lectureId;
  String isTaken;
  int questionCount;
  int correctCount;
  int isTakenAt;

  LectureResult({
    this.id,
    this.lectureId = "",
    this.isTaken = "",
    this.questionCount = 0,
    this.correctCount = 0,
    this.isTakenAt = 0,
  });
  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'lectureId': lectureId,
      'isTaken': isTaken,
      'questionCount': questionCount,
      'correctCount': correctCount,
      'isTakenAt': isTakenAt,
    };
  }
}

class Slide {
  String slideNo;
  String slideUrl;
  File slideImage;

  Slide({
    this.slideNo = "",
    this.slideUrl = "",
    this.slideImage,
  });
}

class DeletedSlide {
  String slideNo;
  String slideUrl;
  DeletedSlide({this.slideNo, this.slideUrl});
}

class LectureModel extends ChangeNotifier {
  List<Lecture> lectures = [];
  Lecture lecture = Lecture();
  List<Slide> slides = [];
  Slide slide = Slide();
  List<DeletedSlide> deletedSlides = [];
  List<LectureResult> lectureResults = [];
  LectureResult lectureResult = LectureResult();

  bool isLoading = false;
  bool isUpdate = false;
  bool isSlideUpdate = false;
  bool isVideoPlay = false;

  String webCurrentUrl = "";
  String webFavoriteUrl = "";

  void initLecture(Organizer _organizer, Workshop _workshop) {
    lecture.lectureId = "";
    lecture.lectureNo = "";
    lecture.title = "";
    lecture.subTitle = "";
    lecture.description = "";
    lecture.videoUrl = "";
    lecture.slideLength = 0;
    lecture.updateAt = 0;
    lecture.createAt = 0;
    lecture.targetId = "";
    lecture.organizerId = _organizer.organizerId;
    lecture.workshopId = _workshop.workshopId;
  }

  void initSlide() {
    slide.slideNo = "";
    slide.slideUrl = "";
    slide.slideImage = null;
  }

  void initProperties() {
    deletedSlides = List();
    slides = List();
    isLoading = false;
    isUpdate = false;
    isSlideUpdate = false;
    isVideoPlay = false;
    // webCurrentUrl = "";
    // webFavoriteUrl = "";
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "lectureId":
        lecture.lectureId = _val;
        break;
      case "lectureNo":
        lecture.lectureNo = _val;
        break;
      case "title":
        lecture.title = _val;
        break;
      case "subTitle":
        lecture.subTitle = _val;
        break;
      case "description":
        lecture.description = _val;
        break;
      case "videoUrl":
        lecture.videoUrl = _val;
        break;
    }
    notifyListeners();
  }

  void setSlideImage(int _index, File _imageFile) {
    slides[_index].slideImage = _imageFile;
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

  void slideRemoveAt(int _index) {
    slides.removeAt(_index);
    notifyListeners();
  }

  Future<File> selectImage(File _imageFile) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return await FlutterNativeImage.compressImage(pickedFile.path,
            quality: 50);
      } else {
        // imagePickerでキャンセルが押されたら元の画像を返す
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> fetchLecture(String _groupName, _workshopId) async {
    lectures = await _fetchLecture(_groupName, _workshopId);
    notifyListeners();
  }

  Future<List<Lecture>> _fetchLecture(_groupName, _workshopId) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .where("workshopId", isEqualTo: _workshopId)
        // .orderBy('trainingNo', descending: false)
        .getDocuments();
    final List<Lecture> _results = _docs.documents
        .map((doc) => Lecture(
              lectureId: doc["lectureId"] ?? "",
              lectureNo: doc["lectureNo"] ?? "",
              title: doc["title"] ?? "",
              subTitle: doc["subTitle"] ?? "",
              description: doc["description"] ?? "",
              videoUrl: doc["videoUrl"] ?? "",
              slideLength: doc["slideLength"],
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

  void inputCheck() {
    if (lecture.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    if (lecture.videoUrl.isEmpty) {
      throw "YouTube動画URL が入力されていません！";
    }
    if (lecture.description.isEmpty) {
      throw "説明 が入力されていません！";
    }
  }

  bool isVideoUrl(String _videoUrl) {
    final _result =
        YoutubePlayer.convertUrlToId(_videoUrl) == null ? false : true;
    isVideoPlay = _result;
    return _result;
  }

  Future<void> addLectureFs(_groupName, _timeStamp) async {
    // Firebaseへデータを新規登録
    lecture.lectureId = _timeStamp.toString();
    await setLectureFs(true, _groupName, lecture, _timeStamp);
    notifyListeners();
  }

  Future<void> updateLectureFs(_groupName, _timeStamp) async {
    await setLectureFs(false, _groupName, lecture, _timeStamp);
    notifyListeners();
  }

  Future<void> setLectureFs(bool _isAdd, String _groupName, Lecture _data,
      DateTime _timeStamp) async {
    final _lectureId = _isAdd ? _timeStamp.toString() : _data.lectureId;
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .setData({
      "lectureId": _lectureId,
      "lectureNo": _data.lectureNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "description": _data.description,
      "videoUrl": _data.videoUrl,
      "slideLength": _data.slideLength,
      "upDate": convertDateToInt(_timeStamp),
      "createAt": _isAdd ? convertDateToInt(_timeStamp) : _data.createAt,
      "targetId": _data.targetId,
      "organizerId": _data.organizerId,
      "workshopId": _data.workshopId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> setSlideFs(String _groupName, String _lectureId, String _slideNo,
      String _slideUrl) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .collection("Slide")
        .document(_slideNo)
        .setData({
      "slideNo": _slideNo,
      "slideUrl": _slideUrl,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> addSlide(_groupName, _lectureId) async {
    if (slides.length > 1) {
      for (int i = 0; i < slides.length - 1; i++) {
        final _stFileName = Uuid().v1();
        slides[i].slideNo = "${i.toString().padLeft(4, "0")}";
        slides[i].slideUrl =
            await uploadStorage(_stFileName, slides[i].slideImage);
        await setSlideFs(
            _groupName, _lectureId, slides[i].slideNo, slides[i].slideUrl);
      }
    }
    lecture.slideLength = slides.length - 1;
  }

  Future<String> uploadStorage(String _fileName, File _imageFile) async {
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

  // Edit起動時のSlideデータ取得
  Future<void> getSlideUrls(_groupName, _lectureId) async {
    // SlideデータをFetch
    slides = await fetchSlide(_groupName, _lectureId);
    notifyListeners();
  }

  // 削除プロセス
  Future<void> deleteStorageImages(_groupName, _lectureId) async {
    final _slideLists = await fetchSlide(_groupName, _lectureId);
    for (Slide _slideList in _slideLists) {
      await deleteStorage(_slideList.slideUrl);
      await deleteSlideFs(_groupName, _lectureId, _slideList.slideNo);
    }
  }

  Future<void> updateSlide(_groupName, _lectureId) async {
    // Fs上のSlideを削除
    final _slideLists = await fetchSlide(_groupName, _lectureId);
    for (Slide _slideList in _slideLists) {
      await deleteSlideFs(_groupName, _lectureId, _slideList.slideNo);
    }
    // deletedSlide[]に入っていたimageを削除
    if (deletedSlides.length > 0) {
      for (DeletedSlide _slide in deletedSlides) {
        await deleteStorage(_slide.slideUrl);
      }
    }
    // 変更のあったslideのみ削除（slideImage != null）
    if (slides.length > 1) {
      for (int i = 0; i < slides.length - 1; i++) {
        if (slides[i].slideImage != null) {
          await deleteStorage(slides[i].slideUrl);
        }
      }
    }
    // Slideを登録
    if (slides.length > 1) {
      for (int i = 0; i < slides.length - 1; i++) {
        final _stFileName = Uuid().v1();
        slides[i].slideNo = "${i.toString().padLeft(4, "0")}";
        slides[i].slideUrl = slides[i].slideImage == null
            ? slides[i].slideUrl
            : await uploadStorage(_stFileName, slides[i].slideImage);
        await setSlideFs(
            _groupName, _lectureId, slides[i].slideNo, slides[i].slideUrl);
      }
    }
    // 配列の最後は「＋」で不要なので数えません
    lecture.slideLength = slides.length - 1;
  }

  // FSからSlideのデータを取得
  Future<List<Slide>> fetchSlide(_groupName, _lectureId) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .collection("Slide")
        .getDocuments();
    return _docs.documents
        .map((doc) => Slide(
              slideNo: doc["slideNo"] ?? "",
              slideUrl: doc["slideUrl"] ?? "",
            ))
        .toList();
  }

  Future<void> deleteStorage(String url) async {
    if (url != "") {
      final ref = await FirebaseStorage.instance.getReferenceFromUrl(url);
      await ref.delete();
    }
  }

  Future<void> deleteSlideFs(_groupName, _lectureId, _slideNo) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .collection("Slide")
        .document(_slideNo)
        .delete();
  }

  Future<void> deleteLectureFs(_groupName, _lectureId) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .delete();
    notifyListeners();
  }
}
