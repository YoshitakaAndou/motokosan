import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/google_signin.dart';
import 'package:motokosan/auth/google_signup.dart';
import 'package:motokosan/auth/signout.dart';
import 'package:motokosan/home/home_info.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_firebase.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_database.dart';
import 'package:motokosan/take_a_lecture/organizer/make/organizer_page.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/organizer/play/organizer_firebase.dart';
import 'package:motokosan/take_a_lecture/organizer/play/organizer_list_page.dart';
import 'package:motokosan/take_a_lecture/question/play/question_database.dart';
import 'package:motokosan/take_a_lecture/target/target_page.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../user_data/userdata_class.dart';
import '../widgets/bar_title.dart';

class Home extends StatelessWidget {
  final UserData _userData;
  Home(this._userData);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final model = Provider.of<WorkshopModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchLists(_userData.userGroup);
      model.stopLoading();
    });
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: barTitle(context),
          centerTitle: true,
        ),
        drawer: _drawer(context, model),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _imageArea(context, _size),
                  // _infoArea(context, model, _size),
                  HomeInfo(_userData, model, _size),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _floatingActionButton(context, model),
        bottomNavigationBar: _bottomNavigationBar(context, _userData),
      );
    });
  }

  Future<List<Organizer>> fetchOrganizerList(String _groupName) async {
    final List<Organizer> _organizers =
        await FSOrganizer.instance.fetchDates(_groupName);
    final _organizer = Organizer(title: "指定無し");
    _organizers.insert(0, _organizer);
    return _organizers;
  }

  void _infoNotSignIn(BuildContext context, String _title, String _subTitle) {
    MyDialog.instance.okShowDialogFunc(
      context: context,
      mainTitle: _title,
      subTitle: _subTitle,
      onPressed: () {
        if (_userData.userPassword == "google認証") {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleSignup(),
            ),
          );
        } else {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailSignin(),
            ),
          );
        }
      },
    );
  }

  Widget _imageArea(BuildContext context, Size _size) {
    return Container(
      child: Image.asset(
        "assets/images/workshop01.png",
        width: _size.width,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, WorkshopModel model) {
    return FloatingActionButton.extended(
      elevation: 30,
      icon: Icon(FontAwesomeIcons.chalkboardTeacher),
      label: Text(" 研修会一覧へGo！", style: cTextUpBarL, textScaleFactor: 1),
      backgroundColor: cFAB,
      shape: cFABShape,
      onPressed: () async {
        if (FSUserData.instance.isCurrentUserSignIn()) {
          final _organizers = await fetchOrganizerList(_userData.userGroup);
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: "/home"),
              builder: (context) =>
                  OrganizerListPage(_userData, true, _organizers),
            ),
          );
          model.startLoading();
          await model.fetchLists(_userData.userGroup);
          model.stopLoading();
        } else {
          _infoNotSignIn(
              context,
              "サインアウトしているので"
                  "\n実行できません",
              "サインインしますか？");
        }
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context, UserData _userData) {
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
        padding: EdgeInsets.only(left: 15, right: 10, top: 3),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("グループ:", style: cTextUpBarS, textScaleFactor: 1),
                ),
                Expanded(
                    flex: 5,
                    child: Text("${_userData.userGroup}",
                        style: cTextUpBarS, textScaleFactor: 1)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child:
                        Text("Name:", style: cTextUpBarS, textScaleFactor: 1)),
                Expanded(
                    flex: 5,
                    child: Text("${_userData.userName}",
                        style: cTextUpBarS, textScaleFactor: 1)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child:
                        Text("Uid:", style: cTextUpBarS, textScaleFactor: 1)),
                Expanded(
                    flex: 5,
                    child: Text("${_userData.uid}",
                        style: cTextUpBarS, textScaleFactor: 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context, WorkshopModel model) {
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
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Icon(Icons.person)),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("UID：${_userData.uid}",
                                      style: cTextListSS),
                                  Text("グループ名：${_userData.userGroup}",
                                      style: cTextListSS),
                                  Text("ユーザー名：${_userData.userName}",
                                      style: cTextListSS),
                                  Text("e-mail  ：${_userData.userEmail}",
                                      style: cTextListSS),
                                  Text("passWord：${_userData.userPassword}",
                                      style: cTextListSS),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 10, color: Colors.black),
                      _menuItem(
                        context: context,
                        title: "データを編集",
                        icon: Icon(FontAwesomeIcons.tools,
                            color: Colors.green[800]),
                        onTap: () async {
                          if (FSUserData.instance.isCurrentUserSignIn()) {
                            Navigator.pop(context);
                            // model.isLoading = true;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrganizerPage(_userData),
                              ),
                            );
                            await model.fetchLists(_userData.userGroup);
                          } else {
                            _infoNotSignIn(
                                context, "サインアウトしているので\n実行できません", "サインインしますか？");
                          }
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "対象を編集",
                        icon: Icon(FontAwesomeIcons.solidAddressCard,
                            color: Colors.green[800]),
                        onTap: () async {
                          if (FSUserData.instance.isCurrentUserSignIn()) {
                            Navigator.pop(context);
                            // model.isLoading = true;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TargetPage(_userData),
                              ),
                            );
                          } else {
                            _infoNotSignIn(
                                context, "サインアウトしているので\n実行できません", "サインインしますか？");
                          }
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "再生時間を変更する",
                        icon: Icon(FontAwesomeIcons.film,
                            color: Colors.green[800]),
                        onTap: () {
                          Navigator.pop(context);
                          MyDialog.instance.okShowDialogFunc(
                              context: context,
                              mainTitle: videoEndAt == 5
                                  ? "動画を最後まで再生する"
                                  : "動画再生を5秒にする",
                              subTitle: "変更しますか？",
                              onPressed: () async {
                                if (videoEndAt == 5) {
                                  videoEndAt = 5000;
                                } else {
                                  videoEndAt = 5;
                                }
                                Navigator.pop(context);
                              });
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "サインイン",
                        icon: Icon(FontAwesomeIcons.signInAlt,
                            color: Colors.green[800]),
                        onTap: () {
                          MyDialog.instance.okShowDialogFunc(
                            context: context,
                            mainTitle: "サインイン",
                            subTitle: "実行しますか？",
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              if (_userData.userPassword == "google認証") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        GoogleSignin(userData: _userData),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmailSignin(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "サインアウト",
                        icon: Icon(FontAwesomeIcons.doorOpen,
                            color: Colors.green[800]),
                        onTap: () {
                          MyDialog.instance.okShowDialogFunc(
                            context: context,
                            mainTitle: "サインアウト",
                            subTitle: "実行しますか？",
                            onPressed: () {
                              Navigator.pop(context);
                              SignOut.instance.signOut();
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "受講済みをリセット",
                        icon: Icon(Icons.restore, color: Colors.green[800]),
                        onTap: () {
                          if (FSUserData.instance.isCurrentUserSignIn()) {
                            MyDialog.instance.okShowDialogFunc(
                              context: context,
                              mainTitle: "受講済みをリセット",
                              subTitle: "実行しますか？",
                              onPressed: () async {
                                // Navigator.pop(context);
                                await QuestionDatabase.instance
                                    .deleteQuestionResults();
                                await LectureDatabase.instance
                                    .deleteLectureResults();
                                await WorkshopDatabase.instance
                                    .deleteWorkshopResults();
                                // todo 消す前にGraduatesが有るか調べる
                                final List<Graduater> _graduater =
                                    await FSGraduater.instance
                                        .fetchGraduater(_userData);
                                if (_graduater.length != 0) {
                                  for (Graduater _data in _graduater) {
                                    await FSGraduater.instance.deleteGraduater(
                                        _userData.userGroup, _data.graduaterId);
                                  }
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            _infoNotSignIn(
                                context, "サインアウトしているので\n実行できません", "サインインしますか？");
                          }
                        },
                      ),
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

  Widget _menuItem(
      {BuildContext context, String title, Icon icon, Function onTap}) {
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
