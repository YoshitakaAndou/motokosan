import 'package:intl/intl.dart';

class ConvertDateTime {
  static final ConvertDateTime instance = ConvertDateTime();

  int dateToInt(DateTime _timeStamp) {
    // today is DateTime.now();
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

  int stringTimeToInt(String data) {
    // 0:59:00 => 3540sec
    print("-------------stringTimeToInt :$data");
    if (data.isNotEmpty) {
      final hou = int.parse(data.substring(0, 1));
      final min = int.parse(data.substring(2, 4));
      final sec = int.parse(data.substring(5, 7));
      final res = hou * 3600 + min * 60 + sec;
      print("再生開始時刻：$res秒");
      return res;
    } else {
      print("空でした！");
      return 0;
    }
  }
}
