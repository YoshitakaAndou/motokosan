import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../email_model.dart';

class EmailSigninPasswordText extends StatefulWidget {
  final TextEditingController passwordController;
  final EmailModel model;
  final String beforePassword;

  EmailSigninPasswordText({
    this.passwordController,
    this.model,
    this.beforePassword,
  });

  @override
  _EmailSigninPasswordTextState createState() =>
      _EmailSigninPasswordTextState();
}

class _EmailSigninPasswordTextState extends State<EmailSigninPasswordText> {
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: _passwordHide,
      controller: widget.passwordController,
      decoration: InputDecoration(
        hintText: "password",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _passwordHide
                    ? FontAwesomeIcons.solidEyeSlash
                    : FontAwesomeIcons.solidEye,
                size: 15,
              ),
              onPressed: () {
                this.setState(() {
                  _passwordHide = !_passwordHide;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.clear, size: 15),
              onPressed: () {
                widget.passwordController.text = "";
              },
            )
          ],
        ),
      ),
      onChanged: (text) {
        widget.model.userData.userPassword = text.trim();
        if (widget.beforePassword != text.trim()) {
          widget.model.setIsUpdate(true);
        } else {
          widget.model.setIsUpdate(false);
        }
      },
    );
  }
}
