import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_class.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_database.dart';
import 'package:motokosan/take_a_lecture/question/play/question_database.dart';
import 'package:motokosan/take_a_lecture/question/play/question_model.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import 'package:motokosan/widgets/guriguri.dart';
import '../../../constants.dart';
import 'question_play.dart';

class QuestionListPage extends StatelessWidget {
  final UserData _userData;
  final LectureList _lectureList;
  final bool _isLast;
  // final WorkshopList _workshopList;

  QuestionListPage(
    this._userData,
    this._lectureList,
    this._isLast,
  );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    model.initProperties();

    Future(() async {
      // model.startLoading();
      await model.fetchQuestion(
          _userData.userGroup, _lectureList.lecture.lectureId);
      await model.generateQuestionList(
          _userData.userGroup, _lectureList.lecture.lectureId);
      _checkClear(context, model, _lectureList);
      // model.stopLoading();
    });

    return Consumer<QuestionModel>(builder: (context, model, child) {
      final Size _size = MediaQuery.of(context).size;
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          leading: _appBarLeadingButton(context, ReturnArgument()),
          actions: [],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: _infoArea(),
            ),
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: model.questionLists.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          dense: true,
                          title: _title(context, model, index),
                          // onTap: () => _onTap(
                          //     context, model, _lectureList, index, false),
                        ),
                      );
                    },
                  ),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      if (!model.isClear) _playButton(context, model),
                      // if (model.isClear) _backButton(context, model),
                      SizedBox(height: 30),
                      if (!model.isClear)
                        _description(context, model, _lectureList),
                      if (model.isClear) _passedMessage(context, model),
                      _score(context, model, _lectureList),
                    ],
                  ),
                  if (model.isStack)
                    Container(
                      width: _size.width,
                      height: _size.height / 4,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(context, model),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      // height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" 確認テスト", style: cTextUpBarLL, textScaleFactor: 1),
            SizedBox(width: 20),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "  ${_lectureList.lecture.title}",
                    style: cTextUpBarM,
                    textScaleFactor: 1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context, QuestionModel model, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "第 ${index + 1} 問",
            style: cTextListL,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ),
        Expanded(
          flex: 1,
          child: model.questionLists[index].questionResult.answerResult == "○"
              ? Icon(FontAwesomeIcons.circle)
              : model.questionLists[index].questionResult.answerResult == "×"
                  ? Icon(FontAwesomeIcons.times)
                  : Icon(FontAwesomeIcons.poo),
        ),
        Expanded(
          flex: 5,
          child: Text(
            "解答日：${model.questionLists[index].questionResult.answerAt == 0 ? "未解答" : model.questionLists[index].questionResult.answerAt}",
            style: cTextListM,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  Widget _playButton(BuildContext context, QuestionModel model) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.userEdit, color: Colors.white),
        label: Text(
          "　問題を解く　",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 20,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: Colors.green,
        splashColor: Colors.white.withOpacity(0.5),
        textColor: Colors.white,
        onPressed: () => _onTap(context, model, _lectureList, 0, true),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context, QuestionModel model) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      notchMargin: 6.0,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(
          side: BorderSide(),
        ),
      ),
      child: Container(
        height: cBottomAppBarH,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _backListButton(context, model),
            if (!_isLast) _nextButton(context, model),
          ],
        ),
      ),
    );
  }

  Widget _description(
      BuildContext context, QuestionModel model, LectureList _lectureList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text("この講義を受講完了するには", style: cTextListM, textScaleFactor: 1),
              Text("${_lectureList.lecture.allAnswers}",
                  style: cTextListMR, textScaleFactor: 1),
              Text("です。", style: cTextListM, textScaleFactor: 1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text("合格点は", style: cTextListM, textScaleFactor: 1),
              Text(
                _lectureList.lecture.passingScore == 0
                    ? "設けていません。"
                    : "　${_lectureList.lecture.passingScore}点です。",
                style: cTextListMR,
                textScaleFactor: 1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _lectureList.lecture.passingScore == 0
                ? "気軽にチャレンジしてください。"
                : "クリア目指して頑張ってください。",
            style: cTextListM,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  Widget _score(
      BuildContext context, QuestionModel model, LectureList lectureList) {
    if (model.questionLists.length > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("現在   ", style: cTextListM, textScaleFactor: 1),
            Row(
              children: [
                Text("${_getScore(context, model, lectureList)}",
                    style: TextStyle(fontSize: 20), textScaleFactor: 1),
                Text(" 点", style: cTextListM, textScaleFactor: 1),
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Future<void> _onTap(BuildContext context, QuestionModel model, _lectureList,
      int index, bool fromButton) async {
    ReturnArgument lectureArgument = ReturnArgument();
    lectureArgument.isNextQuestion = true;

    while (lectureArgument.isNextQuestion) {
      print("index:$index");
      lectureArgument = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionPlay(
            _userData,
            model.questions[index],
            _lectureList,
            model.questions.length - index,
            false,
          ),
        ),
      );
      // todo 必須
      if (lectureArgument == null) {
        lectureArgument = ReturnArgument();
      }
      index = index + 1;
      // todo リストの最後まで来たら終わり
      if (index == model.questions.length) {
        lectureArgument.isNextQuestion = false;
      }
    }
    // todo 問題解答が終わったら
    await model.generateQuestionList(
        _userData.userGroup, _lectureList.lecture.lectureId);
    await QuestionDatabase.instance
        .deleteFlag1(_lectureList.lecture.lectureId, "");
    // scoreCheck
    _checkClear(context, model, _lectureList);
    if (model.isClear) {
      // todo lectureResultの保存
      await _saveLectureResult(context, model);
    }
    if (fromButton) {
      _checkFire(context, model, _lectureList);
    }
  }

  Future<void> _saveLectureResult(
      BuildContext context, QuestionModel model) async {
    _lectureList.lectureResult.lectureId = _lectureList.lecture.lectureId;
    _lectureList.lectureResult.isTaken = "受講済";
    _lectureList.lectureResult.questionCount = model.questionLists.length;
    _lectureList.lectureResult.correctCount = model.correctCount;
    _lectureList.lectureResult.isTakenAt =
        ConvertItems.instance.dateToInt(DateTime.now());
    await LectureDatabase.instance.saveValue(_lectureList.lectureResult, false);
  }

  void _checkClear(
      BuildContext context, QuestionModel model, LectureList lectureList) {
    // AllAnswersのチェック
    model.setAllAnswersClear(model.questionLists
        .every((element) => element.questionResult.answerAt != 0));
    print("_checkClear.AllAnswer:${model.isAllAnswersClear}");
    // ScoreClearのチェック
    model.setScoreClear((_getScore(context, model, _lectureList) >
                _lectureList.lecture.passingScore ||
            _getScore(context, model, _lectureList) == 100)
        ? true
        : false);
    print("_checkClear.ScoreClear:${model.isScoreClear}");
    // isClear のチェック
    if (_lectureList.lecture.allAnswers == "全問解答が必要") {
      if (_lectureList.lecture.passingScore == 0) {
        model.setClear(model.isAllAnswersClear);
      } else {
        model.setClear(
            model.isScoreClear && model.isAllAnswersClear ? true : false);
      }
    } else {
      model.setClear(true);
    }
    print("_checkClear.Clear:${model.isClear}");
  }

  void _checkFire(
      BuildContext context, QuestionModel model, LectureList lectureList) {
    // 全問解答（問題を解くボタン経由）して100点の時に花火が出る
    if (_getScore(context, model, lectureList) == 100) {
      FlareActors.instance.firework(context);
    }
  }

  int _getScore(
      BuildContext context, QuestionModel model, LectureList lectureList) {
    int result = 0;
    if (model.questionLists.length > 0) {
      double _result = (model.correctCount / model.questionLists.length) * 100;
      result = _result.toInt();
    }
    return result;
  }

  Widget _backListButton(BuildContext context, QuestionModel model) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.undo, color: Colors.green),
              label: Text(
                model.isClear ? "一覧に戻る" : "やめて戻る",
                style: cTextListM,
                textScaleFactor: 1,
              ),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () async {
                model.setIsStack(true);
                // todo _lectureListを返す
                Navigator.of(context).pop();
                Navigator.of(context).pop(
                  ReturnArgument(
                    lectureList: _lectureList,
                    isNextQuestion: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _nextButton(BuildContext context, QuestionModel model) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.handPointRight, color: Colors.green),
              label: Text(
                model.isClear ? "次の講義へ" : "やめて次へ",
                style: cTextListM,
                textScaleFactor: 1,
              ),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () async {
                // todo _lectureListを返す
                model.setIsStack(true);
                Navigator.of(context).pop();
                Navigator.of(context).pop(
                  ReturnArgument(
                    lectureList: _lectureList,
                    isNextQuestion: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _passedMessage(BuildContext context, QuestionModel model) {
    final bool _isZeroScore = model.correctCount == 0 ? true : false;
    return Container(
      child: Text(
        _isZeroScore ? "クリアーしました！" : "合格です！",
        style: TextStyle(fontSize: 30, color: Colors.red),
        textScaleFactor: 1,
      ),
    );
  }

  Widget _appBarLeadingButton(
      BuildContext context, ReturnArgument returnArgument) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.undo),
      onPressed: () {
        final ReturnArgument returnArgument = ReturnArgument(
          lectureList: _lectureList,
          isNextQuestion: false,
        );
        Navigator.of(context).pop(returnArgument);
        Navigator.of(context).pop(returnArgument);
      },
    );
  }
}
