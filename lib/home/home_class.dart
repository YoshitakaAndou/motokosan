import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/question/question_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';

class HomeData {
  final UserData userData;
  final List<WorkshopResult> workshopResults;
  final List<LectureResult> lectureResults;
  final List<QuestionResult> questionResults;

  HomeData({
    this.userData,
    this.workshopResults,
    this.lectureResults,
    this.questionResults,
  });
}
