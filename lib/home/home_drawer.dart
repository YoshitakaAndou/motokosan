import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/google_signin.dart';
import 'package:motokosan/auth/google_signup.dart';
import 'package:motokosan/auth/signout.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/home/home_info_not_signin.dart';
import 'package:motokosan/home/home_policy.dart';
import 'package:motokosan/home/home_userdata.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_firebase.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_database.dart';
import 'package:motokosan/make/organizer/organizer_page.dart';
import 'package:motokosan/take_a_lecture/question/question_database.dart';
import 'package:motokosan/take_a_lecture/target/target_page.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import '../data/constants.dart';

class HomeDrawer extends StatelessWidget {
  final UserData _userData;

  HomeDrawer(this._userData);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
          child: SizedBox(
            width: _size.width * 0.7,
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(FontAwesomeIcons.solidWindowClose,
                                color: Colors.white, size: 20),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text("メニュー",
                                  style: cTextUpBarLL, textScaleFactor: 1)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _size.height - 150,
                    child: ListView(
                      children: [
                        if (_userData.userName == "${_userData.userGroup}の素子です")
                          _menuItem(
                            context: context,
                            title: "データを編集",
                            icon: Icon(FontAwesomeIcons.tools,
                                color: Colors.green[800]),
                            onTap: () async {
                              if (FSUserData.instance.isCurrentUserSignIn()) {
                                Navigator.of(context).pop();
                                // model.isLoading = true;
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrganizerPage(_userData),
                                  ),
                                );
                                // await model.fetchListsInfo(_userData.userGroup);
                              } else {
                                InfoNotSignin.instance.function(
                                  context,
                                  "サインアウトしているので\n実行できません",
                                  "サインインしますか？",
                                  _userData,
                                );
                              }
                            },
                          ),
                        if (_userData.userName == "${_userData.userGroup}の素子です")
                          _menuItem(
                            context: context,
                            title: "対象を編集",
                            icon: Icon(FontAwesomeIcons.solidAddressCard,
                                color: Colors.green[800]),
                            onTap: () async {
                              if (FSUserData.instance.isCurrentUserSignIn()) {
                                Navigator.of(context).pop();
                                // model.isLoading = true;
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TargetPage(_userData),
                                  ),
                                );
                              } else {
                                InfoNotSignin.instance.function(
                                    context,
                                    "サインアウトしているので\n実行できません",
                                    "サインインしますか？",
                                    _userData);
                              }
                            },
                          ),
                        _menuItem(
                          context: context,
                          title: "再生時間を変更する",
                          icon: Icon(FontAwesomeIcons.film,
                              color: Colors.green[800]),
                          onTap: () {
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
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                        if (!FSUserData.instance.isCurrentUserSignIn())
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
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
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
                        if (FSUserData.instance.isCurrentUserSignIn())
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
                                  Navigator.of(context).pop();
                                  SignOut.instance.signOut();
                                  Navigator.of(context).pop();
                                  if (_userData.userPassword == "google認証") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GoogleSignup(),
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
                                  await DataSaveBody.instance.savePolicy(false);
                                  // todo 消す前にGraduatesが有るか調べる
                                  final List<Graduater> _graduater =
                                      await FSGraduater.instance
                                          .fetchGraduater(_userData);
                                  if (_graduater.length != 0) {
                                    for (Graduater _data in _graduater) {
                                      await FSGraduater.instance
                                          .deleteGraduater(_userData.userGroup,
                                              _data.graduaterId);
                                    }
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              );
                            } else {
                              InfoNotSignin.instance.function(
                                  context,
                                  "サインアウトしているので\n実行できません",
                                  "サインインしますか？",
                                  _userData);
                            }
                          },
                        ),
                        _menuItem(
                          context: context,
                          title: "プライバシーポリシー",
                          icon: Icon(FontAwesomeIcons.handshake,
                              color: Colors.green[800]),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return HomePolicy(
                                  mdFileName: 'privacy_policy.md',
                                );
                              },
                            );
                          },
                        ),
                        HomeUserData(
                          _userData,
                          (String txt) {
                            _userData.userName = txt;
                            model.setUpdate();
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
    });
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
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
