import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/organizer/play/organizer_firebase.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import '../organizer_model.dart';

class OrganizerEdit extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  OrganizerEdit(this.groupName, this._organizer);

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = _organizer.title;
    subTitleTextController.text = _organizer.subTitle;
    option1TextController.text = _organizer.option1;
    option2TextController.text = _organizer.option2;
    option3TextController.text = _organizer.option3;

    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("主催者情報の編集", style: cTextTitleL, textScaleFactor: 1),
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
              child: Text("　番号：${_organizer.organizerNo}",
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

  Widget _title(OrganizerModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "主催者:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "主催者 を入力してください",
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

  Widget _subTitle(OrganizerModel model, _subTitleTextController) {
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

  Widget _option1(OrganizerModel model, _option1TextController) {
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

  Widget _option2(OrganizerModel model, _option2TextController) {
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

  Widget _option3(OrganizerModel model, _option3TextController) {
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
    OrganizerModel model,
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
    OrganizerModel model,
    TextEditingController titleTextController,
    TextEditingController subTitleTextController,
    TextEditingController option1TextController,
    TextEditingController option2TextController,
    TextEditingController option3TextController,
  ) async {
    // グリグリを回す
    model.startLoading();
    // 更新処理
    model.organizer.title = titleTextController.text;
    model.organizer.subTitle = subTitleTextController.text;
    model.organizer.option1 = option1TextController.text;
    model.organizer.option2 = option2TextController.text;
    model.organizer.option3 = option3TextController.text;
    model.organizer.organizerId = _organizer.organizerId;
    model.organizer.organizerNo = _organizer.organizerNo;
    model.organizer.createAt = _organizer.createAt;
    model.organizer.updateAt = _organizer.updateAt;
    try {
      await model.updateOrganizerFs(groupName, DateTime.now());
      await model.fetchOrganizer(groupName);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Widget _deleteButton(BuildContext context, OrganizerModel model) {
    return FloatingActionButton.extended(
      elevation: 15,

      icon: Icon(FontAwesomeIcons.trashAlt),
      label: Text(" この主催者を削除", style: cTextUpBarM, textScaleFactor: 1),
      // todo 削除
      onPressed: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: _organizer.title,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteSave(
              context,
              model,
              _organizer.organizerId,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _deleteSave(
      BuildContext context, OrganizerModel model, _organizerId) async {
    final FSOrganizer fsOrganizer = FSOrganizer();
    model.startLoading();
    try {
      //FsをTargetIdで削除
      await model.deleteOrganizerFs(groupName, _organizerId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchOrganizer(groupName);
      //頭から順にtargetNoを振る
      int _count = 1;
      for (Organizer _data in model.organizers) {
        _data.organizerNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await fsOrganizer.setData(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchOrganizer(groupName);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
    }
    model.stopLoading();
  }
}
