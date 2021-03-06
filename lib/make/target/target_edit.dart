import 'package:flutter/material.dart';
import 'package:motokosan/widgets/white_button.dart';
import 'package:motokosan/take_a_lecture/target/target_class.dart';
import 'package:motokosan/take_a_lecture/target/target_firebase.dart';
import 'package:motokosan/take_a_lecture/target/target_model.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/show_dialog.dart';
import '../../constants.dart';

class TargetEdit extends StatelessWidget {
  final String groupName;
  final Target target;
  TargetEdit(
    this.groupName,
    this.target,
  );

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final option1TextController = TextEditingController();
    final option2TextController = TextEditingController();
    final option3TextController = TextEditingController();
    titleTextController.text = target.title;
    subTitleTextController.text = target.subTitle;
    option1TextController.text = target.option1;
    option2TextController.text = target.option2;
    option3TextController.text = target.option3;

    return Consumer<TargetModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("対象者情報の編集", style: cTextTitleL, textScaleFactor: 1),
          leading: _batuButton(
            context,
            model,
            titleTextController,
            subTitleTextController,
            option1TextController,
            option2TextController,
            option3TextController,
          ),
          // actions: [
          //   if (model.isUpdate)
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Icon(
          //         FontAwesomeIcons.pencilAlt,
          //         color: Colors.orange.withOpacity(0.5),
          //         size: 20,
          //       ),
          //     ),
          // ],
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

  Widget _infoArea(TargetModel model) {
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
              child: Text("　番号：${target.targetNo}",
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

  Widget _title(TargetModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "対象者:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "対象者 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _titleTextController.text = "";
            model.setUpdate();
            model.changeValue("title", "");
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

  Widget _subTitle(TargetModel model, _subTitleTextController) {
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

  Widget _option1(TargetModel model, _option1TextController) {
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

  Widget _option2(TargetModel model, _option2TextController) {
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

  Widget _option3(TargetModel model, _option3TextController) {
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

  Widget _batuButton(
    BuildContext context,
    TargetModel model,
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
    TargetModel model,
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

  Widget _closeButton(BuildContext context, TargetModel model) {
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
    TargetModel model,
    TextEditingController titleTextController,
    TextEditingController subTitleTextController,
    TextEditingController option1TextController,
    TextEditingController option2TextController,
    TextEditingController option3TextController,
  ) async {
    // グリグリを回す
    model.startLoading();
    // 更新処理
    model.target.title = titleTextController.text;
    model.target.subTitle = subTitleTextController.text;
    model.target.option1 = option1TextController.text;
    model.target.option2 = option2TextController.text;
    model.target.option3 = option3TextController.text;
    model.target.targetId = target.targetId;
    model.target.targetNo = target.targetNo;
    model.target.createAt = target.createAt;
    model.target.updateAt = target.updateAt;
    try {
      await model.updateTargetFs(groupName, DateTime.now());
      await model.fetchTarget(groupName);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました", Colors.black);
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Widget _delButton(BuildContext context, TargetModel model) {
    return WhiteButton(
      context: context,
      title: " この主催者を削除",
      icon: FontAwesomeIcons.trashAlt,
      iconSize: 15,
      onPress: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: target.title,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteSave(
              context,
              model,
              target.targetId,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _deleteSave(
      BuildContext context, TargetModel model, _targetId) async {
    model.startLoading();
    try {
      //FsをTargetIdで削除
      await model.deleteTargetFs(groupName, _targetId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchTarget(groupName);
      //頭から順にtargetNoを振る
      int _count = 1;
      for (Target _data in model.targets) {
        print("${_data.title} [$_count]");
        _data.targetNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await FSTarget.instance
            .setTargetFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchTarget(groupName);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
    }
    model.stopLoading();
  }
}
