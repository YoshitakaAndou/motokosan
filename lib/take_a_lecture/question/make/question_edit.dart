import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../question_model.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import '../../lecture/lecture_model.dart';

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
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("確認テストの編集", style: cTextTitleL, textScaleFactor: 1),
          actions: [
            if (model.isUpdate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.pencilAlt,
                  color: Colors.orange.withOpacity(0.5),
                  size: 20,
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _infoArea(model),
                  Container(
                    width: MediaQuery.of(context).size.width - 28,
                    // height: MediaQuery.of(context).size.height + 300,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: _deleteButton(context, model),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: model.isUpdate
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
              child: Text("テスト番号：${_question.questionNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("講義：${_lecture.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionTile(QuestionModel model, qsTextController) {
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
          MyDialog.instance.okShowDialog(context, "$choiceが入力されていません！");
        } else {
          model.setCorrectChoices(choice);
          model.isUpdate = true;
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
      await model.updateQuestionFs(groupName, DateTime.now(), _lecture);
      await model.fetchQuestion(groupName, _question.questionId);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Widget _deleteButton(BuildContext context, QuestionModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.trashAlt),
      // todo 削除
      onPressed: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: _question.question,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteSave(
              context,
              model,
              _question.questionId,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _deleteSave(
      BuildContext context, QuestionModel model, _questionId) async {
    model.startLoading();
    try {
      //FsをQuestionIdで削除
      await model.deleteQuestionFs(groupName, _questionId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchQuestion(groupName, _lecture.lectureId);
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
      await model.setQSLengthToLecture(groupName, _lecture);
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchQuestion(groupName, _lecture.lectureId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
    }
    model.stopLoading();
  }
}
