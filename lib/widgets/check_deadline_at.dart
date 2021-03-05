import 'package:motokosan/widgets/convert_datetime.dart';

class CheckDeadlineAt {
  final int deadlineAt;

  CheckDeadlineAt({this.deadlineAt});

  bool check() {
    int _todayInt = ConvertDateTime.instance.dateToInt(DateTime.now());
    return deadlineAt >= _todayInt;
  }
}
