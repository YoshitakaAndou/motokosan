import 'package:flutter/material.dart';

Widget goBack({BuildContext context, Icon icon, int num}) {
  return IconButton(
    icon: icon,
    iconSize: 20,
    color: Colors.black54,
    onPressed: () {
      if (num == 1) {
        Navigator.pop(context);
      }
      if (num == 2) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if (num == 3) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if (num == 4) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
      if (num == 5) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    },
  );
}

Widget goBackWithArg({BuildContext context, Icon icon, int num, bool arg}) {
  return IconButton(
    icon: icon,
    iconSize: 20,
    color: Colors.black54,
    onPressed: () {
      if (num == 1) {
        Navigator.pop(context, arg);
      }
      if (num == 2) {
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
      }
      if (num == 3) {
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
      }
      if (num == 4) {
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
      }
      if (num == 5) {
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
        Navigator.pop(context, arg);
      }
    },
  );
}
