import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/auth_model.dart';
import 'package:motokosan/auth/signout.dart';
import 'package:motokosan/data/group_data/group_data.dart';
import 'package:motokosan/data/user_data/userdata_body.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
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
    _userData = widget._userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color _iconColor = Colors.green[800];
    final GroupData _groupData =
        Provider.of<AuthModel>(context, listen: false).groupData;
    final bool _showGroupData =
        _groupData.email == _userData.userEmail ? true : false;
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
                        color: _iconColor,
                      ),
                      SizedBox(height: 5),
                      if (isEdit)
                        Icon(
                          FontAwesomeIcons.caretDown,
                          color: _iconColor,
                        ),
                      if (!isEdit)
                        Icon(
                          FontAwesomeIcons.caretRight,
                          color: _iconColor,
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
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(3.0),
                        ),
                        color: Colors.grey[100],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _userDataRow(
                            "UID：",
                            _userData.uid,
                            cTextListSS,
                          ),
                          _userDataRow(
                            "グループ：",
                            _userData.userGroup,
                            cTextListSS,
                          ),
                          _userDataRow(
                            "ユーザー名：",
                            _userData.userName,
                            cTextListSS,
                          ),
                          _userDataRow(
                            "e-mail：",
                            _userData.userEmail,
                            cTextListSS,
                          ),
                          _userDataRow(
                            "グループコード:",
                            _groupData.groupCode,
                            cTextListSS,
                          ),
                          if (_showGroupData && isEdit)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  color: Colors.grey,
                                  height: 5,
                                  thickness: 2,
                                ),
                                _userDataRow(
                                  "group_email :",
                                  _groupData.email,
                                  cTextListSSR,
                                ),
                                _userDataRow(
                                  "group_password :",
                                  _groupData.password,
                                  cTextListSSR,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isEdit)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RaisedButton.icon(
                          icon: const Icon(
                            FontAwesomeIcons.userEdit,
                            size: 15,
                            color: Colors.white,
                          ),
                          label: const Text(
                            ' ユーザー名を変更',
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
                                mainTitle: "ユーザー名を入力してください",
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
                                      "ユーザー名が空欄です！",
                                      Colors.red,
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
      ],
    );
  }

  Widget _userDataRow(String label, String data, TextStyle style) {
    return Row(
      children: [
        Text(label, style: style, textScaleFactor: 1),
        Text(data, style: style, textScaleFactor: 1),
      ],
    );
  }
}
