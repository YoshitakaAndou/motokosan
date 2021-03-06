import 'package:flutter/material.dart';
import 'package:motokosan/widgets/white_button.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/question/question_class.dart';
import 'package:motokosan/take_a_lecture/question/question_firebase.dart';
import 'package:motokosan/take_a_lecture/question/question_model.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/show_dialog.dart';
import '../../constants.dart';

class QuestionEdit extends StatelessWidget {
  final String groupName;
  final Lecture lecture;
  final Question question;
  QuestionEdit(
    this.groupName,
    this.lecture,
    this.question,
  );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    model.question = question;
    final qsTextController = TextEditingController();
    final ch1TitleTextController = TextEditingController();
    final ch2TitleTextController = TextEditingController();
    final ch3TitleTextController = TextEditingController();
    final ch4TitleTextController = TextEditingController();
    final adTextController = TextEditingController();
    qsTextController.text = question.question;
    ch1TitleTextController.text = question.choices1;
    ch2TitleTextController.text = question.choices2;
    ch3TitleTextController.text = question.choices3;
    ch4TitleTextController.text = question.choices4;
    adTextController.text = question.answerDescription;

    return Consumer<QuestionModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("確認テストの編集",
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              textScaleFactor: 1),
          leading: _batuButton(
            context,
            model,
            qsTextController,
            ch1TitleTextController,
            ch2TitleTextController,
            ch3TitleTextController,
            ch4TitleTextController,
            adTextController,
          ),
          // actions: [
          //   if (model.isUpdate)
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Icon(
          //         FontAwesomeIcons.pencilAlt,
          //         color: Colors.orange.withOpacity(0.5),
          //         size: 20,
          //       ),
          //     ),
          // ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _infoArea(model),
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    children: [
                      questionTile(model, qsTextController),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _delButton(context, model),
                model.isUpdate
                    ? _saveButton(
                        context,
                        model,
                        qsTextController,
                        ch1TitleTextController,
                        ch2TitleTextController,
                        ch3TitleTextController,
                        ch4TitleTextController,
                        adTextController,
                      )
                    : _closeButton(context, model),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _infoArea(QuestionModel model) {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text("テスト番号：${question.questionNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("講義：${lecture.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget questionTile(QuestionModel model, qsTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "問題文:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "問題文を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            qsTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: qsTextController,
      onChanged: (text) {
        model.isUpdate = true;
        model.changeValue("question", text);
      },
    );
  }

  Widget _choices1(QuestionModel model, ch1TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "選択肢 1",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "選択肢 1 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            ch1TitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: ch1TitleTextController,
      onChanged: (text) {
        model.isUpdate = true;
        model.changeValue("choices1", text);
      },
    );
  }

  Widget _choices2(QuestionModel model, ch2TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "選択肢 2",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "選択肢 2 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            ch2TitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: ch2TitleTextController,
      onChanged: (text) {
        model.isUpdate = true;
        model.changeValue("choices2", text);
      },
    );
  }

  Widget _choices3(QuestionModel model, ch3TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "選択肢 3",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "選択肢 3 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            ch3TitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: ch3TitleTextController,
      onChanged: (text) {
        model.isUpdate = true;
        model.changeValue("choices3", text);
      },
    );
  }

  Widget _choices4(QuestionModel model, ch4TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "選択肢 4",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "選択肢 4 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            ch4TitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: ch4TitleTextController,
      onChanged: (text) {
        model.isUpdate = true;
        model.changeValue("choices4", text);
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
      decoration: InputDecoration(
        labelText: "解答・説明:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "解答・説明を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            adTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: adTextController,
      onChanged: (text) {
        model.isUpdate = true;
        model.changeValue("answerDescription", text);
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
          MyDialog.instance.okShowDialog(
            context,
            "$choiceが入力されていません！",
            Colors.red,
          );
        } else {
          model.isUpdate = true;
          model.setCorrectChoices(choice);
        }
      },
    );
  }

  Widget _batuButton(
    BuildContext context,
    QuestionModel model,
    TextEditingController qsTextController,
    TextEditingController ch1TitleTextController,
    TextEditingController ch2TitleTextController,
    TextEditingController ch3TitleTextController,
    TextEditingController ch4TitleTextController,
    TextEditingController adTextController,
  ) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.times, size: 20),
      onPressed: () {
        if (model.isUpdate) {
          MyDialog.instance.batuButtonDialog(
            context: context,
            mainTitle: 'このまま閉じますか？',
            subTitle: '入力した情報は破棄されます',
            yesText: '登録して閉じる',
            yesPressed: () async {
              Navigator.of(context).pop();
              await _editProcess(
                context,
                model,
                qsTextController,
                ch1TitleTextController,
                ch2TitleTextController,
                ch3TitleTextController,
                ch4TitleTextController,
                adTextController,
              );
            },
            noText: '閉じる',
            noPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _saveButton(
    BuildContext context,
    QuestionModel model,
    TextEditingController qsTextController,
    TextEditingController ch1TitleTextController,
    TextEditingController ch2TitleTextController,
    TextEditingController ch3TitleTextController,
    TextEditingController ch4TitleTextController,
    TextEditingController adTextController,
  ) {
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
              icon: Icon(FontAwesomeIcons.solidSave, color: Colors.green),
              label: Text("登録する", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () => _editProcess(
                context,
                model,
                qsTextController,
                ch1TitleTextController,
                ch2TitleTextController,
                ch3TitleTextController,
                ch4TitleTextController,
                adTextController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context, QuestionModel model) {
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
              icon: Icon(FontAwesomeIcons.times, color: Colors.green),
              label: Text("やめる", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editProcess(
    BuildContext context,
    QuestionModel model,
    TextEditingController qsTextController,
    TextEditingController ch1TitleTextController,
    TextEditingController ch2TitleTextController,
    TextEditingController ch3TitleTextController,
    TextEditingController ch4TitleTextController,
    TextEditingController adTextController,
  ) async {
    // グリグリを回す
    model.startLoading();
    // 更新処理
    model.question.question = qsTextController.text;
    model.question.choices1 = ch1TitleTextController.text;
    model.question.choices2 = ch2TitleTextController.text;
    model.question.choices3 = ch3TitleTextController.text;
    model.question.choices4 = ch4TitleTextController.text;
    model.question.answerDescription = adTextController.text;
    try {
      model.inputCheck();
      await model.updateQuestionFs(groupName, DateTime.now(), lecture);
      await model.fetchQuestion(groupName, question.questionId);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました", Colors.black);
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Widget _delButton(BuildContext context, QuestionModel model) {
    return WhiteButton(
      context: context,
      title: " このテストを削除",
      icon: FontAwesomeIcons.trashAlt,
      iconSize: 15,
      onPress: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: question.question,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteSave(
              context,
              model,
              question.questionId,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _deleteSave(
      BuildContext context, QuestionModel model, questionId) async {
    model.startLoading();
    try {
      //FsをQuestionIdで削除
      await model.deleteQuestionFs(groupName, questionId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchQuestion(groupName, lecture.lectureId);
      //頭から順にquestionNoを振る
      int _count = 1;
      for (Question _data in model.questions) {
        _data.questionNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await FSQuestion.instance
            .setData(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      // LectureにQuestion.lengthを書き込む
      await model.setQSLengthToLecture(groupName, lecture);
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchQuestion(groupName, lecture.lectureId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
    }
    model.stopLoading();
  }
}
