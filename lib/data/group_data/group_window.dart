import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/auth_model.dart';
import 'package:motokosan/buttons/white_button.dart';
import 'package:motokosan/data/group_data/group_data_save_body.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import 'package:motokosan/constants.dart';
import 'package:motokosan/auth/signout.dart';
import 'group_data.dart';
import 'group_data_firebase.dart';
import 'group_password_input.dart';

class GroupWindow extends StatefulWidget {
  final double radius;
  final UserData userData;
  final Function onTap;

  GroupWindow({this.radius = 10, this.userData, this.onTap});

  @override
  _GroupWindowState createState() => _GroupWindowState();
}

class _GroupWindowState extends State<GroupWindow> {
  List<GroupData> groupDates = List();

  @override
  void dispose() {
    SignOut.instance.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Column(
        children: [
          _top(),
          Expanded(
            child: _buildBody(context),
          ),
          _bottom(context),
        ],
      ),
    );
  }

  Widget _top() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.radius),
          topRight: Radius.circular(widget.radius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          )
        ],
        color: Colors.green,
      ),
      alignment: Alignment.center,
      height: 70,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(FontAwesomeIcons.users, size: 35, color: Colors.white),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'グループを選択して下さい',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
                textScaleFactor: 1,
              ),
              Text(
                '選択するとグループコードを聞かれます',
                style: TextStyle(fontSize: 12, color: Colors.white),
                textScaleFactor: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
      future: dummySignIn(),
      builder: (context, AsyncSnapshot<List<GroupData>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Colors.black54.withOpacity(0.8),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          groupDates = snapshot.data;
          return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return _buildListItem(context, snapshot.data[i]);
              });
        }
      },
    );
  }

  Widget _buildListItem(BuildContext context, GroupData snap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          )
        ],
        ),
        child: ListTile(
          dense: true,
          title: Text(
            snap.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
            textScaleFactor: 1,
          ),
          onTap: () => _listTileOnTap(context, snap),
        ),
      ),
    );
  }

  Future<void> _listTileOnTap(
    BuildContext context,
    GroupData snap,
  ) async {
    final model = Provider.of<AuthModel>(context, listen: false);
    // グループ名をタップしたらグループコードを聞く
    await _groupCodeDialog(
      context: context,
      groupCode: '',
      mainTitle: '${snap.name}の\nグループコードを入力して下さい',
      okProcess: (String txt) async {
        if (txt.isNotEmpty) {
          // グループコードが合致した場合
          Navigator.of(context).pop();
          if (txt == snap.groupCode) {
            widget.onTap(snap.name);
            // groupDataの処理
            model.groupData = snap;
            await GroupDataSaveBody.instance.save(snap);
            Navigator.of(context).pop();
          } else {
            // グループコードが違う場合
            await MyDialog.instance.okShowDialog(
              context,
              "グループコードが違いました！",
              Colors.red,
            );
          }
        } else {
          // 入力が空白の場合
          await MyDialog.instance.okShowDialog(
            context,
            "グループコードが空白です！",
            Colors.red,
          );
        }
      },
    );
  }

  Widget _bottom(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(widget.radius),
          bottomRight: Radius.circular(widget.radius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.5, 0.5),
          )
        ],
        color: Colors.green,
      ),
      alignment: Alignment.center,
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          WhiteButton(
            context: context,
            title: '新規に作成',
            icon: FontAwesomeIcons.plusCircle,
            iconSize: 18,
            onPress: () => _groupCreateOnPressed(context),
          ),
          WhiteButton(
            context: context,
            title: '閉じる',
            icon: FontAwesomeIcons.times,
            iconSize: 18,
            onPress: () {
              // SignOut.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _groupCreateOnPressed(BuildContext context) async {
    await _addGroupDialog(
      context: context,
      mainTitle: "グループ作る作業をします",
      subTitle: "作ったグループの管理人になりますがよろしいですか？",
      onPressed: () async {
        Navigator.of(context).pop();
        await _addGroupNameDialog(
          context: context,
          name: '',
          mainTitle: "【Step1】\nグループ名称の入力",
          okProcess: (String txt) async {
            if (txt.isNotEmpty) {
              Navigator.of(context).pop();
              // groupDatesの中に同じ名前があるかチェック
              final _result = groupDates.where((e) => e.name == txt);
              if (_result.isEmpty) {
                // 同じ名前がなかったらグループコードの入力
                _addGropeCodeDialog(
                    context: context,
                    groupName: txt,
                    mainTitle: '【Step2】\nグループコードとパスワードの設定');
              } else {
                // 同じ名前があったら
                await MyDialog.instance.okShowDialog(
                  context,
                  "同じグループ名が登録済です！",
                  Colors.red,
                );
              }
            } else {
              await MyDialog.instance.okShowDialog(
                context,
                "グループ名が空欄です！",
                Colors.red,
              );
            }
          },
        );
      },
    );
  }

  Future<List<GroupData>> dummySignIn() async {
    if (!FSUserData.instance.isCurrentUserSignIn()) {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      // ダミーでsignin
      final User user = (await _auth.signInWithEmailAndPassword(
        email: 'redcross@bbb.ccc',
        password: 'ccc.bbb@ssorcder',
      ))
          .user;
      if (user != null) {
        print("ダミーでログイン完了");
        return await FSGroupData.instance.createDates();
      } else {
        throw ('ログインできませんでした！');
      }
    } else {
      print("${widget.userData.userEmail}でログイン中");
      return await FSGroupData.instance.createDates();
    }
  }

  Future<Widget> _groupCodeDialog({
    BuildContext context,
    String groupCode,
    String mainTitle,
    Function okProcess,
  }) {
    final textEditingController = TextEditingController();
    textEditingController.text = groupCode;

    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: cAlertDialogShape,
        titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Column(
          children: [
            Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
            Divider(
              height: 2,
              color: Colors.grey,
              thickness: 0.5,
            ),
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

  Future<Widget> _addGroupDialog({
    BuildContext context,
    String mainTitle,
    String subTitle,
    VoidCallback onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: Text("$subTitle", textScaleFactor: 1, style: cTextAlertMes),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("はい", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: onPressed,
          ),
          MaterialButton(
            child: Text("いいえ", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> _addGroupNameDialog({
    BuildContext context,
    String name,
    String mainTitle,
    Function okProcess,
  }) {
    final textEditController = TextEditingController();
    textEditController.text = name;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: TextField(
          style: cTextListL,
          keyboardType: TextInputType.text,
          controller: textEditController,
          decoration: InputDecoration(
            hintText: "グループ名",
            hintStyle: TextStyle(fontSize: 12),
            suffixIcon: IconButton(
              onPressed: () {
                textEditController.text = "";
              },
              icon: Icon(Icons.clear, size: 15),
            ),
          ),
          autofocus: true,
        ),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text("次へ", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: () async {
              await okProcess(textEditController.text);
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> _addGropeCodeDialog({
    BuildContext context,
    String groupName,
    String mainTitle,
  }) {
    final groupCodeEditingController = TextEditingController();
    final passwordEditingController = TextEditingController();
    groupCodeEditingController.text = '';
    passwordEditingController.text = '';
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GroupPasswordInput(
              textEditingController: groupCodeEditingController,
              hintText: "グループコード",
            ),
            SizedBox(height: 5),
            GroupPasswordInput(
              textEditingController: passwordEditingController,
              hintText: "管理用パスワード",
            ),
          ],
        ),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text("登録", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: () async {
              if (groupCodeEditingController.text.isNotEmpty &&
                  passwordEditingController.text.isNotEmpty) {
                await _saveGroupData(
                  groupName,
                  groupCodeEditingController.text.trim(),
                  passwordEditingController.text.trim(),
                );
                Navigator.pop(context);
              } else {
                if (groupCodeEditingController.text.isEmpty) {
                  await MyDialog.instance.okShowDialog(
                    context,
                    "グループコードが空欄です！",
                    Colors.red,
                  );
                } else {
                  await MyDialog.instance.okShowDialog(
                    context,
                    "管理用パスワードが空欄です！",
                    Colors.red,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveGroupData(
      String groupName, String groupCode, String password) async {
    await FirebaseFirestore.instance.collection('Groups').doc(groupName).set({
      'name': groupName,
      'groupCode': groupCode,
      'password': password,
      'email': "",
    }).catchError((onError) {
      print(onError.toString());
    });
    if (Future.value() != null) {
      isGroupCreate = true;
      createGroupName = groupName;
      setState(() {});
    }
  }
}
