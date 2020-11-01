import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motokosan/take_a_lecture/lecture/play/lecture_class.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String apiKey = "AIzaSyDKpoIvDZTjrjDkWJmpAucV7C0RhiNJVjU";
  final String _baseUrl = "www.googleapis.com";

  Future<Video> fetchVideoSnippet({String videoId}) async {
    Map<String, String> parameters = {
      "part": "snippet",
      "id": videoId,
      "key": apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      "/youtube/v3/videos",
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    // Get videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)["items"][0];
      Video video = Video.fromMapSnippet(data);
      return video;
    } else {
      throw json.decode(response.body)["error"]["message"];
    }
  }

  Future<Video> fetchVideoContentDetails({String videoId}) async {
    Map<String, String> parameters = {
      "part": "contentDetails",
      "id": videoId,
      "key": apiKey,
    };
    Uri uri = Uri.https(
      _baseUrl,
      "/youtube/v3/videos",
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };

    // Get videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)["items"][0];
      Video video = Video.fromMapContentDetails(data);
      return video;
    } else {
      throw json.decode(response.body)["error"]["message"];
    }
  }
}

class VideoDuration {
  // Convert "PT1H15M50S" => "1:15:50"

  String hours;
  String minutes;
  String seconds;

  VideoDuration({this.hours, this.minutes, this.seconds});

  String toHMS(String _data) {
    // 先頭のPTを取り除く
    _data = _data.replaceFirst("PT", "");
    //
    if (_data.contains("H")) {
      List<String> _hours = _data.split("H");
      hours = "${_hours[0]}:";
      _data = _hours[1] ?? "";
    } else {
      hours = "";
    }
    if (_data.contains("M")) {
      List<String> _minutes = _data.split("M");
      minutes = "${_minutes[0]}:";
      _data = _minutes[1] ?? "";
    } else {
      minutes = "00:";
    }
    if (_data.contains("S")) {
      List<String> _seconds = _data.split("S");
      int _splitsInt = int.parse(_seconds[0]);
      seconds = _splitsInt.toString().padLeft(2, "0");
    } else {
      seconds = "00";
    }
    return "$hours$minutes$seconds";
  }
}
