import 'package:intl/intl.dart';

class ConvertItems {
  static final ConvertItems instance = ConvertItems();

  int dateToInt(DateTime _timeStamp) {
    var formatter = DateFormat('yyyyMMdd', "ja_JP");
    var formatted = formatter.format(_timeStamp); // DateからString
    return int.parse(formatted);
  }
}
