import 'package:flutter/material.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/widgets/return_argument.dart';

class GoBack {
  static final GoBack instance = GoBack();

  Widget goBack({BuildContext context, Icon icon, String tooltip, int num}) {
    return IconButton(
      icon: icon,
      iconSize: cAppBarLBSize,
      color: cAppBarLBColor,
      tooltip: tooltip,
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

  Widget goBackWithReturnArg(
      {BuildContext context,
      Icon icon,
      int num,
      ReturnArgument returnArgument}) {
    return IconButton(
      icon: icon,
      iconSize: cAppBarLBSize,
      color: cAppBarLBColor,
      onPressed: () {
        if (num == 1) {
          Navigator.of(context).pop(returnArgument);
        }
        if (num == 2) {
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
        }
        if (num == 3) {
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
        }
        if (num == 4) {
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
        }
        if (num == 5) {
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
          Navigator.of(context).pop(returnArgument);
        }
      },
    );
  }
}
