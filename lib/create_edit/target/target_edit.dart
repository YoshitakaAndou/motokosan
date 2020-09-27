import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/target/target_model.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class TargetEdit extends StatelessWidget {
  final String groupName;
  final Target _target;
  TargetEdit(this.groupName, this._target);

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = _target.title;
    subTitleTextController.text = _target.subTitle;
    option1TextController.text = _target.option1;
    option2TextController.text = _target.option2;
    option3TextController.text = _target.option3;

    return Consumer<TargetModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "対象名の編集",
            style: cTextTitleL,
            textScaleFactor: 1,
          ),
          actions: [
            if (model.isUpdate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.green),
                  ),
                  onPressed: () async {
                    // 更新処理（外だしは出来ません）
                    model.target.title = titleTextController.text;
                    model.target.subTitle = subTitleTextController.text;
                    model.target.option1 = option1TextController.text;
                    model.target.option2 = option2TextController.text;
                    model.target.option3 = option3TextController.text;
                    model.target.targetId = _target.targetId;
                    model.target.targetNo = _target.targetNo;
                    model.target.createAt = _target.createAt;
                    model.target.updateAt = _target.updateAt;
                    model.startLoading();
                    try {
                      await model.updateTargetFs(groupName, DateTime.now());
                      await model.fetchTarget(groupName);
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
                    style: cTextListL,
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
                    height: MediaQuery.of(context).size.height / 2,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _targetNumber(model),
                        _title(model, titleTextController),
                        _subTitle(model, subTitleTextController),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
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
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator())),
          ],
        ),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("　対象名を情報を編集し、登録ボタンを押してください",
                style: cTextUpBarM, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Widget _targetNumber(TargetModel model) {
    return Text("${_target.targetNo}");
  }

  Widget _title(TargetModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Title:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Title を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _titleTextController,
      onChanged: (text) {
        model.changeValue("title", text);
        model.setUpdate();
      },
    );
  }

  Widget _subTitle(TargetModel model, _subTitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "subTitle:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "subTitle を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _subTitleTextController,
      onChanged: (text) {
        model.changeValue("subTitle", text);
        model.setUpdate();
      },
    );
  }

  Widget _option1(TargetModel model, _option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "option1:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "option1 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _option1TextController,
      onChanged: (text) {
        model.changeValue("option1", text);
        model.setUpdate();
      },
    );
  }

  Widget _option2(TargetModel model, _option2TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "option2:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "option2 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _option2TextController,
      onChanged: (text) {
        model.changeValue("option2", text);
        model.setUpdate();
      },
    );
  }

  Widget _option3(TargetModel model, _option3TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "option3:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "option3 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _option3TextController,
      onChanged: (text) {
        model.changeValue("option3", text);
        model.setUpdate();
      },
    );
  }
}
