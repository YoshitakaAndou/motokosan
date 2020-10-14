import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/question/question_model.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'question_play.dart';

class QuestionListPage extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;

  QuestionListPage(this.groupName, this._lecture);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchQuestion(groupName, _lecture.lectureId);
      await model.generateQuestionList(groupName, _lecture.lectureId);
      model.stopLoading();
    });
    return Consumer<QuestionModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: barTitle(context),
          leading: goBackWithArg(
            context: context,
            icon: Icon(FontAwesomeIcons.chevronLeft),
            arg: false,
            num: 2,
          ),
          actions: [
            goBackWithArg(
              context: context,
              icon: Icon(FontAwesomeIcons.home),
              num: 5,
              arg: false,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _infoArea(),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height - 300,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: model.questionLists.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 10,
                          child: ListTile(
                            dense: true,
                            title: Row(
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
                                  child: model.questionLists[index]
                                              .questionResult.answerResult ==
                                          "○"
                                      ? Icon(FontAwesomeIcons.circle)
                                      : model
                                                  .questionLists[index]
                                                  .questionResult
                                                  .answerResult ==
                                              "×"
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
                            ),
                            onTap: () async {
                              // Questionへ 終わったら値を受け取る
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionPlay(
                                    groupName,
                                    model.questions[index],
                                    _lecture,
                                    model.questions.length - index,
                                    false,
                                  ),
                                ),
                              );
                              int _index = index + 1;
                              // リストの最後まで来たら終わり
                              if (_index >= model.questions.length) {
                                result = false;
                              }
                              // これより下はindexではなく_indexとなっている
                              while (result) {
                                result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionPlay(
                                        groupName,
                                        model.questions[_index],
                                        _lecture,
                                        model.questions.length - _index,
                                        false,
                                      ),
                                    ));
                                _index += 1;
                                // リストの最後まで来たら終わり
                                if (_index >= model.questions.length) {
                                  result = false;
                                }
                              }
                              await model.generateQuestionList(
                                  groupName, _lecture.lectureId);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black54.withOpacity(0.8),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 40,
                child: RaisedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.userEdit,
                    color: Colors.white,
                  ),
                  label: Text(
                    "　確認問題を解いてみる",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    // Trainingへ 終わったら値を受け取る
                    bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPlay(
                          groupName,
                          model.questions[0],
                          _lecture,
                          model.questions.length,
                          false,
                        ),
                      ),
                    );
                    int _count = 1;
                    // リストの最後まで来たら終わり
                    if (_count >= model.questions.length) {
                      result = false;
                    }
                    while (result) {
                      result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionPlay(
                              groupName,
                              model.questions[_count],
                              _lecture,
                              model.questions.length - _count,
                              false,
                            ),
                          ));
                      _count += 1;
                      // リストの最後まで来たら終わり
                      if (_count >= model.questions.length) {
                        result = false;
                      }
                    }
                    await model.generateQuestionList(
                        groupName, _lecture.lectureId);
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
              ),
              SizedBox(height: 50),
            ],
          ),
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

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(" 確認問題", style: cTextUpBarLL, textScaleFactor: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("講義：", style: cTextUpBarM, textScaleFactor: 1),
                  Text(_lecture.title, style: cTextUpBarM, textScaleFactor: 1),
                ],
              )
            ],
          )),
    );
  }
}
