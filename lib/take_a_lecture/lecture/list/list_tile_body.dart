import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_firebase.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_play.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import '../../../constants.dart';
import '../../return_argument.dart';
import '../lecture_class.dart';
import '../lecture_model.dart';
import 'bottomsheet_send_items.dart';

class ListTileBody extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  final WorkshopList _workshopList;
  final LectureModel model;
  final int index;
  ListTileBody(this._userData, this._organizer, this._workshopList, this.model,
      this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      // dense: true,
      leading: _leading(context, model, index),
      title: _title(context, model, index),
      subtitle: _subtitle(context, model, index),
      trailing: _trailing(context, model, index),
      onTap: () => _onTap(context, model, index, _userData.userGroup,
          _workshopList.workshop.workshopId),
    );
  }

  Future<List<Slide>> _preparationOfSlide(
      model, _slideLength, _lectureId) async {
    List<Slide> _results = List();
    // スライドが登録されていたら準備をする
    if (_slideLength > 0) {
      _results =
          await FSSlide.instance.fetchDates(_userData.userGroup, _lectureId);
    }
    return _results;
  }

  Widget _leading(BuildContext context, LectureModel model, int index) {
    final _imageUrl = model.lectureLists[index].lecture.thumbnailUrl ?? "";
    if (_imageUrl.isNotEmpty) {
      return Stack(
        children: [
          Container(
            width: 60,
            height: 50,
            color: Colors.black54.withOpacity(0.8),
            child: Image.network(_imageUrl),
          ),
          if (model.lectures[index].videoDuration.isNotEmpty)
            Container(
              width: 60,
              height: 50,
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black54.withOpacity(0.8),
                child: Text(
                  "${model.lectureLists[index].lecture.videoDuration}",
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

  Widget _title(BuildContext context, LectureModel model, int index) {
    return Text(
      "${model.lectureLists[index].lecture.title}",
      style: cTextListM,
      textScaleFactor: 1,
    );
  }

  Widget _subtitle(BuildContext context, LectureModel model, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 25),
      child: Column(
        children: [
          Text(
            "${model.lectureLists[index].lecture.subTitle}",
            style: cTextListSS,
            textAlign: TextAlign.left,
            textScaleFactor: 1,
          ),
          _statusInfo(context, model, index),
        ],
      ),
    );
  }

  Widget _statusInfo(BuildContext context, LectureModel model, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (model.lectureLists[index].lecture.questionLength != 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.greenAccent.withOpacity(0.2),
            child: Text(
                "テスト:${model.lectureLists[index].lecture.questionLength}問",
                style: cTextListSS,
                textScaleFactor: 1),
          ),
        if (model.lectureLists[index].lecture.questionLength == 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey.withOpacity(0.2),
            child: Text("テスト無し", style: cTextUpBarSS, textScaleFactor: 1),
          ),
        if (model.lectureLists[index].lecture.questionLength != 0 &&
            model.lectureLists[index].lecture.allAnswers.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.greenAccent.withOpacity(0.2),
            child: Text("${model.lectureLists[index].lecture.allAnswers}",
                style: cTextListSS, textScaleFactor: 1),
          ),
        if (model.lectureLists[index].lecture.questionLength == 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey.withOpacity(0.2),
            child: Text("特に指定は無し", style: cTextUpBarSS, textScaleFactor: 1),
          ),
      ],
    );
  }

  Widget _trailing(BuildContext context, LectureModel model, int index) {
    // todo
    print("${model.lectureLists[index].lectureResult.isTaken}");
    return model.lectureLists[index].lectureResult.isTaken == "受講済"
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

  Future<void> _onTap(BuildContext context, LectureModel model, int index,
      String _groupName, String _workshopId) async {
    ReturnArgument returnArgument = ReturnArgument();
    returnArgument.isNextQuestion = true;

    while (returnArgument.isNextQuestion) {
      final _slides1 = await _preparationOfSlide(
        model,
        model.lectureLists[index].lecture.slideLength,
        model.lectureLists[index].lecture.lectureId,
      );
      if (model.lectures[index].videoUrl.isNotEmpty) {
        //スマホの向きを一時的に上固定から横も可能にする
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
        ]);
      }
      // Trainingへ 終わったら値を受け取る
      returnArgument = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LecturePlay(
            _userData,
            _organizer,
            _workshopList,
            model.lectureLists[index],
            _slides1,
            model.lectureLists.length - index == 1 ? true : false,
          ),
        ),
      );
      if (returnArgument == null) {
        returnArgument = ReturnArgument();
      }
      if (model.lectureLists[index].lecture.videoUrl.isNotEmpty) {
        //スマホの向きを上のみに戻す
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
      index = index + 1;
      // リストの最後まで来たら終わり
      if (index >= model.lectureLists.length) {
        returnArgument.isNextQuestion = false;
      }
    }
    await model.generateLectureList(_groupName, _workshopId);
    _checkWorkshopIsTaken(model);
    final _sendCheck =
        await WorkshopDatabase.instance.getWorkshopResult(_workshopId);
    if (_sendCheck.length > 0) {
      if (_sendCheck[0].graduaterId.isNotEmpty) {
        return;
      }
    }
    // todo workshopResultの保存
    await _saveWorkshopResult(context, model, 0, "");
    if (model.lectureLists.length == model.takenCount) {
      final _results =
          await WorkshopDatabase.instance.getWorkshopResult(_workshopId);
      if (_results.length > 0) {
        if (_results[0].graduaterId.isEmpty) {
          await _showModalBottomSheetSend(context, model, false);
        }
      }
    }
  }

  _checkWorkshopIsTaken(LectureModel model) {
    if (model.lectureLists.length > model.takenCount) {
      _workshopList.workshopResult.isTaken = "受講中";
    } else {
      _workshopList.workshopResult.isTaken = "受講済";
    }
  }

  Future<void> _saveWorkshopResult(BuildContext context, LectureModel model,
      int _isSendAt, String _graduaterId) async {
    print(
        "_saveWorkshopResult .isTaken: ${_workshopList.workshopResult.isTaken}");
    _workshopList.workshopResult.graduaterId = _graduaterId;
    _workshopList.workshopResult.workshopId = _workshopList.workshop.workshopId;
    _workshopList.workshopResult.lectureCount = model.lectureLists.length;
    _workshopList.workshopResult.takenCount = model.takenCount;
    _workshopList.workshopResult.isTakenAt =
        ConvertItems.instance.dateToInt(DateTime.now());
    _workshopList.workshopResult.isSendAt = _isSendAt;
    await WorkshopDatabase.instance
        .saveValue(_workshopList.workshopResult, true);
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
        return BottomSheetSendItems(
            _userData, _workshopList, model, fromButton);
      },
    );
  }
}
