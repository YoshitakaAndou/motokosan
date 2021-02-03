import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/email_model.dart';
import 'package:motokosan/auth/widgets/email_signup_password_text.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/show_dialog.dart';
import 'email_signin.dart';
import 'google_signup.dart';
import '../data/constants.dart';
import '../home/home.dart';
import 'group_button/email_group_button.dart';
import 'widgets/login_button.dart';

class EmailSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EmailModel>(context, listen: false);
    final groupController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    groupController.text = model.userData.userGroup;
    nameController.text = model.userData.userName;
    emailController.text = model.userData.userEmail;
    passwordController.text = model.userData.userPassword;
    final Size _size = MediaQuery.of(context).size;
    return Consumer<EmailModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: BarTitle.instance.barTitle(context),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: _size.height / 4,
                    child: Image.asset("assets/images/nurse03.png"),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _toGoogleSignup(context, model, _size),
                        _toSigninPage(context, model, _size),
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
                            _title(context, model),
                            SizedBox(height: 10),
                            ListView(
                              padding: EdgeInsets.all(8),
                              shrinkWrap: true,
                              children: [
                                EmailGroupButton(
                                    context: context, model: model),
                                SizedBox(height: 10),
                                _nameInput(context, model, nameController),
                                SizedBox(height: 10),
                                _mailAddressInput(
                                    context, model, emailController),
                                SizedBox(height: 10),
                                _passwordInput(
                                    context, model, passwordController),
                              ],
                            ),
                            SizedBox(height: 20),
                            LoginButton(
                              context: context,
                              label: '新規登録する',
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
            ),
          ),
        );
      },
    );
  }

  Widget _title(BuildContext context, EmailModel model) {
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
          "新規登録画面",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget _toGoogleSignup(BuildContext context, EmailModel model, Size _size) {
    return Container(
      height: 30,
      width: _size.width / 2.2,
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.google, size: 18, color: Colors.indigo),
        label: Text(
          "googleでログイン",
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
          textScaleFactor: 1,
        ),
        color: Colors.white,
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

  Widget _toSigninPage(BuildContext context, EmailModel model, Size _size) {
    return Container(
      height: 30,
      width: _size.width / 2.2,
      child: RaisedButton.icon(
        icon: Icon(Icons.account_box, size: 18, color: Colors.black54),
        label: Text("登録済みの方→",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500),
            textScaleFactor: 1),
        color: Colors.white,
        elevation: 10,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailSignin(),
            ),
          );
        },
      ),
    );
  }

  Widget _nameInput(BuildContext context, EmailModel model,
      TextEditingController nameController) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Icon(Icons.person, size: 20, color: Colors.black54)),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: nameController,
            decoration: InputDecoration(
              hintText: "name",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  nameController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.changeValue("userName", text.trim());
            },
          ),
        ),
      ],
    );
  }

  Widget _mailAddressInput(BuildContext context, EmailModel model,
      TextEditingController emailController) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.email, size: 20, color: Colors.black54),
        ),
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
              model.changeValue("userEmail", text.trim());
            },
          ),
        ),
      ],
    );
  }

  Widget _passwordInput(BuildContext context, EmailModel model,
      TextEditingController passwordController) {
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
          child: EmailSignupPasswordText(
            passwordController: passwordController,
            model: model,
          ),
        ),
      ],
    );
  }

  Future<void> _loginProcess(BuildContext context, EmailModel model) async {
    try {
      await model.signUp();
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(model.userData),
        ),
      );
    } catch (e) {
      _errorMessage(context, e.toString());
    }
  }

  Future<Widget> _errorMessage(BuildContext context, String _error) async {
    if (_error.contains("invalid-email")) {
      _error = "メールアドレスの形式が間違っています！"
          "\n*** @ *** . *** 形式が必要です。";
    }
    if (_error.contains("ERROR_WEAK_PASSWORD")) {
      _error = "パスワードの強度が十分ではありません！";
    }
    if (_error.contains("email-already-in-use")) {
      _error = "このメールアドレスは既に登録されています！"
          "\nアドレスを変えるか、ログイン画面でログインしてください！";
    }
    return await MyDialog.instance.okShowDialog(context, _error);
  }
}
