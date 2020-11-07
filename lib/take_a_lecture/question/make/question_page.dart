import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/question/question_class.dart';
import 'package:motokosan/take_a_lecture/question/play/question_firebase.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import 'question_add.dart';
import 'question_edit.dart';
import '../question_model.dart';

class QuestionPage extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  QuestionPage(this.groupName, this._lecture);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    model.question.organizerId = _lecture.organizerId;
    model.question.workshopId = _lecture.workshopId;
    model.question.lectureId = _lecture.lectureId;
    Future(() async {
      model.startLoading();
      await model.fetchQuestion(groupName, _lecture.lectureId);
      model.stopLoading();
    });
    return Consumer<QuestionModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          actions: [
            _homeButton(context),
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _infoArea()),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  _listBody(context, model),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _floatingActionButton(context, model),
        bottomNavigationBar: _bottomAppBar(context, model),
      );
    });
  }

  Widget _homeButton(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.home),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child:
                    Text(" 確認テストを編集", style: cTextUpBarL, textScaleFactor: 1)),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    // border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Text("講義：", style: cTextUpBarS, textScaleFactor: 1),
                          Flexible(
                            child: Text(
                              _lecture.title,
                              style: cTextUpBarS,
                              textScaleFactor: 1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "問題数：${_lecture.questionLength} 問",
                            style: cTextUpBarSS,
                            textScaleFactor: 1,
                          ),
                          Text(
                            "${_lecture.allAnswers} ",
                            style: cTextUpBarSS,
                            textScaleFactor: 1,
                          ),
                          Text(
                            "合格点：${_lecture.passingScore} 点",
                            style: cTextUpBarSS,
                            textScaleFactor: 1,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, QuestionModel model) async {
    final FSQuestion fsQuestion = FSQuestion();
    try {
      int _count = 1;
      for (Question _data in model.questions) {
        _data.questionNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await fsQuestion.setData(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchQuestion(groupName, _lecture.lectureId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
    }
  }

  Widget _listBody(BuildContext context, QuestionModel model) {
    return ReorderableListView(
      children: model.questions.map(
        (_question) {
          return _listItem(context, model, _question);
        },
      ).toList(),
      onReorder: (oldIndex, newIndex) {
        model.startLoading();
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final _target = model.questions.removeAt(oldIndex);
        model.questions.insert(newIndex, _target);
        _sortedSave(context, model);
        model.stopLoading();
      },
    );
  }

  Widget _listItem(
      BuildContext context, QuestionModel model, Question _question) {
    return Card(
      key: Key(_question.questionId),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.03, 0.03],
            colors: [cCardLeft, Colors.white],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          dense: true,
          title: _title(context, _question),
          subtitle: _subtitle(context, _question),
          leading: _leading(context, _question),
          onTap: () async {
            // Edit
            model.question = _question;
            model.setCorrectForEditing();
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionEdit(
                    groupName,
                    _lecture,
                    _question,
                  ),
                  fullscreenDialog: true,
                ));
            model.startLoading();
            await model.fetchQuestion(groupName, _lecture.lectureId);
            model.stopLoading();
          },
        ),
      ),
    );
  }

  Widget _title(BuildContext context, Question _question) {
    return Text(
      "${_question.question}",
      style: cTextListM,
      textScaleFactor: 1,
      maxLines: 2,
    );
  }

  Widget _subtitle(BuildContext context, Question _question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "解答選択肢：${_getOptionCount(_question)}",
            style: cTextListS,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  Widget _leading(BuildContext context, Question _question) {
    return Text("${_question.questionNo}",
        style: cTextListS, textScaleFactor: 1);
  }

  Widget _floatingActionButton(BuildContext context, QuestionModel model) {
    return FloatingActionButton.extended(
      elevation: 15,
      icon: Icon(FontAwesomeIcons.plus),
      label: Text(" 確認テストを追加", style: cTextUpBarL, textScaleFactor: 1),
      // add
      onPressed: () async {
        model.initQuestion(_lecture);
        model.initProperties();
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionAdd(groupName, _lecture),
              fullscreenDialog: true,
            ));
        await model.fetchQuestion(groupName, _lecture.lectureId);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, QuestionModel model) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      notchMargin: 6.0,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(
          side: BorderSide(),
        ),
      ),
      child: Container(height: 45),
    );
  }

  int _getOptionCount(Question _question) {
    int _count = 0;
    if (_question.choices4.isNotEmpty) {
      _count = 4;
    } else {
      if (_question.choices3.isNotEmpty) {
        _count = 3;
      } else {
        _count = 2;
      }
    }
    return _count;
  }
}
