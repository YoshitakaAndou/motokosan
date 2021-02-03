import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/constants.dart';
import 'lec_edit.dart';
import 'lec_database_model.dart';
import 'lec_firestore_model.dart';

//カテゴリーの名前
// const String CATEGORY01 = "医療被ばくの基本的考え方";
// const String CATEGORY02 = "放射線診療の正当化";
// const String CATEGORY03 = "放射線診療の防護の最適化";
// const String CATEGORY04 = "放射線障害が生じた場合の対応";
// const String CATEGORY05 = "患者への情報提供";

class Lec {
  int id;
  String lecId;
  String category;
  String subcategory;
  String lecTitle;
  String videoUrl;
  String lecNo;
  String description;
  String correctQuestion;
  String correctAnswer;
  String incorrectQuestion;
  String incorrectAnswer;
  String slideUrl;
  int updateAt;
  int createAt;
  String favorite;
  String viewed;
  String answered;
  int answeredDate;
  String key;

  Lec({
    this.id,
    this.lecId = "",
    this.category = "",
    this.subcategory = "",
    this.lecTitle = "",
    this.videoUrl = "",
    this.lecNo = "",
    this.description = "",
    this.correctQuestion = "",
    this.correctAnswer = "",
    this.incorrectQuestion = "",
    this.incorrectAnswer = "",
    this.slideUrl = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.favorite = "",
    this.viewed = "",
    this.answered = "",
    this.answeredDate = 0,
    this.key,
  });

  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'lecId': lecId,
      'category': category,
      'subcategory': subcategory,
      'lecTitle': lecTitle,
      'videoUrl': videoUrl,
      'lecNo': lecNo,
      'description': description,
      'correctQuestion': correctQuestion,
      'correctAnswer': correctAnswer,
      'incorrectQuestion': incorrectQuestion,
      'incorrectAnswer': incorrectAnswer,
      'slideUrl': slideUrl,
      'updateAt': updateAt,
      'createAt': createAt,
      'favorite': favorite,
      'viewed': viewed,
      'answered': answered,
      'answeredDate': answeredDate,
    };
  }

  Map<String, dynamic> toMapLecId() {
    return {
//      'id': id,
//      'qaId': qaId,
      'category': category,
      'subcategory': subcategory,
      'lecTitle': lecTitle,
      'videoUrl': videoUrl,
      'lecNo': lecNo,
      'description': description,
      'correctQuestion': correctQuestion,
      'correctAnswer': correctAnswer,
      'incorrectQuestion': incorrectQuestion,
      'incorrectAnswer': incorrectAnswer,
      'slideUrl': slideUrl,
      'updateAt': updateAt,
      'createAt': createAt,
//      'favorite': favorite,
//       'viewed': viewed,
//       'answered': answered,
//       'answeredDate': answeredDate,
    };
  }
}

class LecModel extends ChangeNotifier {
  // List<Lecture> dates = List();
  List<Lec> datesDb = List();
  List<Lec> datesFb = List();
  List<Lec> datesSg = List();
  List<Lec> dates01 = List();
  List<Lec> dates02 = List();
  List<Lec> dates03 = List();
  List<Lec> dates04 = List();
  List<Lec> dates05 = List();

  // Category category = Category();
  Lec data = Lec();
  bool isUpdate = false;
  bool isLoading = false;
  bool isHelp = false;
  bool showVideo = false;
  String videoButtonTitle = "動画を確認";
  SlideUpType slideUpType;
  File imageFile;
  int datesAnsCount = 0;
  int dates01AnsCount = 0;
  int dates02AnsCount = 0;
  int dates03AnsCount = 0;
  int dates04AnsCount = 0;
  int dates05AnsCount = 0;
  bool isPass = false;
  bool isSorting = false;

  // LecListItem lecListItem = LecListItem();

