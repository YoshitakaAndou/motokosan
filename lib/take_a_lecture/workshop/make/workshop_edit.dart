import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/play/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/play/workshop_firebase.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../play/workshop_model.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import 'package:motokosan/take_a_lecture/workshop/play/workshop_class.dart';

class WorkshopEdit extends StatelessWidget {
  final String groupName;
  final Workshop _workshop;
  final Organizer _organizer;
  WorkshopEdit(this.groupName, this._workshop, this._organizer);

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = _workshop.title;
    subTitleTextController.text = _workshop.subTitle;
    option1TextController.text = _workshop.option1;
    option2TextController.text = _workshop.option2;
    option3TextController.text = _workshop.option3;
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("研修会の編集", style: cTextTitleL, textScaleFactor: 1),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.times),
            color: Colors.black87,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (model.isUpdate)
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _switch(model, context),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: _deleteButton(context, model),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: model.isUpdate
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
              child: Text("　番号：${_workshop.workshopNo}",
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

  Widget _switch(WorkshopModel model, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Switch(
          value: _workshop.isRelease,
          activeColor: Colors.green,
          activeTrackColor: Colors.grey,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey,
          onChanged: (value) {
            _workshop.isRelease = value;
            model.setUpdate();
          },
        ),
        SizedBox(width: 20),
        Text(_workshop.isRelease ? '公開する' : '非公開',
            style: TextStyle(
                fontSize: 15,
                color: _workshop.isRelease ? Colors.black87 : Colors.black26),
            textScaleFactor: 1),
      ],
    );
  }

  Widget _title(WorkshopModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "研修会名:",
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
      controller: _titleTextController,
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
        labelText: "subTitle:",
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
        labelText: "option1:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "option1 を入力してください",
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
        labelText: "option2:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "option2 を入力してください",
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

  Widget _option3(WorkshopModel model, _option3TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "option3:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "option3 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _option3TextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: _option3TextController,
      onChanged: (text) {
        model.changeValue("option3", text);
        model.setUpdate();
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
    TextEditingController option3TextController,
  ) {
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
              label: Text("やめる", style: cTextListM, textScaleFactor: 1),
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
    TextEditingController option3TextController,
  ) async {
    // グリグリを回す
    model.startLoading();
    // 更新処理
    model.workshop.title = titleTextController.text;
    model.workshop.subTitle = subTitleTextController.text;
    model.workshop.option1 = option1TextController.text;
    model.workshop.option2 = option2TextController.text;
    model.workshop.option3 = option3TextController.text;
    model.workshop.isRelease = _workshop.isRelease;
    model.workshop.workshopId = _workshop.workshopId;
    model.workshop.workshopNo = _workshop.workshopNo;
    model.workshop.createAt = _workshop.createAt;
    model.workshop.updateAt = _workshop.updateAt;
    try {
      await model.updateWorkshopFs(groupName, DateTime.now());
      await model.fetchWorkshopByOrganizer(groupName, _organizer.organizerId);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Widget _deleteButton(BuildContext context, WorkshopModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.trashAlt),
      // todo 削除
      onPressed: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: _workshop.title,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteSave(
              context,
              model,
              _workshop.organizerId,
              _workshop.workshopId,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _deleteSave(
    BuildContext context,
    WorkshopModel model,
    _categoryId,
    _workshopId,
  ) async {
    model.startLoading();
    try {
      // todo workShop以下のデータは消せていないから消す様にする
      //Fsを_workshopIdで削除
      await FSWorkshop.instance.deleteData(groupName, _workshopId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchWorkshopByOrganizer(groupName, _organizer.organizerId);
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
      await model.fetchWorkshopByOrganizer(groupName, _organizer.organizerId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
    }
    model.stopLoading();
  }
}
