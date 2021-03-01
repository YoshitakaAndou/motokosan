import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/auth_model.dart';
import 'package:motokosan/auth/widgets/to_button.dart';
import 'package:flutter/material.dart';

import '../email_signin.dart';

class ToSignInButton extends ToButton {
  ToSignInButton({
    BuildContext context,
    AuthModel model,
    double height,
    double width,
  }) : super(
          context: context,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(FontAwesomeIcons.signInAlt, size: 18, color: Colors.indigo),
              Text(
                "登録済みの方   ",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
                textScaleFactor: 1,
              ),
            ],
          ),
          height: height,
          width: width,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmailSignin(),
              ),
            );
          },
        );
}
