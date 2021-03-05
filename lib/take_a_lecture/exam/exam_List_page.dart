import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:motokosan/widgets/guriguri.dart';
import '../../constants.dart';
import 'exam_model.dart';
import 'exam_list_bottomsheet_info_items.dart';
import 'exam_play.dart';

class ExamListPage extends StatelessWidget {
  final UserData userData;
  final WorkshopList workshopList;

  ExamListPage(
    this.userData,
    this.workshopList,
  );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ExamModel>(context, listen: false);
    model.initProperties();
    model.isShowOk = false;

    Future(
      () async {
        await model.generateExamList(userData.userGroup,
            workshopList.workshop.workshopId, workshopList.workshop.numOfExam);
        await _showModalBottomSheetInfo(context, model, userData, workshopList);

        model.setShowOk(true);
      },
    );

    return Consumer<ExamModel>(builder: (context, model, child) {
      final Size _size = MediaQuery.of(context).size;
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: BarTitle.instance.barTitle(context),
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
                    itemCount: model.examLists.length,
                    itemBuilder: (context, int index) {
                      return Card(
                        key: Key(model.examLists[index].question.questionId),
                        shape: cListCardShape,
                        elevation: model.isClear ? 0 : 20,
                        child: ListTile(
                          dense: true,
                          title: _title(context, model, index),
                          onTap: model.isClear
                              ? null
                              : () async {
                                  // 修了試験の答えと解説表示モードへ
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExamPlay(
                                        userData,
                                        model.examLists,
                                        workshopList,
                                        index,
                                        true,
                                      ),
                                    ),
                                  );
                                },
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent.withOpacity(0.1),
                      border: const Border(
                        top: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        if (!model.isClear) _playButton(context, model),
                        SizedBox(height: 30),
                        if (!model.isClear)
                          _description(context, model, workshopList),
                        if (model.isClear) _passedMessage(context, model),
                        _score(context, model, workshopList),
                      ],
                    ),
                  ),
                  if (model.isStack || !model.isShowOk)
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
            Text(" 修了試験", style: cTextUpBarLL, textScaleFactor: 1),
            SizedBox(width: 20),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "  ${workshopList.workshop.title}",
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

  Widget _title(BuildContext context, ExamModel model, int index) {
    final bool _result =
        model.examLists[index].examResult.answerResult == "○" ? true : false;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            "${model.examLists[index].examResult.answerResult}",
            style: TextStyle(
                color: _result ? Colors.green : Colors.red, fontSize: 20),
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ),
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
          flex: 5,
          child: Text(
            "${model.examLists[index].question.question}",
            style: cTextListM,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  Widget _playButton(BuildContext context, ExamModel model) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.userEdit, color: Colors.white),
        label: Text(
          "　もう一度スタート！　",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 20,
        shape: cFABShape,
        color: cFAB,
        splashColor: Colors.white.withOpacity(0.5),
        textColor: Colors.white,
        onPressed: () async {
          model.initProperties();
          // 修了試験へ
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamPlay(
                userData,
                model.examLists,
                workshopList,
                0,
                false,
              ),
              fullscreenDialog: true,
            ),
          );
          _checkClear(context, model, workshopList);
          // todo WorkshopResultの保存
          if (model.isClear) {
            await _saveWorkshopResult();
          }
          if (model.isClear) {
            await FlareActors.instance.firework(context);
          }
        },
      ),
    );
  }

  Widget _description(
      BuildContext context, ExamModel model, WorkshopList workshopList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text("この修了試験を合格するには ", style: cTextListM, textScaleFactor: 1),
              Text("${workshopList.workshop.numOfExam}",
                  style: cTextListMR, textScaleFactor: 1),
              Text(" 問の全問解答で、", style: cTextListM, textScaleFactor: 1),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "${workshopList.workshop.passingScore}点以上が必要です。",
                style: cTextListMR,
                textScaleFactor: 1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "修了 目指して頑張ってください。",
            style: cTextListM,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  void _checkClear(
      BuildContext context, ExamModel model, WorkshopList workshopList) {
    // AllAnswersClearのチェック
    // model.setAllAnswersClear(model.examLists
    //     .every((element) => element.examResult.answerResult == "○"));
    // AllAnswersのチェック
    final bool _result =
        model.examLists.any((element) => element.examResult.answerResult == "");
    model.setAllAnswers(!_result);
    // ScoreClearのチェック
    model.setScoreClear((_getScore(context, model, workshopList) >=
                workshopList.workshop.passingScore ||
            _getScore(context, model, workshopList) == 100)
        ? true
        : false);
    // isClear のチェック
    if (workshopList.workshop.isExam) {
      if (workshopList.workshop.passingScore == 0) {
        model.setClear(model.isAllAnswers);
      } else {
        model.setClear(model.isScoreClear && model.isAllAnswers ? true : false);
      }
    } else {
      model.setClear(true);
    }
  }

  Widget _score(
      BuildContext context, ExamModel model, WorkshopList workshopList) {
    if (model.examLists.length > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("結果   ", style: cTextListM, textScaleFactor: 1),
            Row(
              children: [
                Text("${_getScore(context, model, workshopList)}",
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

  int _getScore(
      BuildContext context, ExamModel model, WorkshopList workshopList) {
    int result = 0;
    if (model.examLists.length > 0) {
      double _result = (model.correctCount / model.examLists.length) * 100;
      result = _result.toInt();
    }
    return result;
  }

  Future<void> _saveWorkshopResult() async {
    workshopList.workshopResult.isTaken = "研修済";
    workshopList.workshopResult.isTakenAt =
        ConvertDateTime.instance.dateToInt(DateTime.now());
    await WorkshopDatabase.instance
        .saveValue(workshopList.workshopResult, true);
  }

  Widget _bottomNavigationBar(BuildContext context, ExamModel model) {
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
          ],
        ),
      ),
    );
  }

  Widget _backListButton(BuildContext context, ExamModel model) {
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
                if (model.isClear == false) {
                  MyDialog.instance.okShowDialogFunc(
                    context: context,
                    mainTitle: "一覧に戻ると研修完了になりません！",
                    subTitle: "再度、修了試験を受けることになりますが"
                        "よろしいですか？",
                    onPressed: () {
                      // todo _lectureListを返す
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  );
                } else {
                  // todo _lectureListを返す
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _passedMessage(BuildContext context, ExamModel model) {
    return Container(
      child: Text(
        "合格です！",
        style: TextStyle(fontSize: 30, color: Colors.red),
        textScaleFactor: 1,
      ),
    );
  }

  Future<Widget> _showModalBottomSheetInfo(BuildContext context,
      ExamModel model, UserData userData, WorkshopList workshopList) async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: false,
      elevation: 20,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return ExamListBottomSheetInfoItems(model, userData, workshopList);
      },
    );
  }
}
