import 'package:flutter/material.dart';
import '../auth_model.dart';
import '../google_login.dart';
import 'to_button.dart';

class ToGoogleButton extends ToButton {
  ToGoogleButton({
    BuildContext context,
    AuthModel model,
    double height,
    double width,
  }) : super(
          context: context,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/icon/google-logo.png',
                height: height * 0.7,
              ),
              Text(
                "googleでログイン",
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
                builder: (context) => GoogleLogin(
                  groupName: model.userData.userGroup,
                  userName: model.userData.userName,
                ),
              ),
            );
          },
        );
}
