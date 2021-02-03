import 'package:motokosan/widgets/convert_items.dart';

class CheckDeadlineAt {
  final int deadlineAt;

  CheckDeadlineAt({this.deadlineAt});

  bool check() {
    int _todayInt = ConvertItems.instance.dateToInt(DateTime.now());
    return deadlineAt >= _todayInt;
  }
}
