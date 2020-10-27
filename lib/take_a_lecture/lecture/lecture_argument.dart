import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_model.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';

class LectureArgument {
  String groupName;
  Organizer organizer;
  WorkshopList workshopList;
  LectureList lectureList;
  List<Slide> slides;
  bool isNextQuestion;

  LectureArgument({
    this.groupName,
    this.organizer,
    this.workshopList,
    this.lectureList,
    this.slides,
    this.isNextQuestion,
  });
}
