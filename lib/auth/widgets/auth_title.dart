import 'package:flutter/material.dart';

import '../../constants.dart';
import '../auth_model.dart';

class AuthTitle extends StatelessWidget {
  const AuthTitle({
    Key key,
    @required this.context,
    @required this.model,
    @required this.title,
  }) : super(key: key);

  final BuildContext context;
  final AuthModel model;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          )
        ],
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          title,
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }
}
