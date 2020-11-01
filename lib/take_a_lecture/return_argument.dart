
import 'lecture/play/lecture_class.dart';
import 'organizer/play/organizer_class.dart';
import 'workshop/play/workshop_class.dart';

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
