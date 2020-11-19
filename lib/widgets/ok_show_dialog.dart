import 'package:flutter/material.dart';
import '../constants.dart';

class MyDialog {
  static final MyDialog instance = MyDialog();

  Future<Widget> okShowDialog(
    BuildContext context,
    String title,
  ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 20,
          title: Text(title ?? "", style: cTextListM, textScaleFactor: 1),
          actions: [
            MaterialButton(
              child: Text("OK"),
              elevation: 10,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<Widget> okShowDialogFunc({
    BuildContext context,
    String mainTitle,
    String subTitle,
    VoidCallback onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: Text("$subTitle", textScaleFactor: 1, style: cTextAlertMes),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("はい", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: onPressed,
          ),
          MaterialButton(
            child: Text("いいえ", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
