import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/question/play/question_list_page.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';

import '../../../constants.dart';
import '../../return_argument.dart';
import '../lecture_class.dart';
import '../lecture_database.dart';

class BottomSheetPlayItems extends StatelessWidget {
  final UserData _userData;
  final LectureList _lectureList;
  final bool _isLast;
  final LectureResult _lectureResult;

  BottomSheetPlayItems(
    this._userData,
    this._lectureList,
    this._isLast,
    this._lectureResult,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _bottomSheetTitle(),
        SizedBox(height: 10),
        if (_lectureList.lecture.questionLength != 0 &&
            _lectureList.lectureResult.isTakenAt == 0)
          _bottomSheetTest(context, _lectureResult),
        if (!_isLast) _bottomSheetNext(context),
        _bottomSheetReturn(context),
        SizedBox(
          height: MediaQuery.of(context).size.height / 15,
        )
      ],
    );
  }

  Widget _bottomSheetTitle() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          "動画の再生が終了しました",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget _bottomSheetNext(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10),
          color: cBSButton,
        ),
        child: ListTile(
          leading: Icon(FontAwesomeIcons.youtube),
          title: Text('次を見る', style: cTextListL, textScaleFactor: 1),
          onTap: () async {
            if (_lectureList.lecture.questionLength == 0) {
              await _saveLectureResult(context);
            }
            Navigator.of(context).pop();
            Navigator.of(context).pop(ReturnArgument(isNextQuestion: true));
          },
        ),
      ),
    );
  }

  Widget _bottomSheetReturn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10),
          color: cBSButton,
        ),
        child: ListTile(
          leading: Icon(FontAwesomeIcons.undo),
          title: Text('一覧へ戻る', style: cTextListL, textScaleFactor: 1),
          onTap: () async {
            if (_lectureList.lecture.questionLength == 0) {
              await _saveLectureResult(context);
            }
            Navigator.of(context).pop();
            Navigator.of(context).pop(ReturnArgument(isNextQuestion: false));
          },
        ),
      ),
    );
  }

  Widget _bottomSheetTest(BuildContext context, LectureResult lectureResult) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10),
          color: cBSButton,
        ),
        child: ListTile(
          leading: Icon(FontAwesomeIcons.school),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_lectureList.lecture.allAnswers == "全問解答が必要")
                Text('確認テストへ進む', style: cTextListL, textScaleFactor: 1),
              if (_lectureList.lecture.allAnswers != "全問解答が必要")
                Text('確認テストを解いてみる', style: cTextListL, textScaleFactor: 1),
              if (_lectureList.lecture.allAnswers == "全問解答が必要")
                Text(
                    "受講完了には確認テスト(${_lectureList.lecture.questionLength}問)の全問解答が必要です。",
                    style: cTextListSR,
                    textScaleFactor: 1),
              if (_lectureList.lecture.allAnswers == "全問解答が必要" &&
                  _lectureList.lecture.passingScore == 0)
                Text("合格点は設けておりません。", style: cTextListSR, textScaleFactor: 1),
              if (_lectureList.lecture.allAnswers == "全問解答が必要" &&
                  _lectureList.lecture.passingScore != 0)
                Text("${_lectureList.lecture.passingScore}点以上が合格です。",
                    style: cTextListSR, textScaleFactor: 1),
            ],
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuestionListPage(
                        _userData,
                        _lectureList,
                        _isLast,
                      ),
                  fullscreenDialog: true),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveLectureResult(BuildContext context) async {
    _lectureList.lectureResult.lectureId = _lectureList.lecture.lectureId;
    _lectureList.lectureResult.isTaken = "受講済";
    _lectureList.lectureResult.questionCount = 0;
    _lectureList.lectureResult.correctCount = 0;
    _lectureList.lectureResult.isTakenAt =
        ConvertItems.instance.dateToInt(DateTime.now());
    await LectureDatabase.instance.saveValue(_lectureList.lectureResult, false);
  }
}
