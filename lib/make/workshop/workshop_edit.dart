import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motokosan/buttons/white_button.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_firebase.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../take_a_lecture/workshop/workshop_model.dart';
import '../../widgets/show_dialog.dart';
import '../../constants.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'dart:async';

class WorkshopEdit extends StatelessWidget {
  final String groupName;
  final Workshop workshop;
  final Organizer organizer;
  WorkshopEdit(
    this.groupName,
    this.workshop,
    this.organizer,
  );

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = workshop.title;
    subTitleTextController.text = workshop.subTitle;
    option1TextController.text = workshop.information;
    option2TextController.text = workshop.subInformation;
    option3TextController.text = workshop.option3;

    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("研修会の編集", style: cTextTitleL, textScaleFactor: 1),
          leading: _batuButton(
            context,
            model,
            titleTextController,
            subTitleTextController,
            option1TextController,
            option2TextController,
            option3TextController,
          ),
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
                      _releaseDateArea(context, model),
                      _title(model, titleTextController),
                      _subTitle(model, subTitleTextController),
                      _option1(model, option1TextController),
                      _option2(model, option2TextController),
                      // _option3(model, option3TextController),
                      _examArea(context, model),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _delButton(context, model),
                model.isUpdate
                    ? _saveButton(
                        context,
                        model,
                        titleTextController,
                        subTitleTextController,
                        option1TextController,
                        option2TextController,
                        option3TextController,
                      )
                    : _closeButton(context, model),
              ],
            ),
          ),
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
              child: Text("　番号：${workshop.workshopNo}",
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

  Widget _releaseDateArea(BuildContext context, WorkshopModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _switchRelease(context, model),
        _deadlineDate(context, model),
      ],
    );
  }

  Widget _switchRelease(BuildContext context, WorkshopModel model) {
    final _okSwitch = workshop.lectureLength > 0;
    return Column(
      children: [
        Row(
          children: [
            if (_okSwitch)
              Text("登録講座 ${workshop.lectureLength}件",
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                  textScaleFactor: 1),
            if (!_okSwitch)
              Text("講座０件では公開できません！",
                  style: TextStyle(fontSize: 10, color: Colors.red),
                  textScaleFactor: 1),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Switch(
              value: workshop.isRelease,
              activeColor: Colors.green,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey,
              onChanged: (value) {
                if (workshop.lectureLength > 0) {
                  workshop.isRelease = value;
                  model.setUpdate();
                }
              },
            ),
            SizedBox(width: 20),
            Text(workshop.isRelease ? '公開する' : '非公開',
                style: TextStyle(
                    fontSize: 15,
                    color:
                        workshop.isRelease ? Colors.black87 : Colors.black26),
                textScaleFactor: 1),
          ],
        ),
      ],
    );
  }

  Widget _deadlineDate(BuildContext context, WorkshopModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("期日：${ConvertDateTime.instance.intToString(workshop.deadlineAt)}",
            style: TextStyle(
                fontSize: 12,
                color: workshop.isRelease ? Colors.black87 : Colors.black26),
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
    final DateTime _initDate = DateTime.parse(workshop.deadlineAt.toString());
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: _initDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 770)),
    );
    if (selected != null) {
      workshop.deadlineAt = ConvertDateTime.instance.dateToInt(selected);
      // model.workshop.deadlineAt = workshop.deadlineAt;
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
        hintText: "研修会名 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _titleTextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("title", text);
        model.setUpdate();
      },
    );
  }

  Widget _subTitle(WorkshopModel model, _subTitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "subTitle",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "subTitle を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _subTitleTextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: _subTitleTextController,
      onChanged: (text) {
        model.changeValue("subTitle", text);
        model.setUpdate();
      },
    );
  }

  Widget _option1(WorkshopModel model, _option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "インフォメーション",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "インフォメーション を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _option1TextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: _option1TextController,
      onChanged: (text) {
        model.changeValue("option1", text);
        model.setUpdate();
      },
    );
  }

  Widget _option2(WorkshopModel model, _option2TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "サブインフォメーション",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "サブインフォメーション を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _option2TextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: _option2TextController,
      onChanged: (text) {
        model.changeValue("option2", text);
        model.setUpdate();
      },
    );
  }

  // Widget _option3(WorkshopModel model, _option3TextController) {
  //   return TextField(
  //     maxLines: null,
  //     textInputAction: TextInputAction.done,
  //     keyboardType: TextInputType.text,
  //     decoration: InputDecoration(
  //       labelText: "option3",
  //       labelStyle: TextStyle(fontSize: 10),
  //       hintText: "option3 を入力してください",
  //       hintStyle: TextStyle(fontSize: 12),
  //       suffixIcon: IconButton(
  //         onPressed: () {
  //           _option3TextController.text = "";
  //           model.setUpdate();
  //         },
  //         icon: Icon(Icons.clear, size: 15),
  //       ),
  //     ),
  //     controller: _option3TextController,
  //     onChanged: (text) {
  //       model.changeValue("option3", text);
  //       model.setUpdate();
  //     },
  //   );
  // }

  Widget _examArea(BuildContext context, WorkshopModel model) {
    return Column(
      children: [
        SizedBox(height: 10),
        _switchExam(context, model),
        SizedBox(height: 10),
        if (workshop.isExam) _numOfExam(context, model),
        SizedBox(height: 10),
        if (workshop.isExam) _passingScore(context, model),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _switchExam(BuildContext context, WorkshopModel model) {
    final _okSwitch = workshop.lectureLength > 0;
    final _isMax = workshop.questionLength == workshop.numOfExam ? true : false;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("全講義受講後の修了試験",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                  textScaleFactor: 1),
              if (_okSwitch)
                Text("  登録問題 ${workshop.questionLength}問",
                    style: TextStyle(
                        fontSize: 10,
                        color: _isMax ? Colors.red : Colors.black87),
                    textScaleFactor: 1),
              if (!_okSwitch)
                Text("0問では実施できません！",
                    style: TextStyle(fontSize: 10, color: Colors.red),
                    textScaleFactor: 1),
              SizedBox(width: 20),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Switch(
                value: workshop.isExam,
                activeColor: Colors.green,
                activeTrackColor: Colors.grey,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
                onChanged: (value) {
                  if (workshop.questionLength > 0) {
                    workshop.isExam = value;
                    model.setUpdate();
                  }
                },
              ),
              Text(workshop.isExam ? '実施する' : '実施しない',
                  style: TextStyle(
                      fontSize: 15,
                      color: workshop.isExam ? Colors.black87 : Colors.black26),
                  textScaleFactor: 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numOfExam(BuildContext context, WorkshopModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("修了試験の問題数 :", style: cTextListM, textScaleFactor: 1),
        Container(
          child: _numCounter(
            initNum: workshop.numOfExam,
            pressedMinus: () {
              if (workshop.numOfExam > 1) {
                workshop.numOfExam -= 1;
                model.setUpdate();
              }
            },
            pressedPlus: () {
              if (workshop.numOfExam < workshop.questionLength) {
                workshop.numOfExam += 1;
                model.setUpdate();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _passingScore(BuildContext context, WorkshopModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("修了試験の合格点 :", style: cTextListM, textScaleFactor: 1),
        Container(
          child: _numCounter(
            initNum: workshop.passingScore,
            pressedMinus: () {
              if (workshop.passingScore > 0) {
                workshop.passingScore -= 5;
                model.setUpdate();
              }
            },
            pressedPlus: () {
              if (workshop.passingScore < 100) {
                workshop.passingScore += 5;
                model.setUpdate();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _numCounter(
      {int initNum, Function pressedMinus, Function pressedPlus}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.minusCircle),
            onPressed: pressedMinus,
          ),
        ),
        Container(
          width: 50,
          child: Text("$initNum",
              style: TextStyle(fontSize: 15, color: Colors.black87),
              textAlign: TextAlign.center,
              textScaleFactor: 1),
        ),
        Container(
          width: 50,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.plusCircle),
            onPressed: pressedPlus,
          ),
        ),
      ],
    );
  }

  Widget _batuButton(
    BuildContext context,
    WorkshopModel model,
    TextEditingController titleTextController,
    TextEditingController subTitleTextController,
    TextEditingController option1TextController,
    TextEditingController option2TextController,
    TextEditingController option3TextController,
  ) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.times, size: 20),
      onPressed: () {
        if (model.isUpdate) {
          MyDialog.instance.batuButtonDialog(
            context: context,
            mainTitle: 'このまま閉じますか？',
            subTitle: '入力した情報は破棄されます',
            yesText: '登録して閉じる',
            yesPressed: () async {
              Navigator.of(context).pop();
              await _editProcess(
                context,
                model,
                titleTextController,
                subTitleTextController,
                option1TextController,
                option2TextController,
                option3TextController,
              );
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

  Widget _saveButton(
      BuildContext context,
      WorkshopModel model,
      TextEditingController titleTextController,
      TextEditingController subTitleTextController,
      TextEditingController option1TextController,
      TextEditingController option2TextController,
      TextEditingController option3TextController) {
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
                titleTextController,
                subTitleTextController,
                option1TextController,
                option2TextController,
                option3TextController,
              ),
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
      WorkshopModel model,
      TextEditingController titleTextController,
      TextEditingController subTitleTextController,
      TextEditingController option1TextController,
      TextEditingController option2TextController,
      TextEditingController option3TextController) async {
    // グリグリを回す
    model.startLoading();
    // 更新処理
    model.workshop.title = titleTextController.text;
    model.workshop.subTitle = subTitleTextController.text;
    model.workshop.information = option1TextController.text;
    model.workshop.subInformation = option2TextController.text;
    model.workshop.option3 = option3TextController.text;
    model.workshop.isRelease = workshop.isRelease;
    model.workshop.isExam = workshop.isExam;
    model.workshop.workshopId = workshop.workshopId;
    model.workshop.workshopNo = workshop.workshopNo;
    model.workshop.createAt = workshop.createAt;
    model.workshop.updateAt = workshop.updateAt;
    model.workshop.deadlineAt = workshop.deadlineAt;
    model.workshop.numOfExam = workshop.numOfExam;
    model.workshop.passingScore = workshop.passingScore;
    try {
      await model.updateWorkshopFs(groupName, DateTime.now());
      await model.fetchWorkshopByOrganizer(groupName, organizer.organizerId);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました", Colors.black);
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Widget _delButton(BuildContext context, WorkshopModel model) {
    return WhiteButton(
      context: context,
      title: " この主催者を削除",
      icon: FontAwesomeIcons.trashAlt,
      iconSize: 15,
      onPress: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: workshop.title,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteSave(
              context,
              model,
              workshop.organizerId,
              workshop.workshopId,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _deleteSave(BuildContext context, WorkshopModel model,
      _categoryId, workshopId) async {
    model.startLoading();
    try {
      // todo workShop以下のデータは消せていないから消す様にする
      //FsをworkshopIdで削除
      await FSWorkshop.instance.deleteData(groupName, workshopId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchWorkshopByOrganizer(groupName, organizer.organizerId);
      //頭から順にtargetNoを振る
      int _count = 1;
      for (Workshop _data in model.workshops) {
        _data.workshopNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await FSWorkshop.instance
            .setData(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchWorkshopByOrganizer(groupName, organizer.organizerId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
    }
    model.stopLoading();
  }
}
