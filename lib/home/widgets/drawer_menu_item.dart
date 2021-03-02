import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    Key key,
    this.context,
    this.title,
    this.titleSize: 15.0,
    this.titleColor: Colors.black87,
    this.icon,
    this.child,
    this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final double titleSize;
  final Color titleColor;
  final Icon icon;
  final Widget child;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(margin: EdgeInsets.all(10.0), child: icon),
            SizedBox(width: 10),
            Text(
              title,
              textScaleFactor: 1,
              style: TextStyle(color: titleColor, fontSize: titleSize),
            ),
            SizedBox(width: 20),
            child,
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
