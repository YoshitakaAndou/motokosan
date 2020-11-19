import 'package:motokosan/take_a_lecture/question/question_class.dart';

class ExamList {
  Question question;
  ExamResult examResult;

  ExamList({
    this.question,
    this.examResult,
  });
}

class ExamResult {
  int id;
  String answerResult;
  String flag1;

  ExamResult({
    this.answerResult = "",
    this.flag1 = "",
  });
}
