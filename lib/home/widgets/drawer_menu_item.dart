import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    Key key,
    @required this.context,
    @required this.title,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final Icon icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
        ),
        child: Row(
          children: <Widget>[
            Container(margin: EdgeInsets.all(10.0), child: icon),
            SizedBox(width: 10),
            Text(
              title,
              textScaleFactor: 1,
              style: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
