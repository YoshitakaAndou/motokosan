import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../workshop_model.dart';

class WorkshopAdd extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  WorkshopAdd(this.groupName, this._organizer);

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
    option1TextController.text = model.workshop.option1;
    option2TextController.text = model.workshop.option2;
    option3TextController.text = model.workshop.option3;
    model.workshop.workshopNo =
        (model.workshops.length + 1).toString().padLeft(4, "0");
    model.workshop.deadlineAt = ConvertItems.instance.dateToInt(DateTime.now());
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      model.isEditing = _checkValue(model);
      bool _isRelease = model.workshop.isRelease;
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("研修会の新規登録", style: cTextTitleL, textScaleFactor: 1),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _switch(model, context, _isRelease),
                            _deadlineDate(model, context),
                          ],
                        ),
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
                  Text("主催：${_organizer.title}",
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
            Text("講座が０件の間は公開できません！",
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
            "期日：${ConvertItems.instance.intToString(model.workshop.deadlineAt)}",
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
      model.workshop.deadlineAt = ConvertItems.instance.dateToInt(selected);
      model.setUpdate();
    }
  }

  Widget _title(WorkshopModel model, _titleTextController) {
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
      onChanged: (text) {
        model.changeValue("title", text);
      },
      onSubmitted: (text) {
        model.changeValue("title", text);
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
      onChanged: (text) {
        model.changeValue("subTitle", text);
      },
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
      onChanged: (text) {
        model.changeValue("option1", text);
      },
      onSubmitted: (text) {
        model.changeValue("option1", text);
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
        labelText: "マーク表示",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "マーク表示 を入力してください",
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
      onSubmitted: (text) {
        model.changeValue("option2", text);
      },
    );
  }

  Widget _option3(WorkshopModel model, option3TextController) {
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
      onSubmitted: (text) {
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
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }

  bool _checkValue(WorkshopModel model) {
    bool _result = false;
    _result = model.workshop.title.isNotEmpty ? true : _result;
    _result = model.workshop.subTitle.isNotEmpty ? true : _result;
    _result = model.workshop.option1.isNotEmpty ? true : _result;
    _result = model.workshop.option2.isNotEmpty ? true : _result;
    _result = model.workshop.option3.isNotEmpty ? true : _result;
    return _result;
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
