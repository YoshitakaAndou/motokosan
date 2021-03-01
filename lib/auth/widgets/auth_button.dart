import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';

class AuthButton extends StatelessWidget {
  final BuildContext context;
  final String label;
  final Function onPressed;

  AuthButton({
    this.context,
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width * 0.9,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.signInAlt, size: 20, color: Colors.white),
            SizedBox(width: 10),
            Text(label, style: cTextUpBarL, textScaleFactor: 1),
          ],
        ),
        color: Colors.green,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        elevation: 15,
        onPressed: onPressed,
      ),
    );
  }
}
