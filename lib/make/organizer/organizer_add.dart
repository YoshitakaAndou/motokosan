import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../take_a_lecture/organizer/organizer_model.dart';

class OrganizerAdd extends StatelessWidget {
  final String groupName;
  OrganizerAdd(this.groupName);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context, listen: false);
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = model.organizer.title;
    subTitleTextController.text = model.organizer.subTitle;
    option1TextController.text = model.organizer.option1;
    option2TextController.text = model.organizer.option2;
    option3TextController.text = model.organizer.option3;

    // 番号
    model.organizer.organizerNo =
        (model.organizers.length + 1).toString().padLeft(4, "0");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: cToolBarH,
        centerTitle: true,
        title: Text("主催者情報の新規登録", style: ceTextTitleL, textScaleFactor: 1),
        leading: _batuButton(context, model),
      ),
      body: Stack(
        children: [
          // TextField入力時にキーボードが迫り上がるのでSingleChildScrollView()で逃げる
          SingleChildScrollView(
            child: Column(
              children: [
                _infoArea(model),
                ListView(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                    _title(model, titleTextController),
                    _subTitle(model, subTitleTextController),
                    _option1(model, option1TextController),
                    _option2(model, option2TextController),
                    _option3(model, option3TextController),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
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
      bottomNavigationBar:
          Consumer<OrganizerModel>(builder: (context, model, child) {
        model.isEditing = _checkValue(model);
        return BottomAppBar(
          color: cContBg,
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
        );
      }),
    );
  }

  Widget _infoArea(OrganizerModel model) {
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
              child: Text("　番号：${model.organizer.organizerNo}",
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

  Widget _title(OrganizerModel model, titleTextController) {
    return TextField(
      cursorColor: cFAB,
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: titleTextController,
      decoration: InputDecoration(
        labelText: "主催者:",
        labelStyle: TextStyle(fontSize: 10, color: cFAB),
        hintText: "主催者 を入力してください（必須）",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            titleTextController.text = "";
            model.changeValue("title", "");
          },
          icon: Icon(
            Icons.clear,
            size: 15,
            color: cFAB,
          ),
        ),
      ),
      onChanged: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(OrganizerModel model, subTitleTextController) {
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
            model.changeValue("subTitle", "");
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("subTitle", text);
      },
    );
  }

  Widget _option1(OrganizerModel model, option1TextController) {
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
            model.changeValue("option1", "");
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("option1", text);
      },
    );
  }

  Widget _option2(OrganizerModel model, option2TextController) {
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
            model.changeValue("option2", "");
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("option2", text);
      },
    );
  }

  Widget _option3(OrganizerModel model, option3TextController) {
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
            model.changeValue("option3", "");
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("option3", text);
      },
    );
  }

  Widget _batuButton(BuildContext context, OrganizerModel model) {
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

  Widget _saveButton(BuildContext context, OrganizerModel model) {
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
              icon: Icon(FontAwesomeIcons.solidSave, color: cFAB),
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

  Widget _closeButton(BuildContext context, OrganizerModel model) {
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
              icon: Icon(FontAwesomeIcons.times, color: cFAB),
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

  Future<void> _addProcess(BuildContext context, OrganizerModel model) async {
    DateTime _timeStamp = DateTime.now();
    model.organizer.organizerId = _timeStamp.toString();
    // model.target.targetNo =
    //     model.targets.length.toString().padLeft(4, "0"); //questionId
    try {
      model.startLoading();
      await model.addOrganizerFs(groupName, _timeStamp);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "登録完了しました", Colors.black);
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
      model.stopLoading();
    }
  }

  bool _checkValue(OrganizerModel model) {
    bool _result = false;
    _result = model.organizer.title.isNotEmpty ? true : _result;
    _result = model.organizer.subTitle.isNotEmpty ? true : _result;
    _result = model.organizer.option1.isNotEmpty ? true : _result;
    _result = model.organizer.option2.isNotEmpty ? true : _result;
    _result = model.organizer.option3.isNotEmpty ? true : _result;
    return _result;
  }
}
