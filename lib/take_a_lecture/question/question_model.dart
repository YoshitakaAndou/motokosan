import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../lecture/lecture_model.dart';
import '../question/question_database.dart';
import '../../widgets/convert_date_to_int.dart';

class Question {
  String questionId;
  String questionNo;
  String question;
  String choices1;
  String choices2;
  String choices3;
  String choices4;
  String correctChoices;
  String answerDescription;
  int updateAt;
  int createAt;
  int answeredAt;
  String answered;
  String organizerId;
  String workshopId;
  String lectureId;

  Question({
    this.questionId = "",
    this.questionNo = "",
    this.question = "",
    this.choices1 = "",
    this.choices2 = "",
    this.choices3 = "",
    this.choices4 = "",
    this.correctChoices = "",
    this.answerDescription = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.answeredAt = 0,
    this.answered = "",
    this.organizerId = "",
    this.workshopId = "",
    this.lectureId = "",
  });
}

class QuestionList {
  Question question;
  QuestionResult questionResult;

  QuestionList({
    this.question,
    this.questionResult,
  });
}

class QuestionResult {
  int id;
  String questionId;
  String answerResult;
  int answerAt;

  QuestionResult({
    this.id,
    this.questionId = "",
    this.answerResult = "",
    this.answerAt = 0,
  });
  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'questionId': questionId,
      'answerResult': answerResult,
      'answerAt': answerAt,
    };
  }
}

class QuestionModel extends ChangeNotifier {
  List<Question> questions = List();
  Question question = Question();
  List<QuestionResult> questionResults = List();
  QuestionResult questionResult = QuestionResult();
  List<QuestionList> questionLists = List();
  QuestionList questionList = QuestionList();

  bool isUpdate = false;
  bool isLoading = false;
  bool isEditing = false;
  String correct = "";
  int answerNum = 0;
  int questionsCount = 0;

  final _questionDatabase = QuestionDatabase();

  void initQuestion(Lecture _lecture) {
    question.questionId = "";
    question.questionNo = "";
    question.question = "";
    question.choices1 = "";
    question.choices2 = "";
    question.choices3 = "";
    question.choices4 = "";
    question.correctChoices = "";
    question.answerDescription = "";
    question.updateAt = 0;
    question.createAt = 0;
    question.answeredAt = 0;
    question.answered = "";
    question.organizerId = _lecture.organizerId;
    question.workshopId = _lecture.workshopId;
    question.lectureId = _lecture.lectureId;
  }

  void initProperties() {
    isUpdate = false;
    isLoading = false;
    isEditing = false;
    correct = "";
    answerNum = 0;
    questionsCount = 0;
  }

  void initQuestionResult() {
    questionResult.questionId = "";
    questionResult.answerResult = "";
    questionResult.answerAt = 0;
  }

