import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/exam/exam_model.dart';
import 'package:motokosan/take_a_lecture/exam/play/exam_play.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/flare_actors.dart';

import '../../../constants.dart';

class ExamListBottomSheetInfoItems extends StatelessWidget {
  final ExamModel model;
  final UserData _userData;
  final WorkshopList _workshopList;
  ExamListBottomSheetInfoItems(this.model, this._userData, this._workshopList);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bottomSheetTitle(context, model, _size),
        _bottomSheetText(context, _workshopList, _size),
        _bottomSheetButton(context, model, _size),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _bottomSheetTitle(BuildContext context, ExamModel model, Size _size) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _bottomSheetTitleLetter(),
          _closedButton(context, model, _size),
        ],
      ),
    );
  }

  Widget _bottomSheetTitleLetter() {
    return Row(
      children: [
        SizedBox(width: 30),
        Icon(FontAwesomeIcons.userGraduate, size: 15, color: Colors.white),
        Text(
          " いよいよ ",
          style: cTextUpBarS,
          textScaleFactor: 1,
        ),
        Text(
          "修了試験",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
        Text(
          "  です！",
          style: cTextUpBarS,
          textScaleFactor: 1,
        ),
      ],
    );
  }

  Widget _bottomSheetText(
      BuildContext context, WorkshopList _workshopList, Size _size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "　この研修会を修了するには、修了試験の合格が必要です。",
                    style: cTextListM,
                    textScaleFactor: 1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "全問題：${_workshopList.workshop.numOfExam}問"
                    "\n得　点：${_workshopList.workshop.passingScore}点以上",
                    style: cTextListM,
                    textScaleFactor: 1,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "合格めざして頑張ってください！",
                    style: cTextListM,
                    textScaleFactor: 1,
                    maxLines: 11,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Image.asset(
                "assets/images/guide2.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetButton(BuildContext context, ExamModel model, Size _size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _startButton(context, model, _size),
          ],
        ),
      ],
    );
  }

  Widget _startButton(BuildContext context, ExamModel model, Size _size) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: _size.width - 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.userGraduate, color: Colors.white),
              label: Text(
                "スタート",
                style: cTextUpBarLL,
                textScaleFactor: 1,
              ),
              color: Colors.green[800],
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              onPressed: () async {
                // 修了試験へ

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamPlay(
                      _userData,
                      model.examLists,
                      _workshopList,
                      0,
                      false,
                    ),
                    fullscreenDialog: true,
                  ),
                );
                Navigator.of(context).pop();
                _checkClear(context, model, _workshopList);
                // todo WorkshopResultの保存
                if (model.isClear) {
                  await _saveWorkshopResult();
                }
                if (model.isClear) {
                  await FlareActors.instance.firework(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _closedButton(BuildContext context, ExamModel model, Size _size) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.times, color: Colors.green),
              label: Text(
                "やめて戻る",
                style: cTextListM,
                textScaleFactor: 1,
              ),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _checkClear(
      BuildContext context, ExamModel model, WorkshopList _workshopList) {
    // AllAnswersClearのチェック
    // model.setAllAnswersClear(model.examLists
    //     .every((element) => element.examResult.answerResult == "○"));
    // AllAnswersのチェック
    final bool _result =
        model.examLists.any((element) => element.examResult.answerResult == "");
    model.setAllAnswers(!_result);
    // ScoreClearのチェック
    model.setScoreClear((_getScore(context, model, _workshopList) >=
                _workshopList.workshop.passingScore ||
            _getScore(context, model, _workshopList) == 100)
        ? true
        : false);
    // isClear のチェック
    if (_workshopList.workshop.isExam) {
      if (_workshopList.workshop.passingScore == 0) {
        model.setClear(model.isAllAnswers);
      } else {
        model.setClear(model.isScoreClear && model.isAllAnswers ? true : false);
      }
    } else {
      model.setClear(true);
    }
  }

  int _getScore(
      BuildContext context, ExamModel model, WorkshopList _workshopList) {
    int result = 0;
    if (model.examLists.length > 0) {
      double _result = (model.correctCount / model.examLists.length) * 100;
      result = _result.toInt();
    }
    return result;
  }

  Future<void> _saveWorkshopResult() async {
    _workshopList.workshopResult.isTaken = "研修済";
    _workshopList.workshopResult.isTakenAt =
        ConvertItems.instance.dateToInt(DateTime.now());
    await WorkshopDatabase.instance
        .saveValue(_workshopList.workshopResult, true);
  }
}
