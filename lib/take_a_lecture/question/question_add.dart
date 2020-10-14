import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lecture/lecture_model.dart';
import '../question/question_model.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';

class QuestionAdd extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  QuestionAdd(this.groupName, this._lecture);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context);
    model.question.questionNo =
        model.questions.length.toString().padLeft(4, "0");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "確認問題の新規登録",
          style: cTextTitleL,
          textScaleFactor: 1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.green,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.white),
              ),
              onPressed: () => _addProcess(context, model),
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
                _infoArea(model),
                Container(
                  width: MediaQuery.of(context).size.width - 28,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _number(model),
                      _question(model),
                      _choices1(model),
                      _choices2(model),
                      _choices3(model),
                      _choices4(model),
                      _correctNo(context, model),
                      Divider(height: 5, color: Colors.grey, thickness: 1),
                      _description(model),
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
    );
  }

  Widget _infoArea(QuestionModel model) {
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

  Widget _question(QuestionModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "問題文:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "問題文を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("question", text);
      },
    );
  }

  Widget _choices1(QuestionModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 1",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 1 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("choices1", text);
      },
    );
  }

  Widget _choices2(QuestionModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 2",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 2 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("choices2", text);
      },
    );
  }

  Widget _choices3(QuestionModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 3",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 3 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("choices3", text);
      },
    );
  }

  Widget _choices4(QuestionModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "選択肢 4",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "選択肢 4 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
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

  Widget _description(QuestionModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "解答・説明:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "解答・説明を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
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
        if (option.isEmpty) {
          okShowDialog(context, "$choiceが入力されていません！");
        } else {
          model.setCorrectChoices(choice);
        }
      },
    );
  }

  Future<void> _addProcess(BuildContext context, QuestionModel model) async {
    DateTime _timeStamp = DateTime.now();
    model.question.questionId = _timeStamp.toString();
    try {
      model.startLoading();
      model.inputCheck();
      await model.addQuestionFs(groupName, _timeStamp);
      model.stopLoading();
      await okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }
}
