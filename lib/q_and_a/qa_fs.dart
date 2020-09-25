import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/go_back_one.dart';
import '../widgets/ok_show_dialog_func.dart';
import '../widgets/ok_show_dialog.dart';
import 'qa_database_model.dart';
import '../constants.dart';
import '../q_and_a/qa_add.dart';
import '../q_and_a/qa_db.dart';
import '../q_and_a/qa_edit.dart';
import 'qa_firestore_model.dart';
import 'qa_model.dart';

class QaFs extends StatelessWidget {
  final String qasId;

  QaFs({this.qasId});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QaModel>(context, listen: false);
    final _database = QaDatabaseModel();
    Future(() async {
      await model.fetchQasFsCloud(qasId);
    });
    return Consumer<QaModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Cloud上のデータ(Q&A)",
            style: cTextTitleL,
            textScaleFactor: 1,
          ),
          leading: goBackOne(context: context, icon: Icon(Icons.home)),
          actions: [
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
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: model.datesFb.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 15,
                      child: ListTile(
                        title: Text(
                          "${model.datesFb[index].question}",
                          style: cTextListM,
                          textScaleFactor: 1,
                        ),
                        trailing: Icon(Icons.edit, size: 18),
                        //todo Edit
                        onTap: () async {
                          model.initBeforeEditing(model.datesFb[index]);
                          model.resetUpdate();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QaEdit(model.datesFb[index], qasId)));
                          await model.fetchQasFsCloud(qasId);
                        },
                        // delete
                        onLongPress: () {
                          okShowDialogFunc(
                            context: context,
                            mainTitle: model.datesFb[index].question,
                            subTitle: "削除しますか？",
                            onPressed: () async {
                              try {
                                model.startLoading();
                                await model.deleteQaAtFsCloud(
                                    qasId, model.datesFb[index].qaId);
                                await deleteStorage(
                                    model.datesFb[index].imageUrl);
                                model.setImageUpType(ImageUpType.DELETE);
                                await _database
                                    .deleteQaQid(model.datesFb[index].qaId);
                                model.setDatesDb(await _database.getQas());
                                model.setDates(await _database.getQas());
                                await model.fetchQasFsCloud(qasId);
                                model.stopLoading();
                                Navigator.pop(context);
                              } catch (e) {
                                okShowDialog(context, e.toString());
                              }
                            },
                          );
                        },
                      ),
                    );
                  }),
            ),
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
                title: Text(
                  "Cloud",
                  style: TextStyle(fontSize: 10),
                  textScaleFactor: 1,
                ),
                icon: Icon(Icons.cloud),
              ),
              BottomNavigationBarItem(
                title: Text(
                  "本体",
                  style: TextStyle(fontSize: 10),
                  textScaleFactor: 1,
                ),
                icon: Icon(Icons.phone_android),
              ),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QaDb(
                              qaFb: model.datesFb,
                              qasId: qasId,
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
            model.data.category = CATEGORY01;
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QaAdd(qasId),
                  fullscreenDialog: true,
                ));
            await model.fetchQasFsCloud(qasId);
          },
        ),
      );
    });
  }
}
