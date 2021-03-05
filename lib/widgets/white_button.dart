import 'package:flutter/material.dart';

class WhiteButton extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final double iconSize;
  final Function onPress;

  WhiteButton(
      {this.context, this.title, this.icon, this.iconSize, this.onPress});

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(
        icon,
        color: Colors.white,
        size: iconSize,
      ),
      label: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: iconSize * 0.8,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1,
      ),
      color: Colors.green,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      onPressed: onPress,
    );
  }
}
