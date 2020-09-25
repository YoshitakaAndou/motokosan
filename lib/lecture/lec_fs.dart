import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/go_back_one.dart';
import '../widgets/ok_show_dialog_func.dart';
import '../widgets/ok_show_dialog.dart';
import 'lec_database_model.dart';
import 'lec_firestore_model.dart';
import 'lec_model.dart';
import '../constants.dart';
import 'lec_add.dart';
import 'lec_db.dart';
import 'lec_edit.dart';

class LecFs extends StatelessWidget {
  final String lecsId;

  LecFs({this.lecsId});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LecModel>(context, listen: false);
    final _database = LecDatabaseModel();
    model.isSorting = false;
    Future(() async {
      await model.fetchLecsFsCloud(lecsId);
    });

    return Consumer<LecModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Cloud上のデータ(講義)",
            style: cTextTitleL,
            textScaleFactor: 1,
          ),
          leading: goBackOne(context: context, icon: Icon(Icons.home)),
          actions: [
            if (!model.isSorting)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: Text(
                    "${model.datesFb.length}件   ",
                    style: cTextTitleS,
                    textScaleFactor: 1,
                  ),
                ),
              ),
            if (model.isSorting)
              IconButton(
                icon: Icon(Icons.save_alt, color: Colors.red),
                iconSize: 25,
                onPressed: () => null,
              )
          ],
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: ReorderableListView(
                  children: model.datesFb.map((_lecture) {
                    return Card(
                        key: Key(_lecture.lecNo),
                        elevation: 15,
                        child: ListTile(
                          title: Text(
                            "${_lecture.lecNo}："
                            "${_lecture.category} / "
                            "${_lecture.subcategory}",
                            style: cTextListS,
                            textScaleFactor: 1,
                          ),
                          subtitle: Text(
                            "${_lecture.lecTitle}",
                            style: cTextListM,
                            textScaleFactor: 1,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            iconSize: 25,
                            onPressed: () {
                              okShowDialogFunc(
                                context: context,
                                mainTitle: _lecture.lecTitle,
                                subTitle: "削除しますか？",
                                // delete
                                onPressed: () => _deleteSave(
                                    context, model, _database, _lecture),
                              );
                            },
                          ),
                          // Edit
                          onTap: () async {
                            model.initBeforeEditing(_lecture);
                            model.resetUpdate();
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LecEdit(_lecture, lecsId)));
                            await model.fetchLecsFsCloud(lecsId);
                          },
                        ));
                  }).toList(),
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    model.startLoading();
                    //同じカテゴリー内での移動のみOK
                    if (model.datesFb[oldIndex].category ==
                        model.datesFb[newIndex].category) {
                      final _lec = model.datesFb.removeAt(oldIndex);
                      model.datesFb.insert(newIndex, _lec);
                      _sortedSave(context, model, _database,
                          model.datesFb[oldIndex].category);
                      model.setSorting(true);
                    } else {
                      model.warningDialog(
                          context, '移動できません！', '異なるカテゴリーには無理です');
                    }
                    model.stopLoading();
                  },
                )),
            if (model.isLoading)
              Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator())),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                label: "Cloud",
                icon: Icon(Icons.cloud),
              ),
              BottomNavigationBarItem(
                label: "本体",
                icon: Icon(Icons.phone_android),
              ),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LecDb(
                              lecFb: model.datesFb,
                              lecsId: lecsId,
                            )));
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            model.initData();
            model.data.category = "医療被ばくの基本的考え方";
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LecAdd(lecsId),
                  fullscreenDialog: true,
                ));
            await model.fetchLecsFsCloud(lecsId);
          },
        ),
      );
    });
  }

  Future<void> _sortedSave(BuildContext context, LecModel model,
      LecDatabaseModel database, String category) async {
    try {
      //DBを空にする
      await database.deleteAllLec();
      //DBにdatesFbを読み込む
      await database.insertLecs(model.datesFb);
      //対象のカテゴリーのデータだけを読み込みlecNoを書き換える
      final _datesDbCate = await model.getLecCategoryDates(database, category);
      var _count = 0;
      for (Lecture _data in _datesDbCate) {
        final num = _count.toString().padLeft(4, "0");
        final _topSt = _data.lecNo.substring(0, 1);
        _data.lecNo = "$_topSt-$num";
        //updateしたデータをデータベースに保存
        await database.updateLecAtId(_data);
        //Fsにアップデート
        await lUpdateFsCloud(lecsId, _data.lecId, _data);
        _count += 1;
      }
      await model.fetchLecsFsCloud(lecsId);
      model.setDatesDb(await database.getLecs());
    } catch (e) {
      okShowDialog(context, e.toString());
    }
    //datesDbに読み込んで、同じカテゴリー内のlecNoを書き換える
  }

  Future<void> _deleteSave(BuildContext context, LecModel model,
      LecDatabaseModel _database, Lecture _lecture) async {
    try {
      model.startLoading();
      //FsCloudの削除
      await model.deleteLecAtFsCloud(lecsId, _lecture.lecId);
      //Storage画像の削除
      await lDeleteStorage(_lecture.slideUrl);
      model.setSlideUpType(SlideUpType.DELETE);
      //DBの削除
      await _database.deleteLecLecId(_lecture.lecId);
      //DBからカテゴリー内のデータ読み込み
      final _datesDbCate =
          await _database.getWhereLecsCategory(_lecture.category);
      if (_datesDbCate.length > 0) {
        //対象のカテゴリーのデータだけを読み込みlecNoを書き換える
        var _count = 0;
        for (Lecture _data in _datesDbCate) {
          final num = _count.toString().padLeft(4, "0");
          final _topSt = _data.lecNo.substring(0, 1);
          _data.lecNo = "$_topSt-$num";
          //updateしたデータをデータベースに保存
          await _database.updateLecAtId(_data);
          //Fsにアップデート
          await lUpdateFsCloud(lecsId, _data.lecId, _data);
          _count += 1;
        }
      }
      //FsCloudから読み込み
      await model.fetchLecsFsCloud(lecsId);
      model.stopLoading();
      Navigator.pop(context);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }
}
