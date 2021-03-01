import 'package:motokosan/data/user_data/userdata_class.dart';

class Graduater {
  String graduaterId;
  String uid;
  String workshopId;
  int takenAt;
  int sendAt;

  Graduater({
    this.graduaterId = "",
    this.uid = "",
    this.workshopId = "",
    this.takenAt = 0,
    this.sendAt = 0,
  });
}

class GraduaterList {
  Graduater graduater;
  UserData userData;

  GraduaterList({
    this.graduater,
    this.userData,
  });
}
