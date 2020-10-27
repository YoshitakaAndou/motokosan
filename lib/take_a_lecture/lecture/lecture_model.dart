import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_database.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';

class Lecture {
  String lectureId;
  String lectureNo;
  String title;
  String subTitle;
  String description;
  String videoUrl;
  String thumbnailUrl;
  String videoDuration;
  String allAnswers;
  int passingScore;
  int slideLength;
  int questionLength;
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
    this.thumbnailUrl = "",
    this.videoDuration = "",
    this.allAnswers = "全問解答は不要",
    this.passingScore = 0,
    this.slideLength = 0,
    this.questionLength = 0,
    this.updateAt = 0,
    this.createAt = 0,
    this.targetId = "",
    this.organizerId = "",
    this.workshopId = "",
  });
}

class LectureList {
  Lecture lecture;
  LectureResult lectureResult;

  LectureList({
    this.lecture,
    this.lectureResult,
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

class Video {
  String id;
  String url;
  String title;
  String description;
  String thumbnailUrl;
  String duration;

  Video({
    this.id,
    this.url,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.duration,
  });

  factory Video.fromMapSnippet(Map<String, dynamic> map) {
    return Video(
      id: map["id"],
      title: map["snippet"]["title"],
      description: map["snippet"]["description"],
      thumbnailUrl: map["snippet"]["thumbnails"]["default"]["url"],
      // duration: map["contentDetails"]["duration"],
    );
  }

  factory Video.fromMapContentDetails(Map<String, dynamic> map) {
    return Video(
      // id: map["id"],
      // title: map["snippet"]["title"],
      // description: map["snippet"]["description"],
      // thumbnailUrl: map["snippet"]["thumbnails"]["default"]["url"],
      duration: map["contentDetails"]["duration"],
    );
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
  Video video = Video();
  List<LectureList> lectureLists = List();

  bool isLoading = false;
  bool isUpdate = false;
  bool isEditing = false;
  bool isSlideUpdate = false;
  bool isVideoPlay = false;
  bool isFlag0 = true;
  bool isFlag1 = true;
  bool isFlag2 = true;

  String webLastUrl = "";
  String webBookmarkUrl = "";

  void initLecture(Organizer _organizer, Workshop _workshop) {
    lecture.lectureId = "";
    lecture.lectureNo = "";
    lecture.title = "";
    lecture.subTitle = "";
    lecture.description = "";
    lecture.videoUrl = "";
    lecture.thumbnailUrl = "";
    lecture.videoDuration = "";
    lecture.allAnswers = "全問解答は不要";
    lecture.passingScore = 0;
    lecture.slideLength = 0;
    lecture.questionLength = 0;
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

  void initVideo() {
    video.id = "";
    video.title = "";
    video.description = "";
    video.thumbnailUrl = "";
    video.duration = "";
  }

  void initProperties() {
    deletedSlides = List();
    slides = List();
    isLoading = false;
    isUpdate = false;
    isSlideUpdate = false;
    isVideoPlay = false;
    isEditing = false;
    // webCurrentUrl = "";
    // webFavoriteUrl = "";
  }

  void initFlag(bool _key) {
    isFlag0 = _key;
    isFlag1 = _key;
    isFlag2 = _key;
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
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

  void setIsEditing() {
    isEditing = true;
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

  bool videoSetLecture() {
    bool _result = false;
    if (isFlag0) {
      lecture.thumbnailUrl = video.thumbnailUrl;
      lecture.videoUrl = video.url;
      lecture.videoDuration = video.duration;
      _result = true;
    }
    if (isFlag1) {
      lecture.title = video.title;
      _result = true;
    }
    if (isFlag2) {
      lecture.description = video.description;
      _result = true;
    }
    notifyListeners();
    return _result;
  }

  void setVideoPlay(bool _key) {
    isVideoPlay = _key;
    notifyListeners();
  }

  void setFlag0(bool _key) {
    isFlag0 = _key;
    notifyListeners();
  }

  void setFlag1(bool _key) {
    isFlag1 = _key;
    notifyListeners();
  }

  void setFlag2(bool _key) {
    isFlag2 = _key;
    notifyListeners();
  }

  void setAllAnswers(String _key) {
    lecture.allAnswers = _key;
    // notifyListeners();
  }

  void setPassingScore(int _key) {
    lecture.passingScore = _key;
    // notifyListeners();
  }

  void inputCheck() {
    if (lecture.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    if (lecture.videoUrl.isEmpty) {
      throw "YouTube動画URL が入力されていません！";
    }
    if (!isVideoUrl(lecture.videoUrl)) {
      throw "YouTube動画URL が正しくありません！";
    }
    if (lecture.description.isEmpty) {
      throw "説明 が入力されていません！";
    }
  }

  Future<void> generateLectureList(String _groupName, _workshopId) async {
    lectureLists = List();
    lectures = await FSLecture.instance.fetchDates(_groupName, _workshopId);
    for (Lecture _lecture in lectures) {
      final _lectureResults =
          await LectureDatabase.instance.getLectureResult(_lecture.lectureId);
      if (_lectureResults.length < 1) {
        lectureLists.add(LectureList(
          lecture: _lecture,
          lectureResult: LectureResult(),
        ));
      } else {
        lectureLists.add(LectureList(
          lecture: _lecture,
          lectureResult: _lectureResults[0],
        ));
      }
    }
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
    lectures = await FSLecture.instance.fetchDates(_groupName, _workshopId);
    notifyListeners();
  }

  bool isVideoUrl(String _videoUrl) {
    final _result =
        YoutubePlayer.convertUrlToId(_videoUrl) == null ? false : true;
    isVideoPlay = _result;
    notifyListeners();
    return _result;
  }

  Future<void> addLectureFs(_groupName, _timeStamp) async {
    lecture.lectureId = _timeStamp.toString();
    await FSLecture.instance.setData(true, _groupName, lecture, _timeStamp);
    notifyListeners();
  }

  Future<void> updateLectureFs(_groupName, _timeStamp) async {
    await FSLecture.instance.setData(false, _groupName, lecture, _timeStamp);
    notifyListeners();
  }

  Future<void> addSlide(_groupName, _lectureId) async {
    if (slides.length > 1) {
      for (int i = 0; i < slides.length - 1; i++) {
        final _stFileName = Uuid().v1(); // ランダム数の取得
        slides[i].slideNo = "${i.toString().padLeft(4, "0")}";
        slides[i].slideUrl = await FSStorage.instance
            .uploadFile(_stFileName, slides[i].slideImage);
        await FSSlide.instance.setData(
            _groupName, _lectureId, slides[i].slideNo, slides[i].slideUrl);
      }
    }
    lecture.slideLength = slides.length - 1;
  }

  // Edit起動時のSlideデータ取得
  Future<void> getSlideUrls(_groupName, _lectureId) async {
    // SlideデータをFetch
    slides = await FSSlide.instance.fetchDates(_groupName, _lectureId);
    notifyListeners();
  }

  Future<void> deleteStorageImages(_groupName, _lectureId) async {
    final _slideLists =
        await FSSlide.instance.fetchDates(_groupName, _lectureId);
    for (Slide _slideList in _slideLists) {
      await FSStorage.instance.deleteFile(_slideList.slideUrl);
      await FSSlide.instance
          .deleteData(_groupName, _lectureId, _slideList.slideNo);
    }
  }

  Future<void> updateSlide(_groupName, _lectureId) async {
    // Fs上のSlideを削除
    final _slideLists =
        await FSSlide.instance.fetchDates(_groupName, _lectureId);
    for (Slide _slideList in _slideLists) {
      await FSSlide.instance
          .deleteData(_groupName, _lectureId, _slideList.slideNo);
    }
    // deletedSlide[]に入っていたimageを削除
    if (deletedSlides.length > 0) {
      for (DeletedSlide _slide in deletedSlides) {
        await FSStorage.instance.deleteFile(_slide.slideUrl);
      }
    }
    // 変更のあったslideのみ削除（slideImage != null）
    if (slides.length > 1) {
      for (int i = 0; i < slides.length - 1; i++) {
        if (slides[i].slideImage != null) {
          await FSStorage.instance.deleteFile(slides[i].slideUrl);
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
            : await FSStorage.instance
                .uploadFile(_stFileName, slides[i].slideImage);
        await FSSlide.instance.setData(
            _groupName, _lectureId, slides[i].slideNo, slides[i].slideUrl);
      }
    }
    // 配列の最後は「＋」で不要なので数えません
    lecture.slideLength = slides.length - 1;
  }
}

class FSLecture {
  static final FSLecture instance = FSLecture();

  Future<List<Lecture>> fetchDates(
    String _groupName,
    String _workshopId,
  ) async {
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
  }

  Future<void> deleteData(
    String _groupName,
    String _lectureId,
  ) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .delete();
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

  Future<void> setData(
    String _groupName,
    String _lectureId,
    String _slideNo,
    String _slideUrl,
  ) async {
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

  Future<void> deleteData(
    String _groupName,
    String _lectureId,
    String _slideNo,
  ) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Lecture")
        .document(_lectureId)
        .collection("Slide")
        .document(_slideNo)
        .delete();
  }
}
