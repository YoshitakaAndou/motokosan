import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color backColor;
  final Color borderColor;
  final Color textColor;
  ChoiceButton(
      {this.label,
      this.onPressed,
      this.backColor,
      this.borderColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(10),
            color: backColor),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              label,
              textScaleFactor: 1,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
