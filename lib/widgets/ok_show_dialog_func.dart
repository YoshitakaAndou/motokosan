import 'package:flutter/material.dart';
import '../constants.dart';

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
      actions: <Widget>[
        FlatButton(
          child: Text("はい", textScaleFactor: 1, style: cTextAlertYes),
          onPressed: onPressed,
        ),
        FlatButton(
          child: Text("いいえ", textScaleFactor: 1, style: cTextAlertNo),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
