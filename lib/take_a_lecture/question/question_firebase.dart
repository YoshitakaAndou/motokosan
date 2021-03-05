import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/widgets/convert_datetime.dart';

import 'question_class.dart';

class FSQuestion {
  static final FSQuestion instance = FSQuestion();

  Future<List<Question>> fetchDates(
    String _groupName,
    String _lectureId,
  ) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Question")
        .where("lectureId", isEqualTo: _lectureId)
        .get();
    final List<Question> _results = _docs.docs
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

  Future<void> setData(
    bool _isAdd,
    String _groupName,
    Question _data,
    DateTime _timeStamp,
  ) async {
    final _questionId = _isAdd ? _timeStamp.toString() : _data.questionId;
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Question")
        .doc(_questionId)
        .set({
      "questionId": _questionId,
      "questionNo": _data.questionNo,
      "question": _data.question,
      "choices1": _data.choices1,
      "choices2": _data.choices2,
      "choices3": _data.choices3,
      "choices4": _data.choices4,
      "correctChoices": _data.correctChoices,
      "answerDescription": _data.answerDescription,
      "upDate": ConvertDateTime.instance.dateToInt(_timeStamp),
      "createAt":
          _isAdd ? ConvertDateTime.instance.dateToInt(_timeStamp) : _data.createAt,
      "answeredAt": _isAdd
          ? ConvertDateTime.instance.dateToInt(_timeStamp)
          : _data.answeredAt,
      "answered": _data.answered,
      "organizerId": _data.organizerId,
      "workshopId": _data.workshopId,
      "lectureId": _data.lectureId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteData(
    String _groupName,
    String _questionId,
  ) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Question")
        .doc(_questionId)
        .delete();
  }

  Future<int> getQuestionLength(_groupName, _workshopId) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Question")
        .where("workshopId", isEqualTo: _workshopId)
        .get();
    final int _result = _docs.docs.length;
    // todo print
    print("QuestionLength:$_result問");

    return _result;
  }
}
