import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';

class GoBack {
  static final GoBack instance = GoBack();

  Widget goBack({BuildContext context, Icon icon, int num}) {
    return IconButton(
      icon: icon,
      iconSize: 20,
      color: Colors.black54,
      onPressed: () {
        if (num == 1) {
          Navigator.of(context).pop();
        }
        if (num == 2) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (num == 3) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (num == 4) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (num == 5) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget goBackWithReturArg(
      {BuildContext context,
      Icon icon,
      int num,
      ReturnArgument lectureArgument}) {
    return IconButton(
      icon: icon,
      iconSize: 20,
      color: Colors.black54,
      onPressed: () {
        if (num == 1) {
          Navigator.of(context).pop(lectureArgument);
        }
        if (num == 2) {
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
        }
        if (num == 3) {
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
        }
        if (num == 4) {
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
        }
        if (num == 5) {
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
          Navigator.of(context).pop(lectureArgument);
        }
      },
    );
  }
}
