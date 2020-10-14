import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../question/question_model.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import '../lecture/lecture_model.dart';

class QuestionEdit extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  final Question _question;
  QuestionEdit(this.groupName, this._lecture, this._question);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    model.question = _question;
    final qsTextController = TextEditingController();
    final ch1TitleTextController = TextEditingController();
    final ch2TitleTextController = TextEditingController();
    final ch3TitleTextController = TextEditingController();
    final ch4TitleTextController = TextEditingController();
    final adTextController = TextEditingController();
    qsTextController.text = _question.question;
    ch1TitleTextController.text = _question.choices1;
    ch2TitleTextController.text = _question.choices2;
    ch3TitleTextController.text = _question.choices3;
    ch4TitleTextController.text = _question.choices4;
    adTextController.text = _question.answerDescription;

    return Consumer<QuestionModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "確認問題の編集",
            style: cTextTitleL,
            textScaleFactor: 1,
          ),
          actions: [
            if (model.isUpdate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.green,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () async {
                    // 更新処理（外だしは出来ません）
                    model.question.question = qsTextController.text;
                    model.question.choices1 = ch1TitleTextController.text;
                    model.question.choices2 = ch2TitleTextController.text;
                    model.question.choices3 = ch3TitleTextController.text;
                    model.question.choices4 = ch4TitleTextController.text;
                    model.question.answerDescription = adTextController.text;
                    model.startLoading();
                    try {
                      model.inputCheck();
                      await model.updateQuestionFs(groupName, DateTime.now());
                      await model.fetchQuestion(
                          groupName, _question.questionId);
                      model.stopLoading();
                      await okShowDialog(context, "更新しました");
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                    }
                    model.resetUpdate();
                  },
                  child: Text(
                    "登　録",
                    style: cTextUpBarL,
                    textScaleFactor: 1,
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _infoArea(),
                  Container(
                    width: MediaQuery.of(context).size.width - 28,
                    // height: MediaQuery.of(context).size.height + 300,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _number(model),
                        _questionTile(model, qsTextController),
                        _choices1(model, ch1TitleTextController),
                        _choices2(model, ch2TitleTextController),
                        _choices3(model, ch3TitleTextController),
                        _choices4(model, ch4TitleTextController),
                        _correctNo(context, model),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        _description(model, adTextController),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (model.isLoading)
              Container(
                  color: Colors.black87.withOpacity(0.8),
                  child: Center(child: CircularProgressIndicator())),
          ],
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
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(FontAwesomeIcons.trashAlt),
          onPressed: () {
            okShowDialogFunc(
              context: context,
              mainTitle: _question.question,
              subTitle: "削除しますか？",
              // delete
              onPressed: () async {
                await _deleteSave(
                  context,
                  model,
                  _question.questionId,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 65,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text("＞${_lecture.title}",
                  style: cTextUpBarS, textScaleFactor: 1),
            ),
            Expanded(
              flex: 2,
              child: Text(
                  "情報を入力し、"
                  "\n登録ボタンを押してください！",
                  style: cTextUpBarS,
                  textScaleFactor: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _number(QuestionModel model) {
    return Text("確認問題番号：${model.question.questionNo}");
  }

  Widget _questionTile(QuestionModel model, qsTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "問題文:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "問題文を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: qsTextController,
      onChanged: (text) {
        model.changeValue("question", text);
        model.isUpdate = true;
      },
    );
  }

  Widget _choices1(QuestionModel model, ch1TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 1",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 1 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: ch1TitleTextController,
      onChanged: (text) {
        model.changeValue("choices1", text);
        model.isUpdate = true;
      },
    );
  }

  Widget _choices2(QuestionModel model, ch2TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 2",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 2 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: ch2TitleTextController,
      onChanged: (text) {
        model.changeValue("choices2", text);
        model.isUpdate = true;
      },
    );
  }

  Widget _choices3(QuestionModel model, ch3TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 3",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 3 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: ch3TitleTextController,
      onChanged: (text) {
        model.changeValue("choices3", text);
        model.isUpdate = true;
      },
    );
  }

  Widget _choices4(QuestionModel model, ch4TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 4",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 4 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: ch4TitleTextController,
      onChanged: (text) {
        model.changeValue("choices4", text);
        model.isUpdate = true;
      },
    );
  }

  Widget _correctNo(BuildContext context, QuestionModel model) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "正解：${model.correct ?? ""}",
            style: cTextListM,
            textScaleFactor: 1,
          ),
        ),
        Expanded(
          flex: 1,
          child: _answerSelection(
              model, context, "1", "選択肢1", model.question.choices1),
        ),
        Expanded(
          flex: 1,
          child: _answerSelection(
              model, context, "2", "選択肢2", model.question.choices2),
        ),
        if (model.question.choices3.isNotEmpty)
          Expanded(
            flex: 1,
            child: _answerSelection(
                model, context, "3", "選択肢3", model.question.choices3),
          ),
        if (model.question.choices4.isNotEmpty)
          Expanded(
            flex: 1,
            child: _answerSelection(
                model, context, "4", "選択肢4", model.question.choices4),
          ),
      ],
    );
  }

  Widget _description(QuestionModel model, adTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "解答・説明:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "解答・説明を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: adTextController,
      onChanged: (text) {
        model.changeValue("answerDescription", text);
        model.isUpdate = true;
      },
    );
  }

  Widget _answerSelection(model, context, label, choice, option) {
    return RaisedButton(
      child: Text(
        label,
        style: cTextListL,
        textScaleFactor: 1,
      ),
      color: model.correct == choice ? Colors.greenAccent : Colors.white,
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      onPressed: () {
        print("$choice:$option");
        if (option.isEmpty) {
          okShowDialog(context, "$choiceが入力されていません！");
        } else {
          model.setCorrectChoices(choice);
          model.isUpdate = true;
        }
      },
    );
  }

  Future<void> _deleteSave(
      BuildContext context, QuestionModel model, _questionId) async {
    try {
      //FsをQuestionIdで削除
      await model.deleteQuestionFs(groupName, _questionId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchQuestion(groupName, _lecture.lectureId);
      //頭から順にquestionNoを振る
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
