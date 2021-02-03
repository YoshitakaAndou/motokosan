import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/buttons/white_button.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/show_dialog.dart';

import '../../data/constants.dart';
import '../signout.dart';
import 'group_data.dart';
import 'passwrod_text.dart';

class UserGroup extends StatefulWidget {
  final double radius;
  final UserData userData;
  final Function onTap;

  UserGroup({this.radius = 15, this.userData, this.onTap});

  @override
  _UserGroupState createState() => _UserGroupState();
}

class _UserGroupState extends State<UserGroup> {
  List<GroupData> groupDates = List();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SignOut.instance.signOut();
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
                '選択するとパスワードを聞かれます',
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
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(widget.radius),
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
          onTap: () async {
            // グループ名をタップしたらパスワードを聞く
            await _passwordDialog(
              context: context,
              password: '',
              mainTitle: 'パスワードを入力して下さい',
              okProcess: (String txt) async {
                if (txt.isNotEmpty) {
                  // パスワードが合致した場合
                  Navigator.of(context).pop();
                  if (txt == snap.password) {
                    widget.onTap(snap.name);
                    Navigator.of(context).pop();
                  } else {
                    // パスワードが違う場合
                    await MyDialog.instance
                        .okShowDialog(context, "passwordが違いました！");
                  }
                } else {
                  // 入力が空白の場合
                  await MyDialog.instance
                      .okShowDialog(context, "passwordが空白です！");
                }
              },
            );
          },
        ),
      ),
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
            title: '新規に作成する',
            icon: FontAwesomeIcons.plusCircle,
            iconSize: 18,
            onPress: () async {
              await _addGroupNameDialog(
                context: context,
                name: '',
                mainTitle: "Step1  グループ名称の入力",
                okProcess: (String txt) async {
                  if (txt.isNotEmpty) {
                    Navigator.of(context).pop();
                    // groupDatesの中に同じ名前があるかチェック
                    final _result = groupDates.where((e) => e.name == txt);
                    if (_result.isEmpty) {
                      // 同じ名前がなかったらパスワードの入力
                      _addPasswordDialog(
                          context: context,
                          groupName: txt,
                          mainTitle: 'Step2  Passwordの設定');
                    } else {
                      // 同じ名前があったら
                      await MyDialog.instance
                          .okShowDialog(context, "同じグループ名が登録済です！");
                    }
                  } else {
                    await MyDialog.instance
                        .okShowDialog(context, "グループ名が空白です！");
                  }
                },
              );
            },
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

  Future<void> createGroup() async {}

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
        return await createDates();
      } else {
        throw ('ログインできませんでした！');
      }
    } else {
      print("${widget.userData.userEmail}でログイン中");
      return await createDates();
    }
  }

  Future<List<GroupData>> createDates() async {
    print("${widget.userData.userEmail}でログイン中");
    final _docs = await FirebaseFirestore.instance.collection("Groups").get();
    final List<GroupData> groupDates = _docs.docs
        .map((doc) => GroupData(
              name: doc['name'] ?? "",
              password: doc['password'] ?? "",
            ))
        .toList();
    return groupDates;
  }

  Future<Widget> _passwordDialog(
      {BuildContext context,
      String password,
      String mainTitle,
      Function okProcess}) {
    final textEditingController = TextEditingController();
    textEditingController.text = password;
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: PasswordText(
          textEditingController: textEditingController,
        ),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text("確定", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: () async {
              await okProcess(textEditingController.text);
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
              // Navigator.pop(context);
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

  Future<Widget> _addPasswordDialog({
    BuildContext context,
    String groupName,
    String mainTitle,
  }) {
    final textEditingController = TextEditingController();
    textEditingController.text = '';
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("$mainTitle" ?? "", textScaleFactor: 1, style: cTextAlertL),
        content: PasswordText(
          textEditingController: textEditingController,
        ),
        elevation: 20,
        actions: <Widget>[
          MaterialButton(
            child: Text("キャンセル", textScaleFactor: 1, style: cTextAlertNo),
            elevation: 10,
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
            },
          ),
          MaterialButton(
            child: Text("登録", textScaleFactor: 1, style: cTextAlertYes),
            elevation: 10,
            onPressed: () async {
              await _saveGroupData(
                  groupName, textEditingController.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveGroupData(String groupName, String passWord) async {
    await FirebaseFirestore.instance.collection('Groups').doc(groupName).set({
      'name': groupName,
      'password': passWord,
      'email': "",
    }).catchError((onError) {
      print(onError.toString());
    });
    if (Future.value() != null) {
      setState(() {});
    }
  }
}
