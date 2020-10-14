import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import 'organizer_model.dart';

class OrganizerEdit extends StatelessWidget {
  final String groupName;
  final Organizer _category;
  OrganizerEdit(this.groupName, this._category);

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = _category.title;
    subTitleTextController.text = _category.subTitle;
    option1TextController.text = _category.option1;
    option2TextController.text = _category.option2;
    option3TextController.text = _category.option3;

    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "分類名の編集",
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
                    model.organizer.title = titleTextController.text;
                    model.organizer.subTitle = subTitleTextController.text;
                    model.organizer.option1 = option1TextController.text;
                    model.organizer.option2 = option2TextController.text;
                    model.organizer.option3 = option3TextController.text;
                    model.organizer.organizerId = _category.organizerId;
                    model.organizer.organizerNo = _category.organizerNo;
                    model.organizer.createAt = _category.createAt;
                    model.organizer.updateAt = _category.updateAt;
                    model.startLoading();
                    try {
                      await model.updateOrganizerFs(groupName, DateTime.now());
                      await model.fetchOrganizer(groupName);
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
                        _number(model),
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
                  color: Colors.black87.withOpacity(0.8),
                  child: Center(child: CircularProgressIndicator())),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(FontAwesomeIcons.trashAlt),
          onPressed: () {
            okShowDialogFunc(
              context: context,
              mainTitle: _category.title,
              subTitle: "削除しますか？",
              // delete
              onPressed: () async {
                await _deleteSave(
                  context,
                  model,
                  _category.organizerId,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
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

  Widget _number(OrganizerModel model) {
    return Text("${_category.organizerNo}");
  }

  Widget _title(OrganizerModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "Title:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "分類名 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
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

  Widget _option1(OrganizerModel model, _option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Widget _option2(OrganizerModel model, _option2TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Widget _option3(OrganizerModel model, _option3TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
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

  Future<void> _deleteSave(
      BuildContext context, OrganizerModel model, _categoryId) async {
    try {
      //FsをTargetIdで削除
      await model.deleteCategoryFs(groupName, _categoryId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchOrganizer(groupName);
      //頭から順にtargetNoを振る
      int _count = 0;
      for (Organizer _data in model.organizers) {
        _data.organizerNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setOrganizerFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchOrganizer(groupName);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }
}
