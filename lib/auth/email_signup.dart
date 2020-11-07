import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:motokosan/auth/email_model.dart';
import 'package:motokosan/widgets/user_data.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/ok_show_dialog.dart';
import 'email_signin.dart';
import 'google_signup.dart';
import '../constants.dart';
import '../home/home.dart';

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
    // todo print
    userDataPrint(model.userData, "GoogleSignup");
    return Consumer<EmailModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: barTitle(context),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                        // height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset("assets/images/nurse03.png")),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _toGoogleSignup(context, model, _size),
                        _toSigninPage(context, model, _size),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
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
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  _groupNameInput(
                                    context,
                                    model,
                                    groupController,
                                  ),
                                  _nameInput(
                                    context,
                                    model,
                                    nameController,
                                  ),
                                  _mailAddressInput(
                                    context,
                                    model,
                                    emailController,
                                  ),
                                  _passwordInput(
                                    context,
                                    model,
                                    passwordController,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            _signupButton(context, model),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
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
      child: SignInButton(
        Buttons.Google,
        text: "googleで登録",
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
        // shape: const OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(5)),
        // ),
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

  Widget _groupNameInput(BuildContext context, EmailModel model,
      TextEditingController groupController) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.group, size: 20, color: Colors.black54),
        ),
        Expanded(
          flex: 5,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: groupController,
            decoration: InputDecoration(
              hintText: "グループ名",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  groupController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.changeValue("userGroup", text);
            },
          ),
        ),
      ],
    );
  }

  Widget _nameInput(BuildContext context, EmailModel model,
      TextEditingController nameController) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.person, size: 20, color: Colors.black54),
        ),
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
              model.changeValue("userName", text);
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
              hintText: "aaa@bbb.ccc",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  emailController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.changeValue("userEmail", text);
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
          child: TextField(
            keyboardType: TextInputType.text,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "password（６文字以上）",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  passwordController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            obscureText: true,
            onChanged: (text) {
              model.changeValue("userPassword", text);
            },
          ),
        ),
      ],
    );
  }

  Widget _signupButton(BuildContext context, EmailModel model) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton.icon(
        icon: Icon(Icons.account_box, color: Colors.white),
        color: Colors.green,
        label: Text("新規登録する", style: cTextUpBarL, textScaleFactor: 1),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        elevation: 15,
        onPressed: () => _signupProcess(context, model),
      ),
    );
  }

  Future<void> _signupProcess(BuildContext context, EmailModel model) async {
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
