import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_model.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'workshop_model.dart';

class WorkshopAdd extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  WorkshopAdd(this.groupName, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    model.workshop.workshopNo =
        model.workshops.length.toString().padLeft(4, "0");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "研修会の新規登録",
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
                _infoArea(model),
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
                color: Colors.black87.withOpacity(0.8),
                child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  Widget _infoArea(WorkshopModel model) {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("＞${_organizer.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                  "分類名を情報を入力し、"
                  "\n登録ボタンを押してください！",
                  style: cTextUpBarS,
                  textScaleFactor: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _number(WorkshopModel model) {
    return Text("${model.workshop.workshopNo}");
  }

  Widget _title(WorkshopModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "研修会名:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "研修会名 を入力してください（必須）",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(WorkshopModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Widget _option1(WorkshopModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Widget _option2(WorkshopModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Widget _option3(WorkshopModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Future<void> _addProcess(BuildContext context, WorkshopModel model) async {
    DateTime _timeStamp = DateTime.now();
    model.workshop.workshopId = _timeStamp.toString();
    // model.target.targetNo =
    //     model.targets.length.toString().padLeft(4, "0"); //questionId
    try {
      model.startLoading();
      await model.addWorkshopFs(groupName, _timeStamp);
      model.stopLoading();
      await okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }
}
