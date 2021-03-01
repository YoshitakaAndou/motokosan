import 'package:flutter/material.dart';
import 'package:motokosan/auth/auth_model.dart';

class TogoButton extends StatelessWidget {
  final BuildContext context;
  final AuthModel model;
  final Widget icon;
  final Widget label;
  final double elevation;
  final Size size;
  final Function onPressed;

  TogoButton({
    this.context,
    this.model,
    this.icon,
    this.label,
    this.elevation: 10,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: size.width / 2.2,
      child: RaisedButton.icon(
        icon: icon,
        label: label,
        color: Colors.white,
        shape: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        elevation: elevation,
        onPressed: onPressed,
      ),
    );
  }
}
