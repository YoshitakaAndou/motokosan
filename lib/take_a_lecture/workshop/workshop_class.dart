class Workshop {
  String workshopId;
  String workshopNo;
  String title;
  String subTitle;
  String information; //Option1より変更
  String subInformation; //Option2より変更
  String option3;
  bool isRelease;
  bool isExam; //追加
  int lectureLength;
  int questionLength; //追加
  int numOfExam; //追加
  int passingScore; //追加
  int updateAt;
  int createAt;
  int deadlineAt;
  String targetId;
  String organizerId;
  String key;

  Workshop({
    this.workshopId = "",
    this.workshopNo = "",
    this.title = "",
    this.subTitle = "",
    this.information = "",
    this.subInformation = "",
    this.option3 = "",
    this.isRelease = false,
    this.isExam = false,
    this.lectureLength = 0,
    this.questionLength = 0,
    this.numOfExam = 0,
    this.passingScore = 0,
    this.updateAt = 0,
    this.createAt = 0,
    this.deadlineAt = 0,
    this.targetId = "",
    this.organizerId = "",
    this.key = "",
  });
}

class WorkshopResult {
  int id;
  String workshopId;
  String isTaken; // "研修済","受講済","未受講",""
  String graduaterId;
  int lectureCount;
  int takenCount;
  int isTakenAt;
  int isSendAt;

  WorkshopResult({
    this.id,
    this.workshopId = "",
    this.isTaken = "",
    this.graduaterId = "",
    this.lectureCount = 0,
    this.takenCount = 0,
    this.isTakenAt = 0,
    this.isSendAt = 0,
  });
  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'workshopId': workshopId,
      'isTaken': isTaken,
      'graduaterId': graduaterId,
      'lectureCount': lectureCount,
      'takenCount': takenCount,
      'isTakenAt': isTakenAt,
      'isSendAt': isSendAt,
    };
  }
}

class WorkshopList {
  Workshop workshop;
  String organizerName;
  String organizerTitle;
  String listNo;
  WorkshopResult workshopResult;

  WorkshopList({
    this.workshop,
    this.organizerName,
    this.organizerTitle,
    this.listNo,
    this.workshopResult,
  });
}
