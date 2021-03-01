import 'package:flutter/material.dart';
import '../constants.dart';

class MyDialog {
  static final MyDialog instance = MyDialog();

  Future<Widget> okShowDialog(
    BuildContext context,
    String title,
    Color color,
  ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: color),
          ),
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

  Future<Widget> okShowDialogDouble(
    BuildContext context,
    String title,
    String subTitle,
  ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 20,
          title: Text(
            title ?? "",
            style: TextStyle(
                fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold),
            textScaleFactor: 1,
          ),
          content: Text("$subTitle", textScaleFactor: 1, style: cTextAlertMes),
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

  Future<Widget> batuButtonDialog({
    BuildContext context,
    String mainTitle,
    String subTitle,
    String yesText,
    String noText,
    Function yesPressed,
    Function noPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: Text("$subTitle", textScaleFactor: 1, style: cTextAlertMes),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text(yesText, textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: yesPressed,
          ),
          MaterialButton(
            child: Text(noText, textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: noPressed,
          ),
        ],
      ),
    );
  }
}
