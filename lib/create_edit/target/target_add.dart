import 'package:flutter/material.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'target_model.dart';

class TargetAdd extends StatelessWidget {
  final String groupName;
  TargetAdd({this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TargetModel>(context, listen: false);
    model.target.targetNo = model.targets.length.toString().padLeft(4, "0");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "対象名の新規登録",
          style: cTextTitleL,
          textScaleFactor: 1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () => _addProcess(context, model),
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
                    children: [
                      _number(model),
                      _title(model),
                      _subTitle(model),
                      Divider(height: 5, color: Colors.grey, thickness: 1),
                      _option1(model),
                      _option2(model),
                      _option3(model),
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
            child: Text("　対象名を情報を入力し、登録ボタンを押してください",
                style: cTextUpBarM, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Widget _number(TargetModel model) {
    return Text("${model.target.targetNo}");
  }

  Widget _title(TargetModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "対象名:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "対象名 を入力してください（必須）",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(TargetModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "subTitle:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "subTitle を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("subTitle", text);
      },
    );
  }

  Widget _option1(TargetModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "option1:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "option1 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("option1", text);
      },
    );
  }

  Widget _option2(TargetModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "option2:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "option2 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("option2", text);
      },
    );
  }

  Widget _option3(TargetModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "option3:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "option3 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("option3", text);
      },
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
      await okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }
}
