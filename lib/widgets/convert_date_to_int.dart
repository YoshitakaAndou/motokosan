import 'package:intl/intl.dart';

int convertDateToInt(DateTime _timeStamp) {
  var formatter = DateFormat('yyyyMMdd', "ja_JP");
  var formatted = formatter.format(_timeStamp); // DateからString
  print("Time:$formatted");
  return int.parse(formatted);
}
