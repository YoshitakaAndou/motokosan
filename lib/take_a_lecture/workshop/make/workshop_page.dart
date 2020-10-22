import 'package:flutter/material.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../lecture/make/lecture_page.dart';
import '../../organizer/organizer_model.dart';
import '../workshop_model.dart';
import 'workshop_add.dart';
import 'workshop_edit.dart';

class WorkshopPage extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  WorkshopPage(this.groupName, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    model.workshop.organizerId = _organizer.organizerId;
    model.isLoading = false;
    Future(() async {
      model.startLoading();
      await model.fetchWorkshopByOrganizer(groupName, _organizer.organizerId);
      model.stopLoading();
    });
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          actions: [
            _homeButton(context),
          ],
          title: barTitle(context),
        ),
        body: Column(
          children: [
            _infoArea(),
            Stack(
              children: [
                Container(
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

  Widget _homeButton(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.home),
      onPressed: () {
        Navigator.pop(context);
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
            child: Text("　研修会を編集", style: cTextUpBarL, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, WorkshopModel model) async {
    try {
      int _count = 1;
      for (Workshop _data in model.workshops) {
        _data.workshopNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setWorkshopFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchWorkshopByOrganizer(groupName, _organizer.organizerId);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }

  Widget _listBody(BuildContext context, WorkshopModel model) {
    return ReorderableListView(
      children: model.workshops.map(
        (_workshop) {
          return _listItem(context, model, _workshop);
        },
      ).toList(),
      onReorder: (oldIndex, newIndex) {
        model.startLoading();
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final _target = model.workshops.removeAt(oldIndex);
        model.workshops.insert(newIndex, _target);
        _sortedSave(context, model);
        model.stopLoading();
      },
    );
  }

  Widget _listItem(
      BuildContext context, WorkshopModel model, Workshop _workshop) {
    return Card(
      key: Key(_workshop.workshopId),
      elevation: 15,
      child: ListTile(
        dense: true,
        title:
            Text("${_workshop.title}", style: cTextListL, textScaleFactor: 1),
        subtitle: Text("主催：${_organizer.title}",
            style: cTextListS, textAlign: TextAlign.center, textScaleFactor: 1),
        trailing: InkWell(
          onTap: () {
            // Trainingへ
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LecturePage(
                  groupName,
                  _organizer,
                  _workshop,
                ),
              ),
            );
          },
          child: Container(
            child: Column(
              children: [
                Text("講義を編集", style: cTextListS, textScaleFactor: 1),
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
              builder: (context) => WorkshopEdit(
                groupName,
                _workshop,
                _organizer,
              ),
              fullscreenDialog: true,
            ),
          );
          await model.fetchWorkshopByOrganizer(
            groupName,
            _organizer.organizerId,
          );
        },
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, WorkshopModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.plus),
      onPressed: () async {
        model.initData(_organizer);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkshopAdd(groupName, _organizer),
              fullscreenDialog: true,
            ));
        await model.fetchWorkshopByOrganizer(groupName, _organizer.organizerId);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, WorkshopModel model) {
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
