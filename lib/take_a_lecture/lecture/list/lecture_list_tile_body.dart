import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_firebase.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_play.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/widgets/check_deadline_at.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:motokosan/widgets/return_argument.dart';
import 'lecture_list_bottomsheet_send_items.dart';

class LectureListTileBody extends StatelessWidget {
  final UserData userData;
  final WorkshopList workshopList;
  final LectureModel model;
  final int index;
  final String routeName;

  LectureListTileBody(
    this.userData,
    this.workshopList,
    this.model,
    this.index,
    this.routeName,
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      // dense: true,
      leading: _leading(context, model, index),
      title: _title(context, model, index),
      subtitle: _subtitle(context, model, index),
      trailing: _trailing(context, model, index),
      onTap: () => _onTap(context, model, index, userData.userGroup,
          workshopList.workshop.workshopId),
    );
  }

  Future<List<Slide>> _preparationOfSlide(
      model, _slideLength, _lectureId) async {
    List<Slide> _results = List();
    // スライドが登録されていたら準備をする
    if (_slideLength > 0) {
      _results =
          await FSSlide.instance.fetchDates(userData.userGroup, _lectureId);
    }
    return _results;
  }

  // 動画のサムネイル
  Widget _leading(BuildContext context, LectureModel model, int _index) {
    final _imageUrl = model.lectureLists[_index].lecture.thumbnailUrl ?? "";
    if (_imageUrl.isNotEmpty) {
      return Stack(
        children: [
          Container(
            width: 60,
            height: 50,
            color: Colors.black54.withOpacity(0.8),
            child: Image.network(_imageUrl),
          ),
          if (model.lectures[_index].videoDuration.isNotEmpty)
            Container(
              width: 60,
              height: 50,
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black54.withOpacity(0.8),
                child: Text(
                  "${model.lectureLists[_index].lecture.videoDuration}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                ),
              ),
            ),
        ],
      );
    } else {
      return Container(
        width: 60,
        height: 50,
        child: Image.asset(
          "assets/images/noImage.png",
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _title(BuildContext context, LectureModel model, int _index) {
    return Text(
      "${model.lectureLists[_index].lecture.title}",
      style: cTextListM,
      textScaleFactor: 1,
    );
  }

  Widget _subtitle(BuildContext context, LectureModel model, int _index) {
    return Padding(
      padding: EdgeInsets.only(left: 25),
      child: Column(
        children: [
          Text(
            "${model.lectureLists[_index].lecture.subTitle}",
            style: cTextListSS,
            textAlign: TextAlign.left,
            textScaleFactor: 1,
          ),
          _statusInfo(context, model, _index),
        ],
      ),
    );
  }

  Widget _statusInfo(BuildContext context, LectureModel model, int _index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (model.lectureLists[_index].lecture.questionLength != 0 &&
            model.lectureLists[_index].lecture.allAnswers == "全問解答が必要")
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.greenAccent.withOpacity(0.2),
            child: Text(
                "確認テスト:${model.lectureLists[_index].lecture.questionLength}問",
                style: cTextListSS,
                textScaleFactor: 1),
          ),
        // if (model.lectureLists[_index].lecture.questionLength == 0)
        //   Container(
        //     padding: EdgeInsets.symmetric(horizontal: 5),
        //     color: Colors.grey.withOpacity(0.2),
        //     child: Text("テスト無し", style: cTextUpBarSS, textScaleFactor: 1),
        //   ),
        // if (model.lectureLists[_index].lecture.questionLength != 0 &&
        //     model.lectureLists[_index].lecture.allAnswers.isNotEmpty)
        //   Container(
        //     padding: EdgeInsets.symmetric(horizontal: 5),
        //     color: Colors.greenAccent.withOpacity(0.2),
        //     child: Text("${model.lectureLists[_index].lecture.allAnswers}",
        //         style: cTextListSS, textScaleFactor: 1),
        //   ),
        // if (model.lectureLists[_index].lecture.questionLength == 0)
        //   Container(
        //     padding: EdgeInsets.symmetric(horizontal: 5),
        //     color: Colors.grey.withOpacity(0.2),
        //     child: Text("特に指定は無し", style: cTextUpBarSS, textScaleFactor: 1),
        //   ),
      ],
    );
  }

  Widget _trailing(BuildContext context, LectureModel model, int _index) {
    return model.lectureLists[_index].lectureResult.isTaken == "受講済"
        ? Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text("済", style: cTextButtonL, textScaleFactor: 1),
            ),
          )
        : Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text("未", style: cTextButtonL, textScaleFactor: 1),
            ),
          );
  }

  Future<void> _onTap(BuildContext context, LectureModel model, int _index,
      String _groupName, String _workshopId) async {
    ReturnArgument returnArgument = ReturnArgument();
    returnArgument.isNextQuestion = true;

    while (returnArgument.isNextQuestion) {
      final _slides1 = await _preparationOfSlide(
        model,
        model.lectureLists[_index].lecture.slideLength,
        model.lectureLists[_index].lecture.lectureId,
      );
      if (model.lectures[_index].videoUrl.isNotEmpty) {
        //スマホの向きを一時的に上固定から横も可能にする
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
        ]);
      }
      // LecturePlayへ （終わったら値を受け取る）
      returnArgument = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LecturePlay(
            userData,
            workshopList,
            model.lectureLists[_index],
            _slides1,
            model.lectureLists.length - _index == 1 ? true : false,
            routeName,
          ),
        ),
      );
      if (returnArgument == null) {
        returnArgument = ReturnArgument();
      }
      if (model.lectureLists[_index].lecture.videoUrl.isNotEmpty) {
        //スマホの向きを上のみに戻す
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
      _index = _index + 1;
      // リストの最後まで来たら終わり
      if (_index >= model.lectureLists.length) {
        returnArgument.isNextQuestion = false;
      }
    }
    // 表示用のデータを再構築
    await model.generateLectureList(_groupName, _workshopId);
    // isTakenのチェック（研修済・受講済）
    _checkWorkshopIsTaken(model);
    // 本体のWorkshopResultを読み出す
    final List<WorkshopResult> _sendCheck =
        await WorkshopDatabase.instance.getWorkshopResult(_workshopId);
    // FBへ転送済みだったら早期return
    if (_sendCheck.length > 0 && _sendCheck[0].graduaterId.isNotEmpty) {
      return;
    }
    // workshopResultの保存
    await _saveWorkshopResult(context, model, 0, "");
    if (model.lectureLists.length == model.takenCount) {
      final List<WorkshopResult> _results =
          await WorkshopDatabase.instance.getWorkshopResult(_workshopId);
      final CheckDeadlineAt _checkDeadlineAt =
          CheckDeadlineAt(deadlineAt: workshopList.workshop.deadlineAt);
      // 修了書を送るボトムシート
      if (_results[0].isTaken == "研修済" &&
          _results[0].graduaterId.isEmpty &&
          _checkDeadlineAt.check()) {
        await _showModalBottomSheetSend(context, model, false);
      }
    }
  }

  _checkWorkshopIsTaken(LectureModel model) {
    if (workshopList.workshopResult.isTaken != "研修済") {
      if (model.lectureLists.length > model.takenCount) {
        workshopList.workshopResult.isTaken = "受講中";
      } else {
        if (workshopList.workshop.isExam) {
          //修了試験があったら
          workshopList.workshopResult.isTaken = "受講済";
        } else {
          workshopList.workshopResult.isTaken = "研修済";
        }
      }
    }
  }

  Future<void> _saveWorkshopResult(
    BuildContext context,
    LectureModel model,
    int _isSendAt,
    String _graduaterId,
  ) async {
    final bool _isExam = workshopList.workshop.isExam;
    workshopList.workshopResult.graduaterId = _isExam ? "" : _graduaterId;
    workshopList.workshopResult.workshopId = workshopList.workshop.workshopId;
    workshopList.workshopResult.lectureCount = model.lectureLists.length;
    workshopList.workshopResult.takenCount = model.takenCount;
    workshopList.workshopResult.isTakenAt =
        ConvertDateTime.instance.dateToInt(DateTime.now());
    workshopList.workshopResult.isSendAt = _isSendAt;
    await WorkshopDatabase.instance
        .saveValue(workshopList.workshopResult, true);
  }

  Future<Widget> _showModalBottomSheetSend(
      BuildContext context, LectureModel model, bool fromButton) async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: false,
      elevation: 15,
      // enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return LectureListBottomSheetSendItems(
            userData, workshopList, model, fromButton);
      },
    );
  }
}
