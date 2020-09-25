import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

Future<Widget> firework(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: 450,
        height: 300,
        child: FlareActor(
          'assets/flr/fireworks.flr',
          animation: 'fireworks',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          callback: (text) {
            Navigator.of(context).pop();
          },
        ),
      );
    },
  );
}
