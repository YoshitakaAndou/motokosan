import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/question/question_class.dart';

import 'exam_class.dart';
import 'play/exam_firebase.dart';

class ExamModel extends ChangeNotifier {
  List<Question> questions = List();
  Question question = Question();
  List<ExamResult> examResults = List();
  ExamResult examResult = ExamResult();
  List<ExamList> examLists = List();
  ExamList examList = ExamList();

  bool isUpdate = false;
  bool isLoading = false;
  bool isEditing = false;
  bool isClear = false;
  bool isScoreClear = false;
  bool isAllAnswersClear = false;
  bool isStack = false;
  bool isShowOk = false;
  bool isAllAnswers = false;
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
    // isShowOk = false;
    isAllAnswers = false;
    correct = "";
    answerNum = 0;
    questionsCount = 0;
    correctCount = 0;
  }

  void setIsTaken() {
    notifyListeners();
  }

  void setAllAnswersClear(bool _key) {
    isAllAnswersClear = _key;
    notifyListeners();
  }

  void setAllAnswers(bool _key) {
    isAllAnswers = _key;
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

  void setShowOk(bool _key) {
    isShowOk = _key;
    notifyListeners();
  }

  void setExamResult(int _index, String _result) {
    examLists[_index].examResult.answerResult = _result;
    notifyListeners();
  }

  Future<void> generateExamList(
      String _groupName, _workshopId, _numOfExam) async {
    questions = await FSExam.instance.fetchDates(_groupName, _workshopId);
    if (_numOfExam < questions.length) {
      // 先頭からn個の配列を作る
      questions.removeRange(_numOfExam - 1, questions.length - 1);
    }
    examLists = List();
    for (Question _question in questions) {
      examLists.add(
        ExamList(
          question: _question,
          examResult: ExamResult(),
        ),
      );
    }
    notifyListeners();
  }
}
