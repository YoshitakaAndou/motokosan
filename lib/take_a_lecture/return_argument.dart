import 'lecture/lecture_class.dart';
import 'organizer/organizer_class.dart';
import 'workshop/workshop_class.dart';

class ReturnArgument {
  String groupName;
  Organizer organizer;
  WorkshopList workshopList;
  LectureList lectureList;
  List<Slide> slides;
  bool isNextQuestion;

  ReturnArgument({
    this.groupName = "",
    this.organizer,
    this.workshopList,
    this.lectureList,
    this.slides,
    this.isNextQuestion = false,
  });
}
