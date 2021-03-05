import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final BuildContext context;
  final String title;
  final IconData icon;
  final double iconSize;
  final double textSize;
  final Color textColor;
  final Color iconColor;
  final Color boderColor;
  final Function onPress;

  CustomButton({
    this.context,
    this.title,
    this.icon,
    this.iconSize : 15.0,
    this.textSize : 12.0,
    this.textColor: Colors.black54,
    this.iconColor: Colors.black54,
    this.boderColor: Colors.black87,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
      style: OutlinedButton.styleFrom(
        primary: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        side: BorderSide(color: boderColor),
      ),
      label: Text(title,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
          textScaleFactor: 1),
      onPressed: onPress,
    );
  }
}
