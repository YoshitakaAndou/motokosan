import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class GroupPasswordInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;

  GroupPasswordInput({
    this.textEditingController,
    this.hintText,
  });

  @override
  _GroupPasswordInputState createState() => _GroupPasswordInputState();
}

class _GroupPasswordInputState extends State<GroupPasswordInput> {
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: cTextListL,
      obscureText: _passwordHide,
      keyboardType: TextInputType.text,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        hintText: widget.hintText,
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
