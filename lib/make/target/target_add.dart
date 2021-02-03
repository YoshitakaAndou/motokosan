import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../take_a_lecture/target/target_model.dart';

class TargetAdd extends StatelessWidget {
  final String groupName;
  TargetAdd({this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TargetModel>(context, listen: false);
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = model.target.title;
    subTitleTextController.text = model.target.subTitle;
    option1TextController.text = model.target.option1;
    option2TextController.text = model.target.option2;
    option3TextController.text = model.target.option3;
    model.target.targetNo =
        (model.targets.length + 1).toString().padLeft(4, "0");
    return Consumer<TargetModel>(builder: (context, model, child) {
      model.isEditing = _checkValue(model);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: cToolBarH,
          title: Text("対象者の新規登録", style: cTextTitleL, textScaleFactor: 1),
          leading: _batuButton(context, model),
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
                  Container(
                    width: MediaQuery.of(context).size.width - 28,
                    height: MediaQuery.of(context).size.height / 2,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(model, titleTextController),
                        _subTitle(model, subTitleTextController),
                        _option1(model, option1TextController),
                        _option2(model, option2TextController),
                        _option3(model, option3TextController),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
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
          child: model.isEditing
              ? _saveButton(context, model)
              : _closeButton(context, model),
        ),
      );
    });
  }

  Widget _infoArea(TargetModel model) {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text("　番号：${model.target.targetNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" ", style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(TargetModel model, titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: titleTextController,
      decoration: InputDecoration(
        labelText: "対象者:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "対象者 を入力してください（必須）",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            titleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(TargetModel model, subTitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: subTitleTextController,
      decoration: InputDecoration(
        labelText: "subTitle:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "subTitle を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            subTitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("subTitle", text);
      },
    );
  }

  Widget _option1(TargetModel model, option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: option1TextController,
      decoration: InputDecoration(
        labelText: "option1:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "option1 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            option1TextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("option1", text);
      },
    );
  }

  Widget _option2(TargetModel model, option2TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: option2TextController,
      decoration: InputDecoration(
        labelText: "option2:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "option2 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            option2TextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("option2", text);
      },
    );
  }

  Widget _option3(TargetModel model, option3TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: option3TextController,
      decoration: InputDecoration(
        labelText: "option3:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "option3 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            option3TextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("option3", text);
      },
    );
  }

  Widget _batuButton(BuildContext context, TargetModel model) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.times, size: 20),
      onPressed: () {
        if (_checkValue(model)) {
          MyDialog.instance.batuButtonDialog(
            context: context,
            mainTitle: 'このまま閉じますか？',
            subTitle: '入力した情報は破棄されます',
            yesText: '登録して閉じる',
            yesPressed: () async {
              Navigator.of(context).pop();
              await _addProcess(context, model);
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

  Widget _saveButton(BuildContext context, TargetModel model) {
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

  Widget _closeButton(BuildContext context, TargetModel model) {
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

  Future<void> _addProcess(BuildContext context, TargetModel model) async {
    DateTime _timeStamp = DateTime.now();
    model.target.targetId = _timeStamp.toString();
    // model.target.targetNo =
    //     model.targets.length.toString().padLeft(4, "0"); //questionId
    try {
      model.startLoading();
      await model.addTargetFs(groupName, _timeStamp);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }

  bool _checkValue(TargetModel model) {
    bool _result = false;
    _result = model.target.title.isNotEmpty ? true : _result;
    _result = model.target.subTitle.isNotEmpty ? true : _result;
    _result = model.target.option1.isNotEmpty ? true : _result;
    _result = model.target.option2.isNotEmpty ? true : _result;
    _result = model.target.option3.isNotEmpty ? true : _result;
    return _result;
  }
}
