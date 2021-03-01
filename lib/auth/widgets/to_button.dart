import 'package:flutter/material.dart';
import 'package:motokosan/auth/auth_model.dart';

class ToButton extends StatelessWidget {
  final BuildContext context;
  final AuthModel model;
  final Widget child;
  final double elevation;
  final double height;
  final double width;
  final Function onPressed;

  ToButton({
    this.context,
    this.model,
    this.child,
    this.elevation: 10,
    this.height: 30,
    this.width,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width / 2.2,
      child: RaisedButton(
        child: child,
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
