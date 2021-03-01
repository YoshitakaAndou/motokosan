import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/user_data/userdata_class.dart';

import '../auth_model.dart';
import 'user_group.dart';

class GroupButton extends StatelessWidget {
  final BuildContext context;
  final AuthModel model;

  GroupButton({this.context, this.model});

  @override
  Widget build(BuildContext context) {
    final String _groupName = model.userData.userGroup.isEmpty
        ? 'グループ名　(tapして下さい）'
        : model.userData.userGroup;

    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.users, size: 15, color: Colors.black54),
        color: Colors.white,
        label: Text("  $_groupName",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textScaleFactor: 1),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        onPressed: () {
          _showDialog(
            context: context,
            userData: model.userData,
            onTap: (String groupName) {
              model.changeValue("userGroup", groupName);
            },
          );
        },
      ),
    );
  }

  Future<void> _showDialog(
      {BuildContext context, UserData userData, Function onTap}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return UserGroup(userData: userData, onTap: onTap);
      },
    );
  }
}
