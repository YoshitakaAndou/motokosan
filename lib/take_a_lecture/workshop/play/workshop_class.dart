class Workshop {
  String workshopId;
  String workshopNo;
  String title;
  String subTitle;
  String option1;
  String option2;
  String option3;
  bool isRelease;
  int lectureLength;
  int updateAt;
  int createAt;
  String targetId;
  String organizerId;
  String key;

  Workshop({
    this.workshopId = "",
    this.workshopNo = "",
    this.title = "",
    this.subTitle = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.isRelease = false,
    this.lectureLength = 0,
    this.updateAt = 0,
    this.createAt = 0,
    this.targetId = "",
    this.organizerId = "",
    this.key = "",
  });
}

class WorkshopResult {
  int id;
  String workshopId;
  String isTaken;
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
  String listNo;
  WorkshopResult workshopResult;

  WorkshopList({
    this.workshop,
    this.organizerName,
    this.listNo,
    this.workshopResult,
  });
}
