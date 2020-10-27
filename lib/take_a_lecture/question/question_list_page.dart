import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_argument.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/question/question_database.dart';
import 'package:motokosan/take_a_lecture/question/question_model.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:provider/provider.dart';
import 'package:motokosan/widgets/guriguri.dart';
import '../../constants.dart';
import 'question_play.dart';

class QuestionListPage extends StatelessWidget {
  final String groupName;
  final LectureList _lectureList;

  QuestionListPage(this.groupName, this._lectureList);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchQuestion(groupName, _lectureList.lecture.lectureId);
      await model.generateQuestionList(
          groupName, _lectureList.lecture.lectureId);
      if (_getScore(context, model, _lectureList) >
          _lectureList.lecture.passingScore) {
        model.setClear();
      } else {
        model.resetClear();
      }
      model.stopLoading();
    });

    return Consumer<QuestionModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          leading: GoBack.instance.goBackWithLecture(
            context: context,
            icon: Icon(FontAwesomeIcons.chevronLeft),
            lectureArgument: LectureArgument(isNextQuestion: true),
            num: 2,
          ),
          actions: [],
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _infoArea()),
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: model.questionLists.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 10,
                        child: ListTile(
                          dense: true,
                          title: _title(context, model, index),
                          onTap: () =>
                              _onTap(context, model, _lectureList, index),
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
              child: Column(
                children: [
                  SizedBox(height: 10),
                  if (!model.isClear) _playButton(context, model),
                  if (model.isClear) _backButton(context, model),
                  SizedBox(height: 30),
                  if (!model.isClear)
                    _description(context, model, _lectureList),
                  _score(context, model, _lectureList),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(context),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("講義：", style: cTextUpBarS, textScaleFactor: 1),
                Text("  ${_lectureList.lecture.title}",
                    style: cTextUpBarM, textScaleFactor: 1),
              ],
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

  // リストをタップ
  Future<void> _onTap(BuildContext context, QuestionModel model, _lectureList,
      int index) async {
    LectureArgument lectureArgument = LectureArgument();
    lectureArgument.isNextQuestion = true;

    while (lectureArgument.isNextQuestion) {
      print("index:$index");
      lectureArgument = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionPlay(
            groupName,
            model.questions[index],
            _lectureList,
            model.questions.length - index,
            false,
          ),
        ),
      );
      // scoreCheck
      if (!model.isClear) {
        _checkClear(context, model, _lectureList);
      }
      index = index + 1;
      // リストの最後まで来たら終わり
      if (index == model.questions.length) {
        lectureArgument.isNextQuestion = false;
      }
    }
    await model.generateQuestionList(groupName, _lectureList.lecture.lectureId);
    await QuestionDatabase.instance
        .deleteFlag1(_lectureList.lecture.lectureId, "");
    // todo lectureDBに保存
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
        elevation: 10,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: Colors.green,
        splashColor: Colors.white.withOpacity(0.5),
        textColor: Colors.white,
        onPressed: () => _onTap(context, model, _lectureList, 0),
      ),
    );
  }

  Widget _backButton(BuildContext context, QuestionModel model) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.undo, color: Colors.white),
        label: Text(
          "　戻　る　",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop(LectureArgument(isNextQuestion: false));
        },
        elevation: 10,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        color: Colors.green,
        splashColor: Colors.white.withOpacity(0.5),
        textColor: Colors.white,
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
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
        padding: EdgeInsets.all(10),
        child: Text(
          "",
          style: cTextUpBarL,
          textScaleFactor: 1,
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

  void _checkClear(BuildContext context, QuestionModel model,
      LectureList lectureList) async {
    if (_getScore(context, model, lectureList) >
        lectureList.lecture.passingScore) {
      await FlareActors.instance.firework(context);
      model.setClear();
    }
  }

  int _getScore(
      BuildContext context, QuestionModel model, LectureList lectureList) {
    if (model.questionLists.length > 0) {
      double result = (model.correctCount / model.questionLists.length) * 100;
      return result.toInt();
    } else {
      return 0;
    }
  }
}
