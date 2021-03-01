import 'package:flutter/material.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'qa_database_model.dart';
import 'qa_model.dart';

class QaDb extends StatelessWidget {
  final List<QuesAns> qaFb;
  final String qasId;
  QaDb({this.qaFb, this.qasId});
  final _database = QaDatabaseModel();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QaModel>(context, listen: false);
    Future(() async {
      model.setDatesDb(await _database.getQas());
    });
    return Consumer<QaModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "本体のデータ(Q&A)",
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
                            "${model.datesDb[index].id} : ${model.datesDb[index].question}",
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
                  await model.fetchQasFsCloud(qasId);
                  await _database.updateQaAtQId(model.datesFb);
                  model.setDatesDb(await _database.getQas());
                  model.stopLoading();
                  await MyDialog.instance.okShowDialog(
                    context,
                    "登録完了しました",
                    Colors.black,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  MyDialog.instance
                      .okShowDialog(context, e.toString(), Colors.red);
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
