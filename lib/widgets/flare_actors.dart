import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FlareActors {
  static final FlareActors instance = FlareActors();

  Future<Widget> done(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 450,
          height: 300,
          child: FlareActor(
            'assets/flr/done.flr',
            animation: 'done',
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

  Future<Widget> firework(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final Size _size = MediaQuery.of(context).size;
        return Container(
          width: _size.width,
          height: _size.height,
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
}
