import 'package:flutter/material.dart';
import 'package:motokosan/home/home.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_firebase.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import '../../data/constants.dart';
import '../../widgets/show_dialog.dart';
import '../lecture/lecture_page.dart';
import '../../take_a_lecture/workshop/workshop_model.dart';
import 'workshop_add.dart';
import 'workshop_edit.dart';

class WorkshopPage extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  WorkshopPage(this._userData, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    model.workshop.organizerId = _organizer.organizerId;
    model.isLoading = false;
    Future(() async {
      model.startLoading();
      await model.fetchWorkshopMake(
          _userData.userGroup, _organizer.organizerId);
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
          title: BarTitle.instance.barTitle(context),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: _infoArea(),
            ),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  _listBody(context, model),
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

  Widget _homeButton(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.home),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => Home(_userData),
          ),
        );
      },
    );
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: Text(" 研修会を編集", style: cTextUpBarL, textScaleFactor: 1)),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    // border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Text(
                            " ${_organizer.title}",
                            style: cTextUpBarS,
                            textScaleFactor: 1,
                            maxLines: 1,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.03, 0.03],
            colors: [cCardLeft, Colors.white],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          // dense: true,
          title:
              Text("${_workshop.title}", style: cTextListL, textScaleFactor: 1),
          subtitle: _subtitle(_userData.userGroup, model, _workshop),
          trailing: InkWell(
            onTap: () async {
              // Trainingへ
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LecturePage(
                    _userData,
                    _organizer,
                    _workshop,
                  ),
                ),
              );
              await model.fetchWorkshopMake(
                _userData.userGroup,
                _organizer.organizerId,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(3),
                child: Column(
                  children: [
                    Text("講　義", style: cTextListS, textScaleFactor: 1),
                    Icon(
                      FontAwesomeIcons.list,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () async {
            // Edit
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkshopEdit(
                  _userData.userGroup,
                  _workshop,
                  _organizer,
                ),
                fullscreenDialog: true,
              ),
            );
            await model.fetchWorkshopMake(
              _userData.userGroup,
              _organizer.organizerId,
            );
          },
        ),
      ),
    );
  }

  Widget _subtitle(_groupName, WorkshopModel model, Workshop _workshop) {
    bool _haveLecture = _workshop.lectureLength == 0 ? false : true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "${_workshop.isRelease ? "公開モード" : "非公開モード"}",
            style: _haveLecture ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "期日 ${ConvertItems.instance.intToString(_workshop.deadlineAt)}",
            style: _haveLecture ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "登録講座 ${_workshop.lectureLength}件",
            style: _haveLecture ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButton(BuildContext context, WorkshopModel model) {
    return FloatingActionButton.extended(
      elevation: 15,
      backgroundColor: cFAB,
      icon: Icon(FontAwesomeIcons.plus),
      label: Text(" 研修会を追加", style: cTextUpBarL, textScaleFactor: 1),
      onPressed: () async {
        model.initData(_organizer);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WorkshopAdd(_userData.userGroup, _organizer),
              fullscreenDialog: true,
            ));
        await model.fetchWorkshopMake(
            _userData.userGroup, _organizer.organizerId);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, WorkshopModel model) {
    return BottomAppBar(
      color: cContBg,
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

  Future<void> _sortedSave(BuildContext context, WorkshopModel model) async {
    try {
      int _count = 1;
      for (Workshop _data in model.workshops) {
        _data.workshopNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await FSWorkshop.instance
            .setData(false, _userData.userGroup, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchWorkshopByOrganizer(
          _userData.userGroup, _organizer.organizerId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
    }
  }
}
