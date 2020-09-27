import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/target/target_model.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'category_model.dart';

class CategoryEdit extends StatelessWidget {
  final String groupName;
  final Category _category;
  final Target _target;
  CategoryEdit(this.groupName, this._category, this._target);

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

    return Consumer<CategoryModel>(builder: (context, model, child) {
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
                    model.category.title = titleTextController.text;
                    model.category.subTitle = subTitleTextController.text;
                    model.category.option1 = option1TextController.text;
                    model.category.option2 = option2TextController.text;
                    model.category.option3 = option3TextController.text;
                    model.category.categoryId = _category.categoryId;
                    model.category.categoryNo = _category.categoryNo;
                    model.category.createAt = _category.createAt;
                    model.category.updateAt = _category.updateAt;
                    model.startLoading();
                    try {
                      await model.updateCategoryFs(groupName, DateTime.now());
                      await model.fetchCategory(groupName);
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
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator())),
          ],
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
                flex: 3,
                child: Text("${_target.title} ＞",
                    style: cTextUpBarL, textScaleFactor: 1)),
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

  Widget _number(CategoryModel model) {
    return Text("${_category.categoryNo}");
  }

  Widget _title(CategoryModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _subTitle(CategoryModel model, _subTitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _option1(CategoryModel model, _option1TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _option2(CategoryModel model, _option2TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _option3(CategoryModel model, _option3TextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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
}
