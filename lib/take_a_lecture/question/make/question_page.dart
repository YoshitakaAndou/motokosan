import 'package:flutter/material.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import '../../lecture/lecture_model.dart';
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
            Text(" 確認テストを編集", style: cTextUpBarL, textScaleFactor: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("講義：", style: cTextUpBarS, textScaleFactor: 1),
                Text(_lecture.title, style: cTextUpBarS, textScaleFactor: 1),
              ],
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
      elevation: 15,
      child: ListTile(
        dense: true,
        title: Text("${_question.question}",
            style: cTextListM, textScaleFactor: 1),
        leading: Text("${_question.questionNo}",
            style: cTextListS, textScaleFactor: 1),
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
    );
  }

  Widget _floatingActionButton(BuildContext context, QuestionModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.plus),
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
}