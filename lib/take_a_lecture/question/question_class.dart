
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
  String lectureId;
  String flag1;

  QuestionResult({
    this.id,
    this.questionId = "",
    this.answerResult = "",
    this.answerAt = 0,
    this.lectureId = "",
    this.flag1 = "",
  });
  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'questionId': questionId,
      'answerResult': answerResult,
      'answerAt': answerAt,
      'lectureId': lectureId,
      'flag1': flag1,
    };
  }
}

class QuestionResultBody {
  String questionId;
  bool isExists;

  QuestionResultBody({
    this.questionId = "",
    this.isExists = false,
  });
}
