import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/category/category_model.dart';
import 'package:motokosan/create_edit/target/target_model.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:motokosan/widgets/ok_show_dialog_func.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'category_add.dart';
import 'category_edit.dart';

class CategoryPage extends StatelessWidget {
  final String groupName;
  final Target _target;
  CategoryPage(this.groupName, this._target);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CategoryModel>(context, listen: false);
    model.category.targetId = _target.targetId;
    model.isLoading = false;
    Future(() async {
      await model.fetchCategory(groupName);
    });
    return Consumer<CategoryModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: barTitle(context),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _infoArea(),
                Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width,
                    child: ReorderableListView(
                      children: model.categories.map(
                        (_category) {
                          return Card(
                              key: Key(_category.categoryId),
                              elevation: 15,
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "${_category.categoryNo}",
                                        style: cTextListS,
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "${_category.title}",
                                        style: cTextListL,
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  "${_category.subTitle}",
                                  style: cTextListS,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1,
                                ),
                                leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  iconSize: 20,
                                  padding: EdgeInsets.all(2),
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
                                              _category.targetId,
                                              _category.categoryId);
                                          Navigator.pop(context);
                                        });
                                  },
                                ),
                                // Workshopへ
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  iconSize: 20,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryPage(groupName, _target),
                                        ));
                                    // await model.fetchTarget(groupName);
                                  },
                                ),
                                // Edit
                                onTap: () async {
                                  // model.initBeforeEditing(_lecture);
                                  // model.resetUpdate();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryEdit(
                                            groupName, _category, _target),
                                        fullscreenDialog: true,
                                      ));
                                  await model.fetchCategory(groupName);
                                },
                              ));
                        },
                      ).toList(),
                      onReorder: (oldIndex, newIndex) {
                        model.startLoading();
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final _target = model.categories.removeAt(oldIndex);
                        model.categories.insert(newIndex, _target);
                        _sortedSave(context, model);
                        model.stopLoading();
                      },
                    )),
              ],
            ),
          ),
          if (model.isLoading)
            Container(
                color: Colors.grey.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator())),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(Icons.add),
          onPressed: () async {
            model.initData(_target);
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryAdd(groupName, _target),
                  fullscreenDialog: true,
                ));
            await model.fetchCategory(groupName);
          },
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("", style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_target.targetNo,
                          style: cTextUpBarSS, textScaleFactor: 1),
                      Text(_target.title,
                          style: cTextUpBarS, textScaleFactor: 1),
                    ],
                  ),
                  Text(" ＞", style: cTextUpBarL, textScaleFactor: 1),
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: Text("　分類名を編集", style: cTextUpBarL, textScaleFactor: 1)),
          ],
        ),
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, CategoryModel model) async {
    try {
      int _count = 0;
      for (Category _data in model.categories) {
        print("${_data.title} [$_count]");
        _data.categoryNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setCategoryFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchCategory(groupName);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }

  Future<void> _deleteSave(
      BuildContext context, CategoryModel model, _targetId, _categoryId) async {
    try {
      //FsをTargetIdで削除
      await model.deleteCategoryFs(groupName, _targetId, _categoryId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchCategory(groupName);
      //頭から順にtargetNoを振る
      int _count = 0;
      for (Category _data in model.categories) {
        print("${_data.title} [$_count]");
        _data.categoryNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setCategoryFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchCategory(groupName);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }
}
