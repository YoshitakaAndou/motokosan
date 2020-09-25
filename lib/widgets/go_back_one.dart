import 'package:flutter/material.dart';

Widget goBackOne({BuildContext context, Icon icon}) {
  return IconButton(
    icon: icon,
    iconSize: 35,
    color: Colors.black54,
    onPressed: () {
      Navigator.pop(context);
    },
  );
}
