import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../workshop/workshop_page.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import 'organizer_add.dart';
import 'organizer_edit.dart';
import 'organizer_model.dart';

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
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.home),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("主催者を編集", style: cTextTitleL, textScaleFactor: 1),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _infoArea(),
                Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ReorderableListView(
                      children: model.organizers.map(
                        (_category) {
                          return Card(
                              key: Key(_category.organizerId),
                              elevation: 15,
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  "${_category.title}",
                                  style: cTextListL,
                                  textScaleFactor: 1,
                                ),
                                subtitle: Text(
                                  "${_category.subTitle}",
                                  style: cTextListS,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1,
                                ),
                                trailing: IconButton(
                                  icon: Icon(FontAwesomeIcons.arrowRight),
                                  iconSize: 20,
                                  onPressed: () {
                                    // Workshopへ
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WorkshopPage(
                                              groupName, _category),
                                        ));
                                    // await model.fetchTarget(groupName);
                                  },
                                ),
                                onTap: () async {
                                  // Edit
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrganizerEdit(groupName, _category),
                                        fullscreenDialog: true,
                                      ));
                                  await model.fetchOrganizer(groupName);
                                },
                              ));
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
                    )),
              ],
            ),
          ),
          if (model.isLoading)
            Container(
                color: Colors.black87.withOpacity(0.8),
                child: Center(child: CircularProgressIndicator())),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(FontAwesomeIcons.plus),
          onPressed: () async {
            model.initData();
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrganizerAdd(groupName),
                  fullscreenDialog: true,
                ));
            await model.fetchOrganizer(groupName);
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("  主催者を選ぶ", style: cTextUpBarL, textScaleFactor: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("研修会 ➡️", style: cTextUpBarL, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, OrganizerModel model) async {
    try {
      int _count = 0;
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
  //
  // Future<void> _deleteSave(
  //     BuildContext context, CategoryModel model, _targetId, _categoryId) async {
  //   try {
  //     //FsをTargetIdで削除
  //     await model.deleteCategoryFs(groupName, _targetId, _categoryId);
  //     //配列を削除するのは無理だから再びFsをフェッチ
  //     await model.fetchCategory(groupName);
  //     //頭から順にtargetNoを振る
  //     int _count = 0;
  //     for (Category _data in model.categories) {
  //       _data.categoryNo = _count.toString().padLeft(4, "0");
  //       //Fsにアップデート
  //       await model.setCategoryFs(false, groupName, _data, DateTime.now());
  //       _count += 1;
  //     }
  //     //一通り終わったらFsから読み込んで再描画させる
  //     await model.fetchCategory(groupName);
  //   } catch (e) {
  //     okShowDialog(context, e.toString());
  //   }
  // }
}
