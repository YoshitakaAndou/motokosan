import '../take_a_lecture/lecture/lecture_class.dart';
import '../take_a_lecture/organizer/organizer_class.dart';
import '../take_a_lecture/workshop/workshop_class.dart';

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
