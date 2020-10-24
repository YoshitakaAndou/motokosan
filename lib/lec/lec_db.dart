import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ok_show_dialog.dart';
import 'lec_database_model.dart';
import 'lec_model.dart';
import '../constants.dart';

class LecDb extends StatelessWidget {
  final List<Lec> lecFb;
  final String lecsId;
  LecDb({this.lecFb, this.lecsId});
  final _database = LecDatabaseModel();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LecModel>(context, listen: false);
    Future(() async {
      model.setDatesDb(await _database.getLecs());
    });
    return Consumer<LecModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "本体のデータ(講義)",
            style: cTextTitleL,
            textScaleFactor: 1,
          ),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  "${model.datesDb.length}件   ",
                  style: cTextTitleS,
                  textScaleFactor: 1,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    height: 40,
                    color: cContBg,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "本体Db：${model.datesDb.length}件",
                            style: cTextUpBarM,
                            textScaleFactor: 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Cloud：${model.datesFb.length}件",
                            style: cTextUpBarM,
                            textScaleFactor: 1,
                          ),
                        ),
                      ],
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: MediaQuery.of(context).size.height - 250,
                  child: ListView.builder(
                    itemCount: model.datesDb.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.green)),
                        ),
                        child: ListTile(
                          title: Text(
                            "${model.datesDb[index].id} : ${model.datesDb[index].lecTitle}",
                            style: cTextListM,
                            textScaleFactor: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (model.isLoading)
              Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator())),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.cloud_download),
          onPressed: () async {
            MyDialog.instance.okShowDialogFunc(
              context: context,
              mainTitle: "Cloudから\nデータをダウンロードします",
              subTitle: "実行しますか？",
              onPressed: () async {
                try {
                  model.startLoading();
                  await _database.deleteAllLec();
                  await model.fetchLecsFsCloud(lecsId);
                  // await _database.updateLecAtLecId(model.datesFb);
                  await _database.insertLecs(model.datesFb);
                  model.setDatesDb(await _database.getLecs());
                  model.stopLoading();
                  await MyDialog.instance.okShowDialog(context, "登録完了しました");
                  Navigator.pop(context);
                } catch (e) {
                  MyDialog.instance.okShowDialog(context, e.toString());
                }
              },
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            currentIndex: 1,
            items: <BottomNavigationBarItem>[
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
              if (index == 0) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      );
    });
  }
}
