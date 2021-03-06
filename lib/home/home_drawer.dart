import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/auth_model.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/google_login.dart';
import 'package:motokosan/auth/signout.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/data/group_data/group_password_input.dart';
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
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:motokosan/constants.dart';
import 'widgets/drawer_menu_item.dart';

class HomeDrawer extends StatefulWidget {
  final UserData userData;
  final Size size;

  HomeDrawer(
    this.userData,
    this.size,
  );

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool _isToolsShow = false;
  String _menuTitle = "メニュー";
  bool _isShowSubTitle = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
          child: SizedBox(
            width: widget.size.width >= 800
                ? widget.size.width * 0.5
                : widget.size.width * 0.8,
            child: Drawer(
              child: Column(
                children: [
                  _title(context),
                  SizedBox(
                    height: widget.size.height - 150,
                    child: ListView(
                      children: [
                        HomeUserData(
                          widget.userData,
                          (String txt) {
                            widget.userData.userName = txt;
                            model.setUpdate();
                          },
                        ),
                        DrawerMenuItem(
                          context: context,
                          title: "プライバシーポリシー",
                          icon: Icon(
                            FontAwesomeIcons.handshake,
                            color: Colors.green[800],
                          ),
                          child: Container(),
                          onTap: () => _plivacyOnTap(context),
                        ),
                        if (!FSUserData.instance.isCurrentUserSignIn())
                          DrawerMenuItem(
                            context: context,
                            title: "ログイン",
                            icon: Icon(
                              FontAwesomeIcons.signInAlt,
                              color: Colors.green[800],
                            ),
                            child: Container(),
                            onTap: () => _loginOnTap(context),
                          ),
                        if (FSUserData.instance.isCurrentUserSignIn())
                          DrawerMenuItem(
                            context: context,
                            title: "ログアウト",
                            titleSize: 14,
                            icon: Icon(
                              FontAwesomeIcons.doorOpen,
                              color: Colors.green[800],
                            ),
                            child: _isShowSubTitle
                                ? _logOutMenuSubTitle()
                                : Container(),
                            onTap: () => _logOutOnTap(context),
                          ),
                        if (_isToolsShow)
                          DrawerMenuItem(
                            context: context,
                            title: "普通のメニュに戻す",
                            icon: Icon(
                              FontAwesomeIcons.undo,
                              color: Colors.green[800],
                            ),
                            child: Container(),
                            onTap: () {
                              setState(() {
                                _isToolsShow = false;
                                _menuTitle = "メニュー";
                              });
                            },
                          ),
                        if (_isToolsShow)
                          DrawerMenuItem(
                            context: context,
                            title: "データを編集",
                            titleColor: Colors.blue[700],
                            icon: Icon(
                              FontAwesomeIcons.tools,
                              color: Colors.blue[800],
                            ),
                            child: Container(),
                            onTap: () => _editDataOnTap(context),
                          ),
                        if (_isToolsShow)
                          DrawerMenuItem(
                            context: context,
                            title: "対象を編集",
                            titleColor: Colors.blue[700],
                            icon: Icon(
                              FontAwesomeIcons.solidAddressCard,
                              color: Colors.blue[800],
                            ),
                            child: Container(),
                            onTap: () => _editTargetOnTap(context),
                          ),
                        if (_isToolsShow)
                          DrawerMenuItem(
                            context: context,
                            title: "再生時間を変更する",
                            titleColor: Colors.blue[700],
                            icon: Icon(
                              FontAwesomeIcons.film,
                              color: Colors.blue[800],
                            ),
                            child: Container(),
                            onTap: () => _editPlayTimeOnTap(context),
                          ),
                        if (_isToolsShow)
                          DrawerMenuItem(
                            context: context,
                            title: "受講済みをリセット",
                            titleColor: Colors.blue[700],
                            icon: Icon(
                              Icons.restore,
                              color: Colors.blue[800],
                            ),
                            child: Container(),
                            onTap: () => _resetLectureDataOnTap(
                                context, widget.userData),
                          ),
                        if (!_isToolsShow)
                          DrawerMenuItem(
                            context: context,
                            title: "拡張メニュー",
                            titleSize: 14,
                            icon: Icon(
                              FontAwesomeIcons.tools,
                              color: Colors.green[800],
                            ),
                            child: _isShowSubTitle
                                ? _extendMenuSubTitle()
                                : Container(),
                            onTap: () => _editToolOnTap(context),
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

  Widget _logOutMenuSubTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ログアウトすることで',
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 10,
          ),
          textScaleFactor: 1,
        ),
        Text(
          'グループの変更が行えます',
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 10,
          ),
          textScaleFactor: 1,
        ),
      ],
    );
  }

  Widget _extendMenuSubTitle() {
    return Column(
      children: [
        Text(
          'グループパスワードの',
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 10,
          ),
          textScaleFactor: 1,
        ),
        Text(
          '入力が必要になります',
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 10,
          ),
          textScaleFactor: 1,
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.green[600],
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Icon(
                FontAwesomeIcons.solidWindowClose,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(_menuTitle, style: cTextUpBarLL, textScaleFactor: 1),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Icon(
                _isShowSubTitle
                    ? FontAwesomeIcons.solidQuestionCircle
                    : FontAwesomeIcons.questionCircle,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                setState(() {
                  _isShowSubTitle = !_isShowSubTitle;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editDataOnTap(BuildContext context) async {
    if (FSUserData.instance.isCurrentUserSignIn()) {
      Navigator.of(context).pop();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrganizerPage(widget.userData),
        ),
      );
    } else {
      InfoNotSignin.instance.function(
        context,
        "ログアウトしているので\n実行できません",
        "ログインしますか？",
        widget.userData,
      );
    }
  }

  Future<void> _editTargetOnTap(BuildContext context) async {
    if (FSUserData.instance.isCurrentUserSignIn()) {
      Navigator.of(context).pop();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TargetPage(widget.userData),
        ),
      );
    } else {
      InfoNotSignin.instance.function(
        context,
        "ログアウトしているので\n実行できません",
        "ログインしますか？",
        widget.userData,
      );
    }
  }

  Future<void> _editPlayTimeOnTap(BuildContext context) async {
    MyDialog.instance.okShowDialogFunc(
      context: context,
      mainTitle: videoEndAt == 5 ? "動画を最後まで再生する" : "動画再生を5秒にする",
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
  }

  Future<void> _loginOnTap(BuildContext context) async {
    MyDialog.instance.okShowDialogFunc(
      context: context,
      mainTitle: "ログイン",
      subTitle: "実行しますか？",
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        if (widget.userData.userPassword == "google認証") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleLogin(
                userName: widget.userData.userName,
                groupName: widget.userData.userGroup,
              ),
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
  }

  Future<void> _logOutOnTap(BuildContext context) async {
    MyDialog.instance.okShowDialogFunc(
      context: context,
      mainTitle: "ログアウト",
      subTitle: "実行しますか？",
      onPressed: () {
        Navigator.of(context).pop();
        SignOut.instance.signOut();
        Navigator.of(context).pop();
        if (widget.userData.userPassword == "google認証") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleLogin(
                groupName: widget.userData.userGroup,
                userName: widget.userData.userName,
              ),
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
  }

  Future<void> _resetLectureDataOnTap(
      BuildContext context, UserData userData) async {
    if (FSUserData.instance.isCurrentUserSignIn()) {
      MyDialog.instance.okShowDialogFunc(
        context: context,
        mainTitle: "受講済みをリセット",
        subTitle: "実行しますか？",
        onPressed: () async {
          // Navigator.pop(context);
          await QuestionDatabase.instance.deleteQuestionResults();
          await LectureDatabase.instance.deleteLectureResults();
          await WorkshopDatabase.instance.deleteWorkshopResults();
          await DataSaveBody.instance.savePolicy(false);
          // todo 消す前にGraduatesが有るか調べる
          final List<Graduater> _graduater =
              await FSGraduater.instance.fetchGraduater(userData);
          if (_graduater.length != 0) {
            for (Graduater _data in _graduater) {
              await FSGraduater.instance
                  .deleteGraduater(userData.userGroup, _data.graduaterId);
            }
          }
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      );
    } else {
      InfoNotSignin.instance
          .function(context, "ログアウトしているので\n実行できません", "ログインしますか？", userData);
    }
  }

  _plivacyOnTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return HomePolicy(
          mdFileName: 'privacy_policy.md',
        );
      },
    );
  }

  Future<void> _editToolOnTap(BuildContext context) async {
    final _groupData = Provider.of<AuthModel>(context, listen: false).groupData;
    if (_groupData.email == widget.userData.userEmail) {
      setState(() {
        _isToolsShow = !_isToolsShow;
        if (_isToolsShow) {
          _menuTitle = "拡張メニュー";
        } else {
          _menuTitle = "メニュー";
        }
      });
    } else {
      await _groupPasswordInput(
        context: context,
        groupPassword: '',
        mainTitle: '${_groupData.name}の\nグループパスワードを入力して下さい',
        okProcess: (String txt) async {
          if (txt.isNotEmpty) {
            // グループパスワードが合致した場合
            if (txt == _groupData.password) {
              Navigator.of(context).pop();
              setState(() {
                _isToolsShow = true;
                _menuTitle = "拡張メニュー";
              });
            } else {
              // グループパスワードが違う場合
              await MyDialog.instance.okShowDialog(
                context,
                "グループパスワードが違いました！",
                Colors.red,
              );
            }
          } else {
            // 入力が空白の場合
            await MyDialog.instance.okShowDialog(
              context,
              "グループパスワードが空白です！",
              Colors.red,
            );
          }
        },
      );
    }
  }

  Future<Widget> _groupPasswordInput({
    BuildContext context,
    String groupPassword,
    String mainTitle,
    Function okProcess,
  }) {
    final textEditingController = TextEditingController();
    textEditingController.text = groupPassword;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: cAlertDialogShape,
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Column(
          children: [
            Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
            Divider(height: 2, color: Colors.grey, thickness: 0.5),
          ],
        ),
        content: GroupPasswordInput(
          textEditingController: textEditingController,
        ),
        elevation: 20,
        actions: <Widget>[
          RaisedButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            color: Colors.white,
            shape: cAlertDialogButtonShape,
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
            },
          ),
          RaisedButton(
            child: Text("確定", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            color: Colors.white,
            shape: cAlertDialogButtonShape,
            onPressed: () {
              okProcess(textEditingController.text);
            },
          ),
        ],
      ),
    );
  }
}
