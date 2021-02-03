import 'package:flutter/material.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/google_signup.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/show_dialog.dart';

class InfoNotSignin {
  static final InfoNotSignin instance = InfoNotSignin();

  void function(
    BuildContext context,
    String _title,
    String _subTitle,
    UserData _userData,
  ) {
    MyDialog.instance.okShowDialogFunc(
      context: context,
      mainTitle: _title,
      subTitle: _subTitle,
      onPressed: () {
        if (_userData.userPassword == "google認証") {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleSignup(),
            ),
          );
        } else {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailSignin(),
            ),
          );
        }
      },
    );
  }
}