  void initData() {
    data.id = 0;
    data.lecId = "";
    data.category = "";
    data.subcategory = "";
    data.lecTitle = "";
    data.videoUrl = "";
    data.lecNo = "";
    data.description = "";
    data.correctQuestion = "";
    data.correctAnswer = "";
    data.incorrectQuestion = "";
    data.incorrectAnswer = "";
    data.slideUrl = "";
    data.updateAt = 0;
    data.createAt = 0;
    data.favorite = "";
    data.viewed = "";
    data.answered = "";
    data.answeredDate = 0;
    isUpdate = false;
    imageFile = null;
    isPass = false;
    showVideo = false;
    videoButtonTitle = "動画を確認";
    notifyListeners();
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "subcategory":
        data.subcategory = _val;
        break;
      case "lecTitle":
        data.lecTitle = _val;
        break;
      case "videoUrl":
        data.videoUrl = _val;
        break;
      case "lecNo":
        data.lecNo = _val;
        break;
      case "description":
        data.description = _val;
        break;
      case "correctQuestion":
        data.correctQuestion = _val;
        break;
      case "correctAnswer":
        data.correctAnswer = _val;
        break;
      case "incorrectQuestion":
        data.incorrectQuestion = _val;
        break;
      case "incorrectAnswer":
        data.incorrectAnswer = _val;
        break;
      case "slideUrl":
        data.slideUrl = _val;
        break;
    }
    notifyListeners();
  }

  Future<List<Lec>> getLecCategoryDates(
      LecDatabaseModel _database, String _categoryName) async {
    return await _database.getWhereLecsCategory(_categoryName);
  }

  void setLecCategoryDates(String _categoryName, List<Lec> _dates) {
    if (_categoryName == CATEGORY01) {
      dates01 = _dates;
    }
    if (_categoryName == CATEGORY02) {
      dates02 = _dates;
    }
    if (_categoryName == CATEGORY03) {
      dates03 = _dates;
    }
    if (_categoryName == CATEGORY04) {
      dates04 = _dates;
    }
    if (_categoryName == CATEGORY05) {
      dates05 = _dates;
    }
    notifyListeners();
  }

  Future<int> getLecAnsweredCount(LecDatabaseModel _database,
      String _categoryName, String _answered) async {
    final _results =
        await _database.getWhereCategoryAnswered(_categoryName, _answered);
    return _results.length;
  }

  int setLecAnswerCount(String _categoryName, int _ansCount) {
    if (_categoryName == CATEGORY01) {
      dates01AnsCount = _ansCount;
    }
    if (_categoryName == CATEGORY02) {
      dates02AnsCount = _ansCount;
    }
    if (_categoryName == CATEGORY03) {
      dates03AnsCount = _ansCount;
    }
    if (_categoryName == CATEGORY04) {
      dates04AnsCount = _ansCount;
    }
    if (_categoryName == CATEGORY05) {
      dates05AnsCount = _ansCount;
    }
    return _ansCount;
  }

  Future<void> fetchLecsFsCloud(String _lecsId) async {
    datesFb = await lFetchFsCloud(_lecsId);
    notifyListeners();
  }

  Future<void> addQaToFsCloud(_lecsId, _timeStamp) async {
    if (data.subcategory.isEmpty) {
      throw "サブカテゴリー が入力されていません！";
    }
    if (data.lecTitle.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    if (data.videoUrl.isEmpty) {
      throw "動画URL が入力されていません！";
    }
    if (data.lecNo.isEmpty) {
      throw "ナンバー が入力されていません！";
    }
    if (data.description.isEmpty) {
      throw "description が入力されていません！";
    }
    if (data.correctQuestion.isEmpty) {
      throw "正答問題 が入力されていません！";
    }
    if (data.correctAnswer.isEmpty) {
      throw "正答解答 が入力されていません！";
    }
    if (data.incorrectQuestion.isEmpty) {
      throw "誤答問題 が入力されていません！";
    }
    if (data.incorrectAnswer.isEmpty) {
      throw "誤答解答 が入力されていません！";
    }
    data.slideUrl = await lUploadStorage(data, imageFile);
    data.lecId = _timeStamp.toString();
    await lAddFsCloud(_lecsId, data, _timeStamp);
    notifyListeners();
  }

  Future<void> updateLecAtFsCloud(String _lecsId, String _lecId) async {
    if (data.subcategory.isEmpty) {
      throw "サブカテゴリー が入力されていません！";
    }
    if (data.lecTitle.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    if (data.videoUrl.isEmpty) {
      throw "動画URL が入力されていません！";
    }
    if (data.description.isEmpty) {
      throw "description が入力されていません！";
    }
    if (data.correctQuestion.isEmpty) {
      throw "正答問題 が入力されていません！";
    }
    if (data.correctAnswer.isEmpty) {
      throw "正答解答 が入力されていません！";
    }
    if (data.incorrectQuestion.isEmpty) {
      throw "誤答問題 が入力されていません！";
    }
    if (data.incorrectAnswer.isEmpty) {
      throw "誤答解答 が入力されていません！";
    }
    if (slideUpType == SlideUpType.DELETE) {
      print("deleteStorage:${data.slideUrl}");
      data.slideUrl = await lDeleteStorage(data.slideUrl);
    }
    if (slideUpType == SlideUpType.CHANGE) {
      print("updateStorage:${data.slideUrl}");
      data.slideUrl = await lUploadStorage(data, imageFile);
    }
    await lUpdateFsCloud(_lecsId, _lecId, data);
    notifyListeners();
  }

  Future<void> deleteLecAtFsCloud(_lecsId, _lecId) async {
    await lDeleteFsCloud(_lecsId, _lecId);
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile =
          await FlutterNativeImage.compressImage(pickedFile.path, quality: 70);
      setSlideUpType(SlideUpType.CHANGE);
    }
    notifyListeners();
  }

  void isShowVideo(bool _key) {
    showVideo = _key;
    notifyListeners();
  }

  void setIsPass(bool _key) {
    isPass = _key;
    notifyListeners();
  }

  void setIsHelp(bool _key) {
    isHelp = _key;
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

  void setImageFileNull() {
    // data.imageUrl = "";
    imageFile = null;
    notifyListeners();
  }

  void setSlideUpType(SlideUpType _type) {
    slideUpType = _type;
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

  void initBeforeEditing(Lec _qa) {
    slideUpType = SlideUpType.NON;
    imageFile = null;
    data = _qa;
    notifyListeners();
  }

  void setCategory(String _category) {
    data.category = _category;
    notifyListeners();
  }

  void setLecNo(String _lecNo) {
    data.lecNo = _lecNo;
    notifyListeners();
  }

  void setDatesDb(List<Lec> _dates) {
    datesDb = _dates;
    notifyListeners();
  }

  void setDatesSg(List<Lec> _dates) {
    datesSg = _dates;
    notifyListeners();
  }

  void setSorting(bool _key) {
    isSorting = _key;
    notifyListeners();
  }

  void reBuild() {
    notifyListeners();
  }

  void warningDialog(_context, _title, _desc) {
    AwesomeDialog(
      context: _context,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: false,
      animType: AnimType.TOPSLIDE,
      title: _title,
      desc: _desc,
      autoHide: Duration(seconds: 3),
    )..show();
  }

  void successDialog(_context, _title) {
    AwesomeDialog(
      context: _context,
      dialogType: DialogType.SUCCES,
      headerAnimationLoop: false,
      animType: AnimType.TOPSLIDE,
      title: _title,
      autoHide: Duration(seconds: 3),
    )..show();
  }
}
