import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/constants.dart';

class PasswordText extends StatefulWidget {
  final TextEditingController textEditingController;

  PasswordText({this.textEditingController});

  @override
  _PasswordTextState createState() => _PasswordTextState();
}

class _PasswordTextState extends State<PasswordText> {
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: cTextListL,
      obscureText: _passwordHide,
      keyboardType: TextInputType.text,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        hintText: "password",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
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
      ),
      autofocus: true,
    );
  }
}
