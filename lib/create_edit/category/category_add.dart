import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/category/category_model.dart';
import 'package:motokosan/create_edit/target/target_model.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class CategoryAdd extends StatelessWidget {
  final String groupName;
  final Target _target;
  CategoryAdd(this.groupName, this._target);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CategoryModel>(context, listen: false);
    model.category.categoryNo =
        model.categories.length.toString().padLeft(4, "0");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "分類名の新規登録",
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
                color: Colors.grey.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  Widget _infoArea(CategoryModel model) {
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
    return Text("${model.category.categoryNo}");
  }

  Widget _title(CategoryModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "分類名:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "分類名 を入力してください（必須）",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(CategoryModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _option1(CategoryModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _option2(CategoryModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Widget _option3(CategoryModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
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

  Future<void> _addProcess(BuildContext context, CategoryModel model) async {
    DateTime _timeStamp = DateTime.now();
    model.category.categoryId = _timeStamp.toString();
    // model.target.targetNo =
    //     model.targets.length.toString().padLeft(4, "0"); //questionId
    try {
      model.startLoading();
      await model.addCategoryFs(groupName, _timeStamp);
      model.stopLoading();
      await okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }
}
