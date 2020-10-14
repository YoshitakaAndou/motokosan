import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import 'target_add.dart';
import 'target_edit.dart';
import 'target_model.dart';

class TargetPage extends StatelessWidget {
  final String groupName;
  TargetPage({this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TargetModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchTarget(groupName);
      model.stopLoading();
    });
    return Consumer<TargetModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: barTitle(context),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _infoArea(),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height,
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
                                title: Text(
                                  "${_target.title}",
                                  style: cTextListL,
                                  textScaleFactor: 1,
                                ),
                                subtitle: Text(
                                  "${_target.subTitle}",
                                  style: cTextListS,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1,
                                ),
                                leading: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(FontAwesomeIcons.solidEdit),
                                      iconSize: 20,
                                      onPressed: () async {
                                        // Edit
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TargetEdit(
                                                  groupName, _target),
                                              fullscreenDialog: true,
                                            ));
                                        await model.fetchTarget(groupName);
                                      },
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(FontAwesomeIcons.trashAlt),
                                  iconSize: 20,
                                  onPressed: () {
                                    // delete
                                    okShowDialogFunc(
                                      context: context,
                                      mainTitle: _target.title,
                                      subTitle: "削除しますか？",
                                      onPressed: () async {
                                        await _deleteSave(
                                            context, model, _target.targetId);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                                onTap: () async {
                                  // Editへ
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(FontAwesomeIcons.plus),
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
          child: Container(
            height: 45,
            padding: EdgeInsets.all(10),
            child: Text(
              "",
              style: cTextUpBarL,
              textScaleFactor: 1,
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
            child: Text("　対象者リスト", style: cTextUpBarL, textScaleFactor: 1),
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
