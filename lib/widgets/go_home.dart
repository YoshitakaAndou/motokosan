import 'package:flutter/material.dart';

Widget goHome({BuildContext context, Icon icon}) {
  return IconButton(
    icon: icon,
    iconSize: 35,
    color: Colors.black54,
    onPressed: () {
      Navigator.pushNamedAndRemoveUntil(context, "Home", (_) => false);
    },
  );
}
