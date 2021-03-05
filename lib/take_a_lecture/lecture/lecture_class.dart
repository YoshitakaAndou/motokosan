import 'dart:io';

class Lecture {
  String lectureId;
  String lectureNo;
  String title;
  String subTitle;
  String description;
  String videoUrl;
  String thumbnailUrl;
  String videoDuration;
  String allAnswers;
  int passingScore;
  int slideLength;
  int questionLength;
  int updateAt;
  int createAt;
  String targetId;
  String organizerId;
  String workshopId;

  Lecture({
    this.lectureId = "",
    this.lectureNo = "",
    this.title = "",
    this.subTitle = "",
    this.description = "",
    this.videoUrl = "",
    this.thumbnailUrl = "",
    this.videoDuration = "",
    this.allAnswers = "",
    this.passingScore = 0,
    this.slideLength = 0,
    this.questionLength = 0,
    this.updateAt = 0,
    this.createAt = 0,
    this.targetId = "",
    this.organizerId = "",
    this.workshopId = "",
  });
}

class LectureList {
  Lecture lecture;
  LectureResult lectureResult;

  LectureList({
    this.lecture,
    this.lectureResult,
  });
}

class LectureResult {
  int id;
  String lectureId;
  String isTaken; //"受講済","受講中",""
  String isBrowsing; //閲覧済か
  String playBackTime; //再生時間
  int questionCount;
  int correctCount;
  int isTakenAt;

  LectureResult({
    this.id,
    this.lectureId = "",
    this.isTaken = "",
    this.isBrowsing = "",
    this.playBackTime = "",
    this.questionCount = 0,
    this.correctCount = 0,
    this.isTakenAt = 0,
  });
  Map<String, dynamic> toMap() {
    return {
//      'id': id,
      'lectureId': lectureId,
      'isTaken': isTaken,
      'isBrowsing': isBrowsing,
      'playBackTime': playBackTime,
      'questionCount': questionCount,
      'correctCount': correctCount,
      'isTakenAt': isTakenAt,
    };
  }
}

class Video {
  String id;
  String url;
  String title;
  String description;
  String thumbnailUrl;
  String duration;

  Video({
    this.id,
    this.url,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.duration,
  });

  factory Video.fromMapSnippet(Map<String, dynamic> map) {
    return Video(
      id: map["id"],
      title: map["snippet"]["title"],
      description: map["snippet"]["description"],
      thumbnailUrl: map["snippet"]["thumbnails"]["default"]["url"],
      // duration: map["contentDetails"]["duration"],
    );
  }

  factory Video.fromMapContentDetails(Map<String, dynamic> map) {
    return Video(
      // id: map["id"],
      // title: map["snippet"]["title"],
      // description: map["snippet"]["description"],
      // thumbnailUrl: map["snippet"]["thumbnails"]["default"]["url"],
      duration: map["contentDetails"]["duration"],
    );
  }
}

class Slide {
  String slideNo;
  String slideUrl;
  File slideImage;

  Slide({
    this.slideNo = "",
    this.slideUrl = "",
    this.slideImage,
  });
}

class DeletedSlide {
  String slideNo;
  String slideUrl;
  DeletedSlide({this.slideNo, this.slideUrl});
}
