import 'package:intl/intl.dart';

class ConvertItems {
  static final ConvertItems instance = ConvertItems();

  int dateToInt(DateTime _timeStamp) {
    var formatter = DateFormat('yyyyMMdd', "ja_JP");
    var formatted = formatter.format(_timeStamp); // DateからString
    return int.parse(formatted);
  }

  String intToString(int _atData) {
    if (_atData != 0) {
      final _stringData = _atData.toString();
      final _year = _stringData.substring(0, 4);
      final _month = _stringData.substring(4, 6);
      final _day = _stringData.substring(6, 8);
      return "$_year.$_month.$_day";
    } else {
      return "";
    }
  }
}
