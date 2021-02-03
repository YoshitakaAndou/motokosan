import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../email_model.dart';

class EmailSignupPasswordText extends StatefulWidget {
  final TextEditingController passwordController;
  final EmailModel model;

  EmailSignupPasswordText({
    this.passwordController,
    this.model,
  });

  @override
  _EmailSignupPasswordTextState createState() =>
      _EmailSignupPasswordTextState();
}

class _EmailSignupPasswordTextState extends State<EmailSignupPasswordText> {
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: _passwordHide,
      controller: widget.passwordController,
      decoration: InputDecoration(
        hintText: "password（６文字以上）",
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
        widget.model.changeValue("userPassword", text.trim());
      },
    );
  }
}
