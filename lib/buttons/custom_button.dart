import 'package:flutter/material.dart';

import '../data/constants.dart';

class CustomButton extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final double iconSize;
  final Function onPress;

  CustomButton(
      {this.context, this.title, this.icon, this.iconSize, this.onPress});

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(
        icon,
        color: Colors.green,
        size: iconSize,
      ),
      label: Text(title, style: cTextListM, textScaleFactor: 1),
      color: Colors.white,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      onPressed: onPress,
    );
  }
}
