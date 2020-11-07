import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_firebase.dart';
import 'question_class.dart';
import 'play/question_database.dart';
import 'play/question_firebase.dart';

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
  bool isClear = false;
  bool isScoreClear = false;
  bool isAllAnswersClear = false;
  bool isStack = false;
  String correct = "";
  int answerNum = 0;
  int questionsCount = 0;
  int correctCount = 0;

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
    isClear = false;
    isScoreClear = false;
    isAllAnswersClear = false;
    isStack = false;
    correct = "";
    answerNum = 0;
    questionsCount = 0;
    correctCount = 0;
  }

  void initQuestionResult() {
    questionResult.questionId = "";
    questionResult.answerResult = "";
    questionResult.answerAt = 0;
    questionResult.lectureId = "";
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

  void setAllAnswersClear(bool _key) {
    isAllAnswersClear = _key;
    notifyListeners();
  }

  void setScoreClear(bool _key) {
    isScoreClear = _key;
    notifyListeners();
  }

  void setClear(bool _key) {
    isClear = _key;
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void setIsStack(bool _key) {
    isStack = _key;
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

  Future<void> generateQuestionList(
      String _groupName, String _lectureId) async {
    questionLists = List();
    correctCount = 0;
    await QuestionDatabase.instance.flag1Reset("");
    for (Question _question in questions) {
      final _questionResults = await QuestionDatabase.instance
          .getAnswerResultQuestionId(_question.questionId);
      if (_questionResults.length < 1) {
        questionLists.add(
          QuestionList(
            question: _question,
            questionResult: QuestionResult(
              questionId: _question.questionId,
              answerResult: "未解答",
              lectureId: _question.lectureId,
            ),
          ),
        );
      } else {
        // 本体のQRとクラウドのQuestionの整合性を保つための処理
        if (_questionResults[0].answerResult.isNotEmpty) {
          QuestionResult _saveData = _questionResults[0];
          // flag1に存在したマークをつけてDBに戻す
          _saveData.flag1 = "true";
          await QuestionDatabase.instance.saveValue(_saveData);
          // 正解の個数を求める
          if (_questionResults[0].answerResult == "○") {
            correctCount += 1;
          }
        }
        questionLists.add(
          QuestionList(
            question: _question,
            questionResult: _questionResults[0],
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<void> fetchQuestion(String _groupName, _lectureId) async {
    questions = await FSQuestion.instance.fetchDates(_groupName, _lectureId);
    notifyListeners();
  }

  Future<void> addQuestionFs(_groupName, _timeStamp, _lecture) async {
    question.questionId = _timeStamp.toString();
    await FSQuestion.instance.setData(true, _groupName, question, _timeStamp);
    setQSLengthToLecture(_groupName, _lecture);
    notifyListeners();
  }

  Future<void> updateQuestionFs(_groupName, _timeStamp, _lecture) async {
    await FSQuestion.instance.setData(false, _groupName, question, _timeStamp);
    setQSLengthToLecture(_groupName, _lecture);
    notifyListeners();
  }

  Future<void> setQSLengthToLecture(String _groupName, Lecture _data) async {
    final _questions =
        await FSQuestion.instance.fetchDates(_groupName, _data.lectureId);
    _data.questionLength = _questions.length;
    FSLecture.instance.setData(false, _groupName, _data, DateTime.now());
  }

  Future<void> deleteQuestionFs(_groupName, _questionId) async {
    await FSQuestion.instance.deleteData(_groupName, _questionId);
    notifyListeners();
  }
}
