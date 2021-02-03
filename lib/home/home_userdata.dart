import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/signout.dart';
import 'package:motokosan/user_data/userdata_body.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/show_dialog.dart';

import '../data/constants.dart';
import 'home_info_not_signin.dart';
import 'widgets/change_name_dialog.dart';

class HomeUserData extends StatefulWidget {
  final UserData _userData;
  final Function _changeUserData;
  HomeUserData(this._userData, this._changeUserData);

  @override
  _HomeUserDataState createState() => _HomeUserDataState();
}

class _HomeUserDataState extends State<HomeUserData> {
  UserData _userData = UserData();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userData = widget._userData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    isEdit = !isEdit;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.userCog,
                        color: Colors.green[800],
                      ),
                      SizedBox(height: 5),
                      if (isEdit)
                        Icon(
                          FontAwesomeIcons.caretDown,
                          color: Colors.green[800],
                        ),
                      if (!isEdit)
                        Icon(
                          FontAwesomeIcons.caretRight,
                          color: Colors.green[800],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.green),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(3.0)),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("UID：", style: cTextListSS),
                              Text("${_userData.uid}", style: cTextListSS),
                            ],
                          ),
                          Row(
                            children: [
                              Text("グループ：", style: cTextListSS),
                              Text("${_userData.userGroup}",
                                  style: cTextListSS),
                            ],
                          ),
                          Row(
                            children: [
                              Text("ユーザー：", style: cTextListSS),
                              Text("${_userData.userName}", style: cTextListSS),
                            ],
                          ),
                          Row(
                            children: [
                              Text("e-mail：", style: cTextListSS),
                              Text("${_userData.userEmail}",
                                  style: cTextListSS),
                            ],
                          ),
                          Row(
                            children: [
                              Text("password：", style: cTextListSS),
                              Text("${_userData.userPassword}",
                                  style: cTextListSS),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isEdit)
                    Column(
                      children: [
                        RaisedButton.icon(
                          icon: const Icon(
                            FontAwesomeIcons.userEdit,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: const Text(
                            ' ユーザー名称を変更',
                            style: cTextUpBarM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () async {
                            if (FSUserData.instance.isCurrentUserSignIn()) {
                              await ChangeNameDialog.instance.changeNameDialog(
                                context: context,
                                userName: _userData.userName,
                                mainTitle: "ユーザー名称を入力してください",
                                okProcess: (String txt) async {
                                  if (txt.isNotEmpty) {
                                    Navigator.pop(context);
                                    // Navigator.pop(context);
                                    if (txt != _userData.userName) {
                                      // todo FBのUSERの名前を修正
                                      _userData.userName = txt;
                                      await FSUserData.instance
                                          .setData(_userData);
                                      // todo Bodyの名前を修正
                                      await UserDataBody.instance
                                          .save(_userData);
                                      widget._changeUserData(txt);
                                      setState(() {});
                                    }
                                  } else {
                                    await MyDialog.instance.okShowDialog(
                                      context,
                                      "ユーザー名が空白です！",
                                    );
                                  }
                                },
                              );
                            } else {
                              InfoNotSignin.instance.function(
                                context,
                                "サインアウトしているので\n実行できません",
                                "サインインしますか？",
                                _userData,
                              );
                            }
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                        RaisedButton.icon(
                          icon: const Icon(
                            FontAwesomeIcons.trashAlt,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: const Text(
                            ' ユーザー情報を削除',
                            style: cTextUpBarM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () async {
                            if (FSUserData.instance.isCurrentUserSignIn()) {
                              await MyDialog.instance.okShowDialogFunc(
                                context: context,
                                mainTitle: "ユーザー情報を削除します",
                                subTitle: "クラウドに登録されている全情報が消去されますがよろしいですか？",
                                onPressed: () async {
                                  print("ユーザー情報を削除しました！！　まだしていないよ");
                                  SignOut.instance.signOut();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              );
                            } else {
                              InfoNotSignin.instance.function(
                                context,
                                "サインアウトしているので\n実行できません",
                                "サインインしますか？",
                                _userData,
                              );
                            }
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        if (_userData.userName == "${_userData.userGroup}の素子です")
          FutureBuilder(
            future: UserDataBody.instance.loadUserData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container();
              }
              if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Icon(
                          FontAwesomeIcons.mobileAlt,
                          color: Colors.deepOrange,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.deepOrange),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(3.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("UID：${snapshot.data.uid}",
                                        style: cTextListSS),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("グループ：${snapshot.data.userGroup}",
                                        style: cTextListSS),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("ユーザー：${snapshot.data.userName}",
                                        style: cTextListSS),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("e-mail：${snapshot.data.userEmail}",
                                        style: cTextListSS),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        "password：${snapshot.data.userPassword}",
                                        style: cTextListSS),
                                    // Icon(
                                    //   FontAwesomeIcons.arrowRight,
                                    //   size: 15,
                                    //   color: Colors.black54,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
      ],
    );
  }
}
