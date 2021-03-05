import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../take_a_lecture/workshop/workshop_model.dart';

class WorkshopAdd extends StatelessWidget {
  final String groupName;
  final Organizer organizer;
  WorkshopAdd(
    this.groupName,
    this.organizer,
  );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = model.workshop.title;
    subTitleTextController.text = model.workshop.subTitle;
    option1TextController.text = model.workshop.information;
    option2TextController.text = model.workshop.subInformation;
    option3TextController.text = model.workshop.option3;
    model.workshop.workshopNo =
        (model.workshops.length + 1).toString().padLeft(4, "0");
    model.workshop.deadlineAt =
        ConvertDateTime.instance.dateToInt(DateTime.now());
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      model.isEditing = _checkValue(model);
      bool _isRelease = model.workshop.isRelease;
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("研修会の新規登録", style: cTextTitleL, textScaleFactor: 1),
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
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _switch(model, context, _isRelease),
                          _deadlineDate(model, context),
                        ],
                      ),
                      _title(model, titleTextController, option1TextController),
                      _subTitle(model, subTitleTextController),
                      _option1(model, option1TextController),
                      _option2(model, option2TextController),
                      // _option3(model, option3TextController),
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

  Widget _infoArea(WorkshopModel model) {
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
              child: Text("　番号：${model.workshop.workshopNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("主催：${organizer.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switch(WorkshopModel model, BuildContext context, _isRelease) {
    return Column(
      children: [
        Row(
          children: [
            Text("講座が０件では公開できません！",
                style: TextStyle(fontSize: 10, color: Colors.black26),
                textScaleFactor: 1),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Switch(
              value: _isRelease,
              activeColor: Colors.green,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              onChanged: (value) {
                if (model.workshop.lectureLength > 0) {
                  model.changeIsRelease(value);
                }
              },
            ),
            SizedBox(width: 20),
            Text(_isRelease ? '公開する' : '非公開',
                style: TextStyle(
                    fontSize: 15,
                    color: _isRelease ? Colors.black87 : Colors.black26),
                textScaleFactor: 1),
          ],
        ),
      ],
    );
  }

  Widget _deadlineDate(WorkshopModel model, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
            "期日：${ConvertDateTime.instance.intToString(model.workshop.deadlineAt)}",
            style: TextStyle(
                fontSize: 12,
                color:
                    model.workshop.isRelease ? Colors.black87 : Colors.black26),
            textScaleFactor: 1),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(FontAwesomeIcons.calendarAlt,
              size: 20, color: Colors.black54),
          onPressed: () => _deadlineOnTap(context, model),
        ),
      ],
    );
  }

  Future<void> _deadlineOnTap(BuildContext context, WorkshopModel model) async {
    final DateTime _initDate =
        DateTime.parse(model.workshop.deadlineAt.toString());
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: _initDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 770)),
    );
    if (selected != null) {
      model.workshop.deadlineAt = ConvertDateTime.instance.dateToInt(selected);
      model.setUpdate();
    }
  }

  Widget _title(
      WorkshopModel model, _titleTextController, option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _titleTextController,
      decoration: InputDecoration(
        labelText: "研修会名",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "研修会名 を入力してください（必須）",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _titleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onSubmitted: (text) {
        model.changeValue("title", text);
        if (model.workshop.information.isEmpty) {
          final String infoTitle = "「$text」を登録しました！";
          option1TextController.text = infoTitle;
          model.changeValue("information", infoTitle);
        }
      },
    );
  }

  Widget _subTitle(WorkshopModel model, _subTitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _subTitleTextController,
      decoration: InputDecoration(
        labelText: "subTitle",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "subTitle を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _subTitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onSubmitted: (text) {
        model.changeValue("subTitle", text);
      },
    );
  }

  Widget _option1(WorkshopModel model, option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: option1TextController,
      decoration: InputDecoration(
        labelText: "インフォメーション",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "インフォメーション を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            option1TextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onSubmitted: (text) {
        model.changeValue("information", text);
      },
    );
  }

  Widget _option2(WorkshopModel model, option2TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: option2TextController,
      decoration: InputDecoration(
        labelText: "サブインフォメーション",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "サブインフォメーション を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            option2TextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onSubmitted: (text) {
        model.changeValue("subInformation", text);
      },
    );
  }

  Widget _batuButton(BuildContext context, WorkshopModel model) {
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

  Widget _saveButton(BuildContext context, WorkshopModel model) {
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

  Widget _closeButton(BuildContext context, WorkshopModel model) {
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
              label: Text("閉じる", style: cTextListM, textScaleFactor: 1),
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

  Future<void> _addProcess(BuildContext context, WorkshopModel model) async {
    DateTime _timeStamp = DateTime.now();
    model.workshop.workshopId = _timeStamp.toString();
    // model.target.targetNo =
    //     model.targets.length.toString().padLeft(4, "0"); //questionId
    try {
      model.startLoading();
      await model.addWorkshopFs(groupName, _timeStamp);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(
        context,
        "登録完了しました",
        Colors.black,
      );
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
      model.stopLoading();
    }
  }

  bool _checkValue(WorkshopModel model) {
    bool _result = false;
    _result = model.workshop.title.isNotEmpty ? true : _result;
    _result = model.workshop.subTitle.isNotEmpty ? true : _result;
    _result = model.workshop.information.isNotEmpty ? true : _result;
    _result = model.workshop.subInformation.isNotEmpty ? true : _result;
    _result = model.workshop.option3.isNotEmpty ? true : _result;
    return _result;
  }
}
