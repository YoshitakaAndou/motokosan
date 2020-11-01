
class Target {
  String targetId;
  String targetNo;
  String title;
  String subTitle;
  String option1;
  String option2;
  String option3;
  int updateAt;
  int createAt;
  String key;

  Target({
    this.targetId = "",
    this.targetNo = "",
    this.title = "",
    this.subTitle = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.key = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'targetId': targetId,
      'targetNo': targetNo,
      'title': title,
      'subTitle': subTitle,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'updateAt': updateAt,
      'createAt': createAt,
    };
  }
}