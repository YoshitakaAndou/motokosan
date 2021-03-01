import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import 'userdata_class.dart';

class UserDataEdit extends StatelessWidget {
  final UserData _userData;
  UserDataEdit(this._userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: cToolBarH,
        centerTitle: true,
        title: Text("ユーザー情報の編集", style: cTextTitleL, textScaleFactor: 1),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              FontAwesomeIcons.pencilAlt,
              color: Colors.orange.withOpacity(0.5),
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.green,
          child: Column(
            children: [
              _infoArea(),
              Card(
                shape: cListCardShape,
                elevation: 30,
                child: ListView(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: [
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _uid(),
                    _groupName(),
                    _userName(),
                    _email(),
                    _password(),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text("ユーザー情報を表示しています",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _uid() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "ユーザーID：",
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
              ),
              textScaleFactor: 1,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              " ${_userData.uid}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
              textScaleFactor: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupName() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "グループ名：",
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
              ),
              textScaleFactor: 1,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              " ${_userData.userGroup}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
              textScaleFactor: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userName() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.green),
        borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "ユーザー名：",
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
              ),
              textScaleFactor: 1,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              " ${_userData.userName}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
              textScaleFactor: 1,
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              FontAwesomeIcons.edit,
              color: Colors.green,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _email() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "e-mail：",
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
              ),
              textScaleFactor: 1,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              " ${_userData.userEmail}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
              textScaleFactor: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _password() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "password：",
              style: TextStyle(
                fontSize: 10,
                color: Colors.green,
              ),
              textScaleFactor: 1,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              " ${_userData.userPassword}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
              textScaleFactor: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      notchMargin: 6.0,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(
          side: BorderSide(),
        ),
      ),
      child: Container(
        height: cBottomAppBarH,
        padding: EdgeInsets.all(10),
        child: Text(
          "",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }
}
