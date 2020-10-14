import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import '../lecture/lecture_model.dart';
import 'question_add.dart';
import 'question_edit.dart';
import 'question_model.dart';

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
          actions: [
            IconButton(
                icon: Icon(FontAwesomeIcons.home),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                })
          ],
          title: Text("確認問題を編集", style: cTextTitleL, textScaleFactor: 1),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _infoArea(context),
                Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ReorderableListView(
                      children: model.questions.map(
                        (_question) {
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
                                  await model.fetchQuestion(
                                      groupName, _lecture.lectureId);
                                  model.stopLoading();
                                },
                              ));
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
                    )),
              ],
            ),
          ),
          if (model.isLoading)
            Container(
                color: Colors.black87.withOpacity(0.8),
                child: Center(child: CircularProgressIndicator())),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(FontAwesomeIcons.plus),
          // add
          onPressed: () async {
            model.initQuestion(_lecture);
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionAdd(groupName, _lecture),
                  fullscreenDialog: true,
                ));
            await model.fetchQuestion(groupName, _lecture.lectureId);
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Container(
            height: 45,
            padding: EdgeInsets.all(10),
            child: Text(
              "",
              style: cTextUpBarL,
              textScaleFactor: 1,
            ),
          ),
        ),
      );
    });
  }

  Widget _infoArea(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(" ＜ ", style: cTextUpBarL, textScaleFactor: 1),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("講義名", style: cTextUpBarSS, textScaleFactor: 1),
                      Text(_lecture.title,
                          style: cTextUpBarM, textScaleFactor: 1),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, QuestionModel model) async {
    try {
      int _count = 0;
      for (Question _data in model.questions) {
        _data.questionNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setQuestionFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchQuestion(groupName, _lecture.lectureId);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }
}
