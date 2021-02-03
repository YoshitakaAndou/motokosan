import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/home/home.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_firebase.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../workshop/workshop_page.dart';
import '../../widgets/show_dialog.dart';
import '../../data/constants.dart';
import 'organizer_add.dart';
import 'organizer_edit.dart';
import '../../take_a_lecture/organizer/organizer_model.dart';

class OrganizerPage extends StatelessWidget {
  final UserData _userData;
  OrganizerPage(this._userData);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context, listen: false);
    Future(() async {
      // model.startLoading();
      await model.fetchOrganizer(_userData.userGroup);
      // model.stopLoading();
    });
    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          leading: _backButton(context),
          title: BarTitle.instance.barTitle(context),
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _infoArea()),
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

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.home),
      onPressed: () {
        Navigator.pushReplacement(
          context,
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
    final FSOrganizer fsOrganizer = FSOrganizer();
    try {
      int _count = 1;
      for (Organizer _data in model.organizers) {
        _data.organizerNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await fsOrganizer.setData(
            false, _userData.userGroup, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchOrganizer(_userData.userGroup);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
    }
  }

  Widget _listBody(BuildContext context, OrganizerModel model) {
    return ReorderableListView(
      children: model.organizers.map(
        (_organizer) {
          return _listItem(context, model, _organizer);
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

  Widget _listItem(BuildContext context, OrganizerModel model, _organizer) {
    return Card(
      key: Key(_organizer.organizerId),
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
          title: Text("${_organizer.title}",
              style: cTextListL, textScaleFactor: 1),
          subtitle: Text("${_organizer.subTitle}",
              style: cTextListS,
              textAlign: TextAlign.center,
              textScaleFactor: 1),
          trailing: InkWell(
            onTap: () {
              // 次へ
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkshopPage(_userData, _organizer),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(3),
                child: Column(
                  children: [
                    Text("研修会", style: cTextListS, textScaleFactor: 1),
                    Icon(FontAwesomeIcons.list),
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
                builder: (context) =>
                    OrganizerEdit(_userData.userGroup, _organizer),
                fullscreenDialog: true,
              ),
            );
            await model.fetchOrganizer(_userData.userGroup);
          },
        ),
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, OrganizerModel model) {
    return FloatingActionButton.extended(
      elevation: 15,
      backgroundColor: cFAB,
      icon: Icon(FontAwesomeIcons.plus),
      label: Text(" 主催者を追加", style: cTextUpBarL, textScaleFactor: 1),
      onPressed: () async {
        model.initData();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizerAdd(_userData.userGroup),
            fullscreenDialog: true,
          ),
        );
        await model.fetchOrganizer(_userData.userGroup);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, OrganizerModel model) {
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
        child: Text("", style: cTextUpBarL, textScaleFactor: 1),
      ),
    );
  }
}
