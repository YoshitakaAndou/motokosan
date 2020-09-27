import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/category/category_page.dart';
import 'package:motokosan/create_edit/target/target_model.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:motokosan/widgets/ok_show_dialog_func.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'target_add.dart';
import 'target_edit.dart';

class TargetPage extends StatelessWidget {
  final String groupName;
  TargetPage({this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TargetModel>(context, listen: false);
    model.isLoading = false;
    Future(() async {
      await model.fetchTarget(groupName);
    });
    return Consumer<TargetModel>(builder: (context, model, child) {
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
                      children: model.targets.map(
                        (_target) {
                          return Card(
                              key: Key(_target.targetId),
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
                                        "${_target.targetNo}",
                                        style: cTextListS,
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "${_target.title}",
                                        style: cTextListL,
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  "${_target.subTitle}",
                                  style: cTextListS,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1,
                                ),
                                leading: IconButton(
                                  icon: Icon(Icons.delete),
                                  iconSize: 20,
                                  onPressed: () {
                                    okShowDialogFunc(
                                        context: context,
                                        mainTitle: _target.title,
                                        subTitle: "削除しますか？",
                                        // delete
                                        onPressed: () async {
                                          await _deleteSave(
                                              context, model, _target.targetId);
                                          Navigator.pop(context);
                                        });
                                  },
                                ),
                                // Categoryへ
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
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TargetEdit(groupName, _target),
                                        fullscreenDialog: true,
                                      ));
                                  await model.fetchTarget(groupName);
                                },
                              ));
                        },
                      ).toList(),
                      onReorder: (oldIndex, newIndex) {
                        model.startLoading();
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final _target = model.targets.removeAt(oldIndex);
                        model.targets.insert(newIndex, _target);
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
            model.initData();
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TargetAdd(groupName: groupName),
                  fullscreenDialog: true,
                ));
            await model.fetchTarget(groupName);
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("　対象名を編集", style: cTextUpBarL, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, TargetModel model) async {
    try {
      int _count = 0;
      for (Target _data in model.targets) {
        print("${_data.title} [$_count]");
        _data.targetNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setTargetFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchTarget(groupName);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }

  Future<void> _deleteSave(
      BuildContext context, TargetModel model, _targetId) async {
    try {
      //FsをTargetIdで削除
      await model.deleteTargetFs(groupName, _targetId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchTarget(groupName);
      //頭から順にtargetNoを振る
      int _count = 0;
      for (Target _data in model.targets) {
        print("${_data.title} [$_count]");
        _data.targetNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setTargetFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchTarget(groupName);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }
}
