// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../widgets/convert_date_to_int.dart';
// import 'quiz_model.dart';
//
// Future<List<Question>> fetchQuizFsCloud(String _quizId) async {
//   final _docs = await Firestore.instance.collection(_quizId).getDocuments();
//   final _questions = _docs.documents
//       .map((doc) => Question(
//             questionId: doc["questionId"],
//             category: doc["category"],
//             question: doc["question"],
//             option1: doc["option1"],
//             option2: doc["option2"],
//             option3: doc["option3"],
//             option4: doc["option4"],
//             correctOption: doc["correctOption"],
//             answerDescription: doc["answerDescription"],
//             updateAt: doc["upDate"],
//             createAt: doc["createAt"],
//           ))
//       .toList();
//   return _questions;
// }
//
// Future<void> addQuizFsCloud(_quizId, _data, _timeStamp) async {
//   final _questionId = _timeStamp.toString();
//   await Firestore.instance.collection(_quizId).document(_questionId).setData({
//     "questionId": _questionId,
//     "category": _data.organizer,
//     "question": _data.question,
//     "option1": _data.option1,
//     "option2": _data.option2,
//     "option3": _data.option3,
//     "option4": _data.option4,
//     "correctOption": _data.correctOption,
//     "answerDescription": _data.answerDescription,
//     "update": convertDateToInt(_timeStamp),
//     "createAt": convertDateToInt(_timeStamp),
//   }).catchError((onError) {
//     print(onError.toString());
//   });
// }
//
// Future<void> updateQuizFsCloud(_quizId, _questionId, _data) async {
//   await Firestore.instance.collection(_quizId).document(_questionId).setData({
//     "questionId": _questionId,
//     "category": _data.organizer,
//     "question": _data.question,
//     "option1": _data.option1,
//     "option2": _data.option2,
//     "option3": _data.option3,
//     "option4": _data.option4,
//     "correctOption": _data.correctOption,
//     "answerDescription": _data.answerDescription,
//     "update": convertDateToInt(DateTime.now()),
//     "createAt": _data.createAt,
//   }).catchError((onError) {
//     print(onError.toString());
//   });
// }
//
// Future<void> deleteQuizFsCloud(String _quizId, String _questionId) async {
//   await Firestore.instance.collection(_quizId).document(_questionId).delete();
// }
