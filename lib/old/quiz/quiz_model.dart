// import 'package:flutter/material.dart';
// import 'quiz_firestore_model.dart';
//
// class Question {
//   int id;
//   String questionId;
//   String category;
//   String question;
//   String option1;
//   String option2;
//   String option3;
//   String option4;
//   String correctOption;
//   String answerDescription;
//   int updateAt;
//   int createAt;
//   String answered;
//   String favorite;
//
//   Question({
//     this.id,
//     this.questionId = "",
//     this.category = "",
//     this.question = "",
//     this.option1 = "",
//     this.option2 = "",
//     this.option3 = "",
//     this.option4 = "",
//     this.correctOption = "",
//     this.answerDescription = "",
//     this.updateAt = 0,
//     this.createAt = 0,
//     this.answered = "",
//     this.favorite = "",
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
// //      'id': id,
//       'questionId': questionId,
//       'category': category,
//       'question': question,
//       'option1': option1,
//       'option2': option2,
//       'option3': option3,
//       'option4': option4,
//       'correctOption': correctOption,
//       'answerDescription': answerDescription,
//       'updateAt': updateAt,
//       'createAt': createAt,
//       'answered': answered,
//       'favorite': favorite,
//     };
//   }
//
//   Map<String, dynamic> toMapQId() {
//     return {
// //      'id': id,
// //      'questionId': questionId,
//       'category': category,
//       'question': question,
//       'option1': option1,
//       'option2': option2,
//       'option3': option3,
//       'option4': option4,
//       'correctOption': correctOption,
//       'answerDescription': answerDescription,
//       'updateAt': updateAt,
//       'createAt': createAt,
// //      'answered': answered,
// //      'favorite': favorite,
//     };
//   }
// }
//
// class QuizModel extends ChangeNotifier {
//   List<Question> dates = List();
//   List<Question> datesDb = List();
//   List<Question> datesFb = List();
//   List<Question> datesSg = List();
//   Question data = Question();
//   bool isUpdate = false;
//   bool isLoading = false;
//   bool isCorrect = false;
//   bool isSort = false;
//   bool isHelp = false;
//   String correct = "";
//   int answerNum = 0;
//   int questionsCount;
//
//   void initData() {
//     data.id = 0;
//     data.questionId = "";
//     data.category = "";
//     data.question = "";
//     data.option1 = "";
//     data.option2 = "";
//     data.option3 = "";
//     data.option4 = "";
//     data.correctOption = "";
//     data.answerDescription = "";
//     data.updateAt = 0;
//     data.createAt = 0;
//     data.answered = "";
//     data.favorite = "";
//     isUpdate = false;
//     isCorrect = false;
//     correct = "";
//     answerNum = 0;
//     notifyListeners();
//   }
//
//   void changeValue(String _arg, String _val) {
//     switch (_arg) {
//       case "question":
//         data.question = _val;
//         break;
//       case "option1":
//         data.option1 = _val;
//         break;
//       case "option2":
//         data.option2 = _val;
//         break;
//       case "option3":
//         data.option3 = _val;
//         break;
//       case "option4":
//         data.option4 = _val;
//         break;
//       case "answerDescription":
//         data.answerDescription = _val;
//         break;
//     }
//     notifyListeners();
//   }
//
//   void startLoading() {
//     isLoading = true;
//     notifyListeners();
//   }
//
//   void stopLoading() {
//     isLoading = false;
//     notifyListeners();
//   }
//
//   void setIsHelp(bool _key) {
//     isHelp = _key;
//     notifyListeners();
//   }
//
//   void initBeforeEditing(Question _question) {
//     data = _question;
//   }
//
//   void setCategory(String _category) {
//     data.category = _category;
//     notifyListeners();
//   }
//
//   void setDates(List<Question> _dates) {
//     dates = _dates;
//     isLoading = false;
//     notifyListeners();
//   }
//
//   void setDatesDb(List<Question> _dates) {
//     datesDb = _dates;
//     notifyListeners();
//   }
//
//   void setDatesSg(List<Question> _dates) {
//     datesSg = _dates;
//     notifyListeners();
//   }
//
//   void reBuild() {
//     notifyListeners();
//   }
//
//   void setCorrectForEditing() {
//     correct = "";
//     if (data.option1 == data.correctOption) {
//       correct = "選択肢1";
//     }
//     if (data.option2 == data.correctOption) {
//       correct = "選択肢2";
//     }
//     if (data.option3 == data.correctOption) {
//       correct = "選択肢3";
//     }
//     if (data.option4 == data.correctOption) {
//       correct = "選択肢4";
//     }
//   }
//
//   void setCorrectOption(String _correct) {
//     correct = _correct;
//     switch (correct) {
//       case "選択肢1":
//         data.correctOption = data.option1;
//         break;
//       case "選択肢2":
//         data.correctOption = data.option2;
//         break;
//       case "選択肢3":
//         data.correctOption = data.option3;
//         break;
//       case "選択肢4":
//         data.correctOption = data.option4;
//         break;
//     }
//     notifyListeners();
//   }
//
//   Future<void> fetchQuestionsFsCloud(String _quizId) async {
//     datesFb = await fetchQuizFsCloud(_quizId);
//     isLoading = false;
//     notifyListeners();
//   }
//
//   Future<void> addQuestionFsCloud(_quizId, _timeStamp) async {
//     if (data.question.isEmpty) {
//       throw "問題文が入力されていません！";
//     }
//     if (data.option1.isEmpty) {
//       throw "選択肢 1 が入力されていません！";
//     }
//     if (data.option2.isEmpty) {
//       throw "選択肢 2 が入力されていません！";
//     }
//     if (data.option3.isEmpty) {
//       throw "選択肢 3 が入力されていません！";
//     }
//     if (data.option4.isEmpty) {
//       throw "選択肢 4 が入力されていません！";
//     }
//     if (data.correctOption.isEmpty) {
//       throw "正解 が入力されていません！";
//     }
//     if (data.answerDescription.isEmpty) {
//       throw "解答・説明が入力されていません！";
//     }
//     data.questionId = _timeStamp.toString();
//     await addQuizFsCloud(_quizId, data, _timeStamp);
//     notifyListeners();
//   }
//
//   Future<void> updateQuestionFsCloud(String _quizId, String _questionId) async {
//     await updateQuizFsCloud(_quizId, _questionId, data);
//     notifyListeners();
//   }
//
//   Future<void> deleteQuestionFsCloud(_quizId, _questionId) async {
//     await deleteQuizFsCloud(_quizId, _questionId);
//     notifyListeners();
//   }
// }
