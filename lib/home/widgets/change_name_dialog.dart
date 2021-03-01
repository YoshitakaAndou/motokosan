import 'package:flutter/material.dart';

import '../../constants.dart';

class ChangeNameDialog {
  static final ChangeNameDialog instance = ChangeNameDialog();

  Future<Widget> changeNameDialog({
    BuildContext context,
    String userName,
    String mainTitle,
    Function okProcess,
  }) {
    final textEditController = TextEditingController();
    textEditController.text = userName;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: TextField(
          style: cTextListL,
          keyboardType: TextInputType.text,
          controller: textEditController,
          decoration: InputDecoration(
            hintText: "UserName",
            hintStyle: TextStyle(fontSize: 12),
            suffixIcon: IconButton(
              onPressed: () {
                textEditController.text = "";
              },
              icon: Icon(Icons.clear, size: 15),
            ),
          ),
          autofocus: true,
        ),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text("OK", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: () {
              okProcess(textEditController.text);
            },
          ),
        ],
      ),
    );
  }
}
