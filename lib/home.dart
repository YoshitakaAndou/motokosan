import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_list_page.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_model.dart';
import 'package:motokosan/take_a_lecture/target/target_page.dart';
import 'package:provider/provider.dart';
import 'auth/signup_model.dart';
import 'constants.dart';
import 'take_a_lecture/organizer/make/organizer_page.dart';
import 'widgets/bar_title.dart';

class Home extends StatelessWidget {
  final UserData userData;
  Home({this.userData});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context);
    // final _database = DatabaseModel();
    // final _databaseLec = LecDatabaseModel();
    // // const double _sizedBox = 15.0;
    // Future(() async {
    //   model.setDates(await _database.getQuizzesNotKey("○"));
    // });
    return Scaffold(
      appBar: AppBar(
        title: barTitle(context),
        centerTitle: true,
      ),
      drawer: _drawer(context),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(height: _sizedBox),
            Container(
              padding: EdgeInsets.only(bottom: 10, top: 5),
              child: Image.asset(
                "assets/images/workshop01.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  child: RaisedButton.icon(
                    icon: Icon(
                      FontAwesomeIcons.chalkboardTeacher,
                      color: Colors.white,
                    ),
                    label: Text(
                      "　研修会に参加する",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await model.fetchOrganizerList(userData.userGroup);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrganizerListPage(
                              userData.userGroup, true, model.organizerList),
                        ),
                      );
                    },
                    elevation: 10,
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    color: Colors.green,
                    splashColor: Colors.white.withOpacity(0.5),
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        child: SizedBox(
          width: 250,
          child: Drawer(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.green[600],
                    child: Center(
                      child:
                          Text("メニュー", style: cTextUpBarLL, textScaleFactor: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: ListView(
                    children: [
                      _menuItem(
                        context: context,
                        title: "対象を編集",
                        icon: Icon(FontAwesomeIcons.solidAddressCard,
                            color: Colors.green[800]),
                        onTap: () async {
                          Navigator.pop(context);
                          // model.isLoading = true;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TargetPage(groupName: userData.userGroup),
                            ),
                          );
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "データを編集",
                        icon: Icon(FontAwesomeIcons.tools,
                            color: Colors.green[800]),
                        onTap: () async {
                          Navigator.pop(context);
                          // model.isLoading = true;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrganizerPage(userData.userGroup),
                            ),
                          );
                        },
                      ),
                      // _menuItem(
                      //   context: context,
                      //   title: "受講済みをリセット",
                      //   icon: Icon(Icons.restore, color: Colors.green[800]),
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //     okShowDialogFunc(
                      //         context: context,
                      //         mainTitle: "受講済みをリセット",
                      //         subTitle: "実行しますか？",
                      //         onPressed: () async {
                      //           // await _databaseLec.resetLecAnswered("", "");
                      //           Navigator.pop(context);
                      //         });
                      //   },
                      // ),
                      Container(
                        width: double.infinity,
                        height: 70,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Icon(Icons.person)),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("グループ名：${userData.userGroup}",
                                      style: cTextListSS),
                                  Text("ユーザー名：${userData.userName}",
                                      style: cTextListSS),
                                  Text("e-mail  ：${userData.userEmail}",
                                      style: cTextListSS),
                                  Text("passWord：${userData.userPassword}",
                                      style: cTextListSS),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 5, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    BuildContext context,
    String title,
    Icon icon,
    Function onTap,
  }) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(margin: EdgeInsets.all(10.0), child: icon),
              SizedBox(width: 10),
              Text(title,
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.black, fontSize: 15.0)),
            ],
          )),
      onTap: onTap,
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color backColor;
  final Color borderColor;
  final Color textColor;
  ChoiceButton(
      {this.label,
      this.onPressed,
      this.backColor,
      this.borderColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(10),
            color: backColor),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              label,
              textScaleFactor: 1,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
