import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/data/constants.dart';
import 'package:motokosan/widgets/show_dialog.dart';

import '../email_model.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    Key key,
    @required this.context,
    @required this.model,
  });

  final BuildContext context;
  final EmailModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            child: Text("パスワードを忘れた！",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                textScaleFactor: 1),
            onPressed: () {
              _emailDialog(
                context: context,
                model: model,
                email: model.userData.userEmail,
                mainTitle: 'パスワードのリセットリクエスト',
                okProcess: () {},
              );
            }),
      ],
    );
  }

  Future<Widget> _emailDialog(
      {BuildContext context,
      EmailModel model,
      String email,
      String mainTitle,
      Function okProcess}) {
    final emailController = TextEditingController();
    emailController.text = email;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: _mailAddressInput(context, model, emailController),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text("送る", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              await _auth.sendPasswordResetEmail(
                  email: model.userData.userEmail);
              await MyDialog.instance.okShowDialogDouble(
                context,
                "リクエストが完了しました！",
                "noreply@motokosan-a5567.firebaseapp.comから\n"
                    "${model.userData.userEmail}に\n"
                    "メールを送りました。\n\n"
                    "メールを開いてリセットを実施して下さい。",
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _mailAddressInput(BuildContext context, EmailModel model,
      TextEditingController emailController) {
    return Row(
      children: [
        Expanded(
            flex: 1, child: Icon(Icons.email, size: 20, color: Colors.black54)),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              hintText: "メールアドレス",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  emailController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.userData.userEmail = text.trim();
            },
          ),
        ),
      ],
    );
  }
}
