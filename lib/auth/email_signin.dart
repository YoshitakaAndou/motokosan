import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/widgets/email_signin_password_text.dart';
import 'package:motokosan/user_data/userdata_body.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../data/constants.dart';
import '../home/home.dart';
import 'email_model.dart';
import 'email_signup.dart';
import '../user_data/userdata_firebase.dart';
import 'google_signup.dart';
import 'group_button/email_group_button.dart';
import 'widgets/forgot_password.dart';
import 'widgets/login_button.dart';

class EmailSignin extends StatelessWidget {
  final String userName;
  final String groupName;
  EmailSignin({this.userName, this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EmailModel>(context, listen: false);
    final groupController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final beforeEmail = model.userData.userEmail;
    final beforePassword = model.userData.userPassword;
    final Size _size = MediaQuery.of(context).size;

    groupController.text = model.userData.userGroup;
    emailController.text = model.userData.userEmail;
    passwordController.text = model.userData.userPassword == "google認証"
        ? ""
        : model.userData.userPassword;
    return Consumer<EmailModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: BarTitle.instance.barTitle(context),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(flex: 10, child: _imageArea(context, model)),
                  Expanded(
                    flex: 3,
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
                    flex: 15,
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _loginTitle(context, model),
                            SizedBox(height: 10),
                            ListView(
                              padding:
                                  EdgeInsets.only(top: 8, left: 8, right: 8),
                              shrinkWrap: true,
                              children: [
                                EmailGroupButton(
                                    context: context, model: model),
                                SizedBox(height: 10),
                                _mailAddressInput(context, model,
                                    emailController, beforeEmail),
                                SizedBox(height: 10),
                                _passwordInput(context, model,
                                    passwordController, beforePassword),
                                ForgotPassword(
                                  context: context,
                                  model: model,
                                ),
                              ],
                            ),
                            LoginButton(
                              context: context,
                              label: 'ログインする',
                              onPressed: () {
                                _loginProcess(context, model);
                              },
                            ),
                            SizedBox(height: 20),
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
              flex: 1,
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
            flex: 1,
            child: Image.asset("assets/images/protector.png",
                fit: BoxFit.fitHeight, alignment: Alignment.bottomCenter),
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
              builder: (context) => GoogleSignup(
                groupName: model.userData.userGroup,
                userName: model.userData.userName,
              ),
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

  Widget _mailAddressInput(BuildContext context, EmailModel model,
      TextEditingController emailController, beforeEmail) {
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
              hintText: "メールアドレス",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  emailController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.userData.userEmail = text.trim();
              if (beforeEmail != text.trim()) {
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
      TextEditingController passwordController, beforePassword) {
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
          child: EmailSigninPasswordText(
            passwordController: passwordController,
            model: model,
            beforePassword: beforePassword,
          ),
        ),
      ],
    );
  }

  Future<void> _loginProcess(BuildContext context, EmailModel model) async {
    model.setIsLoading(true);
    try {
      //Authにログインしてuidを取得
      final _uid = await model.signIn();
      //本体が空だったらFSUserの情報を本体に登録
      if (model.userData.uid.isEmpty) {
        model.userData = await FSUserData.instance
            .fetchUserData(_uid, model.userData.userGroup);
        await UserDataBody.instance.save(model.userData);
      } else {
        //Authのuidと本体のuidを比較
        if (_uid != model.userData.uid) {
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
              await UserDataBody.instance.save(model.userData);
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

      // グループで未登録の場合はSignUpで新規登録してもらう
      if (e
          .toString()
          .contains("cannot get a field on a DocumentSnapshotPlatform")) {
        await MyDialog.instance.okShowDialog(
            context,
            '${model.userData.userGroup}に未登録なので、'
            '新規登録画面に移動します！');
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSignup(),
          ),
        );
      } else {
        _errorMessage(context, e.toString());
      }
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
