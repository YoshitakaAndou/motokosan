import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final BuildContext context;
  final double hight;
  final double width;
  final double space;
  final Widget imageItem;
  final Widget textItem;
  final Widget child;
  final Function onTap;
  const DrawerItem({
    this.context,
    this.hight: 60,
    this.width: 60,
    this.space: 10,
    this.imageItem,
    this.textItem,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: hight,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(width: width, child: imageItem),
            SizedBox(width: space),
            textItem,
            SizedBox(width: space),
            child,
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
