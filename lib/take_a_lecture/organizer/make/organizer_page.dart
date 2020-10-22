import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../workshop/make/workshop_page.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import 'organizer_add.dart';
import 'organizer_edit.dart';
import '../organizer_model.dart';

class OrganizerPage extends StatelessWidget {
  final String groupName;
  OrganizerPage(this.groupName);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchOrganizer(groupName);
      model.stopLoading();
    });
    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          leading: _backButton(context),
          title: barTitle(context),
        ),
        body: Column(
          children: [
            _infoArea(),
            Stack(
              children: [
                Container(
                  // padding: EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height - cListOffsetH,
                  width: MediaQuery.of(context).size.width,
                  child: _listBody(context, model),
                ),
                if (model.isLoading) guriguri(context),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _floatingActionButton(context, model),
        bottomNavigationBar: _bottomAppBar(context, model),
      );
    });
  }

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.home),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("  主催者を編集", style: cTextUpBarL, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, OrganizerModel model) async {
    try {
      int _count = 1;
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

  Widget _listBody(BuildContext context, OrganizerModel model) {
    return ReorderableListView(
      children: model.organizers.map(
        (_category) {
          return _listItem(context, model, _category);
        },
      ).toList(),
      onReorder: (oldIndex, newIndex) {
        model.startLoading();
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final _target = model.organizers.removeAt(oldIndex);
        model.organizers.insert(newIndex, _target);
        _sortedSave(context, model);
        model.stopLoading();
      },
    );
  }

  Widget _listItem(BuildContext context, OrganizerModel model, _category) {
    return Card(
      key: Key(_category.organizerId),
      elevation: 15,
      child: ListTile(
        dense: true,
        title:
            Text("${_category.title}", style: cTextListL, textScaleFactor: 1),
        subtitle: Text("${_category.subTitle}",
            style: cTextListS, textAlign: TextAlign.center, textScaleFactor: 1),
        trailing: InkWell(
          onTap: () {
            // 次へ
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkshopPage(groupName, _category),
              ),
            );
          },
          child: Container(
            child: Column(
              children: [
                Text("研修会を編集", style: cTextListS, textScaleFactor: 1),
                Icon(FontAwesomeIcons.arrowRight),
              ],
            ),
          ),
        ),
        onTap: () async {
          // Edit
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizerEdit(groupName, _category),
              fullscreenDialog: true,
            ),
          );
          await model.fetchOrganizer(groupName);
        },
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, OrganizerModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.plus),
      onPressed: () async {
        model.initData();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizerAdd(groupName),
            fullscreenDialog: true,
          ),
        );
        await model.fetchOrganizer(groupName);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, OrganizerModel model) {
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
        child: Text("", style: cTextUpBarL, textScaleFactor: 1),
      ),
    );
  }
}
