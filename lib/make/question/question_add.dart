import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:provider/provider.dart';
import '../../take_a_lecture/question/question_model.dart';
import '../../widgets/show_dialog.dart';
import '../../data/constants.dart';

class QuestionAdd extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  QuestionAdd(this.groupName, this._lecture);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuestionModel>(context, listen: false);
    final qsTextController = TextEditingController();
    final ch1TitleTextController = TextEditingController();
    final ch2TitleTextController = TextEditingController();
    final ch3TitleTextController = TextEditingController();
    final ch4TitleTextController = TextEditingController();
    final adTextController = TextEditingController();
    qsTextController.text = model.question.question;
    ch1TitleTextController.text = model.question.choices1;
    ch2TitleTextController.text = model.question.choices2;
    ch3TitleTextController.text = model.question.choices3;
    ch4TitleTextController.text = model.question.choices4;
    adTextController.text = model.question.answerDescription;
    model.question.questionNo =
        (model.questions.length + 1).toString().padLeft(4, "0");
    return Consumer<QuestionModel>(builder: (context, model, child) {
      model.isEditing = _checkValue(model);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("確認テストの新規登録", style: cTextTitleL, textScaleFactor: 1),
          actions: [
            if (model.isEditing)
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
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    children: [
                      _question(model, qsTextController),
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
          child: model.isEditing
              ? _saveButton(context, model)
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
              child: Text("テスト番号：${model.question.questionNo}",
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

  Widget _question(QuestionModel model, qsTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: qsTextController,
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
      onSubmitted: (text) {
        model.changeValue("question", text);
      },
      onChanged: (text) {
        model.changeValue("question", text);
      },
    );
  }

  Widget _choices1(QuestionModel model, ch1TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: ch1TitleTextController,
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
      onChanged: (text) {
        model.changeValue("choices1", text);
      },
    );
  }

  Widget _choices2(QuestionModel model, ch2TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: ch2TitleTextController,
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
      onChanged: (text) {
        model.changeValue("choices2", text);
      },
    );
  }

  Widget _choices3(QuestionModel model, ch3TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: ch3TitleTextController,
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
      onChanged: (text) {
        model.changeValue("choices3", text);
      },
    );
  }

  Widget _choices4(QuestionModel model, ch4TitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: ch4TitleTextController,
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

  Widget _description(QuestionModel model, adTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      controller: adTextController,
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
          MyDialog.instance.okShowDialog(context, "$choiceが入力されていません！");
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
      await model.addQuestionFs(groupName, _timeStamp, _lecture);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }

  bool _checkValue(QuestionModel model) {
    bool _result = false;
    _result = model.question.question.isNotEmpty ? true : _result;
    _result = model.question.choices1.isNotEmpty ? true : _result;
    _result = model.question.choices2.isNotEmpty ? true : _result;
    _result = model.question.choices3.isNotEmpty ? true : _result;
    _result = model.question.choices4.isNotEmpty ? true : _result;
    _result = model.question.correctChoices.isNotEmpty ? true : _result;
    _result = model.question.answerDescription.isNotEmpty ? true : _result;
    return _result;
  }

  Widget _saveButton(BuildContext context, QuestionModel model) {
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
              onPressed: () => _addProcess(context, model),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
