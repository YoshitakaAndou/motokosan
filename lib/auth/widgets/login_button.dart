import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/constants.dart';

class LoginButton extends StatelessWidget {
  final BuildContext context;
  final String label;
  final Function onPressed;
  LoginButton({this.context, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.signInAlt, color: Colors.white),
        color: Colors.green,
        label: Text(label, style: cTextUpBarL, textScaleFactor: 1),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        elevation: 15,
        onPressed: onPressed,
      ),
    );
  }
}
