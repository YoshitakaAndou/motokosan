import 'package:flutter/material.dart';
import 'package:motokosan/make/target/target_edit.dart';
import 'package:motokosan/take_a_lecture/target/target_firebase.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/show_dialog.dart';
import '../../constants.dart';
import '../../make/target/target_add.dart';
import 'target_class.dart';
import 'target_model.dart';

class TargetPage extends StatelessWidget {
  final UserData userData;
  TargetPage(this.userData);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TargetModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchTarget(userData.userGroup);
      model.stopLoading();
    });
    return Consumer<TargetModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: BarTitle.instance.barTitle(context),
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _infoArea()),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _listBody(context, model),
                  ),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _floatingActionButton(context, model),
        bottomNavigationBar: _bottomAppBar(context, model),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("　対象を編集", style: cTextUpBarL, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, TargetModel model) async {
    try {
      int _count = 1;
      for (Target _data in model.targets) {
        print("${_data.title} [$_count]");
        _data.targetNo = (_count + 1).toString().padLeft(4, "0");
        //Fsにアップデート
        await FSTarget.instance
            .setTargetFs(false, userData.userGroup, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchTarget(userData.userGroup);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
    }
  }

  Widget _listBody(BuildContext context, TargetModel model) {
    return ReorderableListView(
      children: model.targets.map(
        (_target) {
          return _listItem(context, model, _target);
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
    );
  }

  Widget _listItem(BuildContext context, TargetModel model, Target _target) {
    return Card(
      key: Key(_target.targetId),
      elevation: 15,
      child: ListTile(
        dense: true,
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
        onTap: () async {
          // Editへ
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TargetEdit(userData.userGroup, _target),
                fullscreenDialog: true,
              ));
          await model.fetchTarget(userData.userGroup);
        },
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, TargetModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.plus),
      onPressed: () async {
        model.initData();
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TargetAdd(groupName: userData.userGroup),
              fullscreenDialog: true,
            ));
        await model.fetchTarget(userData.userGroup);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, TargetModel model) {
    return BottomAppBar(
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
    );
  }
}
