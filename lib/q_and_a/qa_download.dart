import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ok_show_dialog.dart';
import 'qa_database_model.dart';
import '../constants.dart';
import 'qa_model.dart';

Future<Widget> qaDownload(String qasId, BuildContext context) async {
  final model = Provider.of<QaModel>(context, listen: false);
  final _database = QaDatabaseModel();
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        "FireBaseから\nデータをダウンロードします",
        textScaleFactor: 1,
        style: cTextAlertL,
      ),
      content: Text(
        "実行しますか？",
        textScaleFactor: 1,
        style: cTextAlertMes,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "はい",
            textScaleFactor: 1,
            style: cTextAlertYes,
          ),
          onPressed: () async {
            try {
              model.startLoading();
              await model.fetchQasFsCloud(qasId);
              await _database.updateQaAtQId(model.datesFb);
              model.setDatesDb(await _database.getQas());
              model.stopLoading();
              await okShowDialog(context, "登録完了しました");
              Navigator.pop(context);
            } catch (e) {
              okShowDialog(context, e.toString());
            }
          },
        ),
        FlatButton(
          child: Text(
            "いいえ",
            textScaleFactor: 1,
            style: cTextAlertNo,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