  void changeQRValue({String arg, String valS, int valI}) {
    switch (arg) {
      case "questionId":
        questionResult.questionId = valS;
        break;
      case "answerResult":
        questionResult.answerResult = valS;
        break;
      case "answerAt":
        questionResult.answerAt = valI;
        break;
    }
    notifyListeners();
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "question":
        question.question = _val;
        break;
      case "choices1":
        question.choices1 = _val;
        break;
      case "choices2":
        question.choices2 = _val;
        break;
      case "choices3":
        question.choices3 = _val;
        break;
      case "choices4":
        question.choices4 = _val;
        break;
      case "correctChoices":
        question.correctChoices = _val;
        break;
      case "answerDescription":
        question.answerDescription = _val;
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

  void setUpdate() {
    isUpdate = true;
    notifyListeners();
  }

  void resetUpdate() {
    isUpdate = false;
    notifyListeners();
  }

  void setCorrectForEditing() {
    correct = "";
    if (question.choices1 == question.correctChoices) {
      correct = "選択肢1";
    }
    if (question.choices2 == question.correctChoices) {
      correct = "選択肢2";
    }
  }

  void setCorrectChoices(String _correct) {
    correct = _correct;
    switch (correct) {
      case "選択肢1":
        question.correctChoices = question.choices1;
        break;
      case "選択肢2":
        question.correctChoices = question.choices2;
        break;
      case "選択肢3":
        question.correctChoices = question.choices3;
        break;
      case "選択肢4":
        question.correctChoices = question.choices4;
        break;
    }
    notifyListeners();
  }

  Future<void> fetchQuestion(String _groupName, _lectureId) async {
    questions = await _fetchQuestion(_groupName, _lectureId);
    notifyListeners();
  }

  Future<void> generateQuestionList(
      String _groupName, String _lectureId) async {
    questionLists = List();
    for (Question _question in questions) {
      final _questionResults =
          await _questionDatabase.getAnswerResult(_question.questionId);
      if (_questionResults.length < 1) {
        questionLists.add(
          QuestionList(
            question: _question,
            questionResult: QuestionResult(
              questionId: _question.questionId,
              answerResult: "未解答",
            ),
          ),
        );
      } else {
        questionLists.add(
          QuestionList(
              question: _question, questionResult: _questionResults[0]),
        );
      }
    }
    final currentCount = await _questionDatabase.countAnswerResult("○");
    print("問題数：${questionLists.length}問");
    print("正解数：$currentCount問");
    notifyListeners();
  }

  Future<List<Question>> _fetchQuestion(_groupName, _lectureId) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Question")
        .where("lectureId", isEqualTo: _lectureId)
        .getDocuments();
    final List<Question> _results = _docs.documents
        .map((doc) => Question(
              questionId: doc["questionId"],
              questionNo: doc["questionNo"],
              question: doc["question"],
              choices1: doc["choices1"],
              choices2: doc["choices2"],
              choices3: doc["choices3"],
              choices4: doc["choices4"],
              correctChoices: doc["correctChoices"],
              answerDescription: doc["answerDescription"],
              updateAt: doc["upDate"],
              createAt: doc["createAt"],
              answeredAt: doc["answeredAt"],
              answered: doc["answered"],
              organizerId: doc["organizerId"],
              workshopId: doc["workshopId"],
              lectureId: doc["lectureId"],
            ))
        .toList();
    _results.sort((a, b) => a.questionNo.compareTo(b.questionNo));
    return _results;
  }

  void inputCheck() {
    if (question.question.isEmpty) {
      throw "問題文が入力されていません！";
    }
    if (question.choices1.isEmpty) {
      throw "選択肢 1 が入力されていません！";
    }
    if (question.choices2.isEmpty) {
      throw "選択肢 2 が入力されていません！";
    }
    if (question.correctChoices.isEmpty) {
      throw "正解 が入力されていません！";
    }
    if (question.answerDescription.isEmpty) {
      throw "解答・説明が入力されていません！";
    }
  }

  Future<void> addQuestionFs(_groupName, _timeStamp, _lecture) async {
    question.questionId = _timeStamp.toString();
    await setQuestionFs(true, _groupName, question, _timeStamp);
    // LectureのquestionLengthにfetchして値を書き込む
    setLectureQSLength(_groupName, _lecture);
    notifyListeners();
  }

  Future<void> updateQuestionFs(_groupName, _timeStamp, _lecture) async {
    await setQuestionFs(false, _groupName, question, _timeStamp);
    // LectureのquestionLengthにfetchして値を書き込む
    setLectureQSLength(_groupName, _lecture);
    notifyListeners();
  }

  Future<void> setLectureQSLength(String _groupName, Lecture _data) async {
    final _questions = await _fetchQuestion(_groupName, _data.lectureId);
    _data.questionLength = _questions.length;
    final _lectureId = _data.lectureId;
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
      "upDate": _data.updateAt,
      "createAt": _data.createAt,
      "targetId": _data.targetId,
      "organizerId": _data.organizerId,
      "workshopId": _data.workshopId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> setQuestionFs(bool _isAdd, String _groupName, Question _data,
      DateTime _timeStamp) async {
    final _questionId = _isAdd ? _timeStamp.toString() : _data.questionId;
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Question")
        .document(_questionId)
        .setData({
      "questionId": _questionId,
      "questionNo": _data.questionNo,
      "question": _data.question,
      "choices1": _data.choices1,
      "choices2": _data.choices2,
      "choices3": _data.choices3,
      "choices4": _data.choices4,
      "correctChoices": _data.correctChoices,
      "answerDescription": _data.answerDescription,
      "upDate": convertDateToInt(_timeStamp),
      "createAt": _isAdd ? convertDateToInt(_timeStamp) : _data.createAt,
      "answeredAt": _isAdd ? convertDateToInt(_timeStamp) : _data.answeredAt,
      "answered": _data.answered,
      "organizerId": _data.organizerId,
      "workshopId": _data.workshopId,
      "lectureId": _data.lectureId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteQuestionFs(_groupName, _questionId) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Question")
        .document(_questionId)
        .delete();
    notifyListeners();
  }
}
