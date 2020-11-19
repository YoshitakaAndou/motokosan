import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/body_data.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/ok_show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../constants.dart';
import '../home/home.dart';
import 'email_model.dart';
import 'email_signup.dart';
import '../user_data/userdata_firebase.dart';
import 'google_signup.dart';

class EmailSignin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EmailModel>(context, listen: false);
    final groupController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final beforeGroup = model.userData.userGroup;
    final beforeEmail = model.userData.userEmail;
    final beforePassword = model.userData.userPassword;
    final Size _size = MediaQuery.of(context).size;

    groupController.text = model.userData.userGroup;
    emailController.text = model.userData.userEmail;
    passwordController.text = model.userData.userPassword;
    return Consumer<EmailModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: barTitle(context),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 10,
                    child: _imageArea(context, model),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _toGoogleSignIn(context, model, _size),
                        _toSignUpPage(context, model, _size),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loginTitle(context, model),
                            ListView(
                              padding: EdgeInsets.all(8),
                              shrinkWrap: true,
                              children: [
                                // _toSignUpPage(context, model),
                                _groupNameInput(context, model, groupController,
                                    beforeGroup),
                                _mailAddressInput(
                                  context,
                                  model,
                                  emailController,
                                  beforeEmail,
                                ),
                                _passwordInput(
                                  context,
                                  model,
                                  passwordController,
                                  beforePassword,
                                ),
                                SizedBox(height: 30),
                                _loginButton(context, model),
                                SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (model.isLoading)
                Container(color: Colors.black.withOpacity(0.7)),
              if (model.isLoading) Center(child: CircularProgressIndicator()),
            ]),
          ),
        );
      },
    );
  }

  Widget _imageArea(BuildContext context, EmailModel model) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.userData.userName.isNotEmpty)
            Expanded(
              child: Bubble(
                color: Color.fromRGBO(225, 255, 199, 1.0),
                nip: BubbleNip.rightBottom,
                nipWidth: 10,
                nipHeight: 5,
                alignment: Alignment.topRight,
                child: Text(
                  "${model.userData.userName}さん"
                  "\nお帰りなさい！",
                  style: TextStyle(fontSize: 15),
                  textScaleFactor: 1,
                ),
              ),
            ),
          Expanded(
            child: Image.asset("assets/images/nurse02.png",
                fit: BoxFit.fitHeight, alignment: Alignment.bottomRight),
          ),
        ],
      ),
    );
  }

  Widget _loginTitle(BuildContext context, EmailModel model) {
    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          "ログイン画面",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget _toGoogleSignIn(BuildContext context, EmailModel model, Size _size) {
    return Container(
      height: 30,
      width: _size.width / 2.2,
      child: RaisedButton.icon(
        color: Colors.white,
        icon: Icon(FontAwesomeIcons.google, size: 18, color: Colors.indigo),
        label: Text(
          "googleでログイン",
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
          textScaleFactor: 1,
        ),
        elevation: 10,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GoogleSignup(),
            ),
          );
        },
      ),
    );
  }

  Widget _toSignUpPage(BuildContext context, EmailModel model, Size _size) {
    return Container(
      height: 30,
      width: _size.width / 2.2,
      child: RaisedButton.icon(
        icon: Icon(Icons.account_box, size: 18, color: Colors.black54),
        label: Text("新規登録する→",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500),
            textScaleFactor: 1),
        color: Colors.white,
        // shape: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(5)),
        // ),
        elevation: 10,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailSignup(),
            ),
          );
        },
      ),
    );
  }

  Widget _groupNameInput(
      BuildContext context, EmailModel model, groupController, beforeGroup) {
    return Row(
      children: [
        Expanded(
            flex: 1, child: Icon(Icons.group, size: 20, color: Colors.black54)),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            controller: groupController,
            decoration: InputDecoration(
              hintText: "グループ名",
              hintStyle: TextStyle(fontSize: 12),
            ),
            onSubmitted: (text) {
              model.userData.userGroup = text;
            },
            onChanged: (text) {
              model.userData.userGroup = text;
              if (beforeGroup != text) {
                model.setIsUpdate(true);
              } else {
                model.setIsUpdate(false);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _mailAddressInput(
      BuildContext context, EmailModel model, emailController, beforeEmail) {
    return Row(
      children: [
        Expanded(
            flex: 1, child: Icon(Icons.email, size: 20, color: Colors.black54)),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            decoration: InputDecoration(
              hintText: "aaa@bbb.ccc",
              hintStyle: TextStyle(fontSize: 12),
            ),
            onChanged: (text) {
              model.userData.userEmail = text;
              if (beforeEmail != text) {
                model.setIsUpdate(true);
              } else {
                model.setIsUpdate(false);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _passwordInput(BuildContext context, EmailModel model,
      passwordController, beforePassword) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Icon(
              Icons.vpn_key,
              size: 20,
              color: Colors.black54,
            )),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "password",
              hintStyle: TextStyle(fontSize: 12),
            ),
            obscureText: true,
            onChanged: (text) {
              model.userData.userPassword = text;
              if (beforePassword != text) {
                model.setIsUpdate(true);
              } else {
                model.setIsUpdate(false);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _loginButton(BuildContext context, EmailModel model) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.signInAlt, color: Colors.white),
        color: Colors.green,
        label: Text("ログインする", style: cTextUpBarL, textScaleFactor: 1),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        elevation: 15,
        onPressed: () => _loginProcess(context, model),
      ),
    );
  }

  Future<void> _loginProcess(BuildContext context, EmailModel model) async {
    model.setIsLoading(true);
    try {
      //Authにログインしてuidを取得
      final _uid = await model.signIn();
      print("Authの_uid:$_uid");
      print("本体model.userData.uid:${model.userData.uid}");

      //本体が空だったらFSUserの情報を本体に登録
      if (model.userData.uid.isEmpty) {
        print("本体が空だった");
        model.userData = await FSUserData.instance
            .fetchUserData(_uid, model.userData.userGroup);
        await BodyData.instance.saveDataToPhone(model.userData);
      } else {
        //Authのuidと本体のuidを比較
        if (_uid != model.userData.uid) {
          print("本体と違っていた");
          model.userData = await FSUserData.instance
              .fetchUserData(_uid, model.userData.userGroup);
          //違っていたら本体に保存するか？
          await MyDialog.instance.okShowDialogFunc(
            context: context,
            mainTitle: "本体情報と違うアカウントでログインしました！",
            subTitle: "\ngroup :${model.userData.userGroup}"
                "\nname  :${model.userData.userName}"
                "\nemail :${model.userData.userEmail}\n"
                "\n本体情報を上書き保存しますか？",
            onPressed: () async {
              await BodyData.instance.saveDataToPhone(model.userData);
              Navigator.pop(context);
            },
          );
        }
      }
      await FlareActors.instance.done(context);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(model.userData),
        ),
      );
      model.setIsLoading(false);
    } catch (e) {
      model.setIsLoading(false);
      _errorMessage(context, e.toString());
    }
  }

  Future<Widget> _errorMessage(BuildContext context, String _error) async {
    if (_error.contains("invalid-email")) {
      _error = "メールアドレスの形式が間違っています！";
    }
    if (_error.contains("wrong-password")) {
      _error = "パスワードが間違っています！";
    }
    if (_error.contains("user-not-found")) {
      _error = "指定されたメールアドレスでのユーザ登録がありません！";
    }
    if (_error.contains("user-disabled")) {
      _error = "指定したユーザーが無効になっています！";
    }
    if (_error.contains("too-many-requests")) {
      _error = "指定したユーザーとしてサインインする試みが多すぎます！";
    }
    if (_error.contains("operation-not-allowed")) {
      _error = "指定したユーザのログインが許されていません！";
    }
    return await MyDialog.instance.okShowDialog(context, _error);
  }
}
