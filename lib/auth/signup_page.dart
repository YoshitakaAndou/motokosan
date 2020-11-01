import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/ok_show_dialog.dart';
import 'login_page.dart';
import '../constants.dart';
import '../home.dart';

import 'signup_model.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final groupController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Consumer<SignupModel>(
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
                  Expanded(flex: 1, child: Container()),
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
                                  _toSigninPage(context, model),
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

  Widget _title(BuildContext context, SignupModel model) {
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

  Widget _toSigninPage(BuildContext context, SignupModel model) {
    return Container(
      height: 20,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.account_circle, size: 18, color: Colors.black54),
            Text("登録済みの方はログイン画面へ→", style: cTextListS, textScaleFactor: 1),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
      ),
    );
  }

  Widget _groupNameInput(BuildContext context, SignupModel model,
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
              model.isUpdate = true;
              model.changeValue("userGroup", text);
            },
          ),
        ),
      ],
    );
  }

  Widget _nameInput(BuildContext context, SignupModel model,
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
              model.isUpdate = true;
              model.changeValue("userName", text);
            },
          ),
        ),
      ],
    );
  }

  Widget _mailAddressInput(BuildContext context, SignupModel model,
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
              model.isUpdate = true;
              model.changeValue("userEmail", text);
            },
          ),
        ),
      ],
    );
  }

  Widget _passwordInput(BuildContext context, SignupModel model,
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
              model.isUpdate = true;
              model.changeValue("userPassword", text);
            },
          ),
        ),
      ],
    );
  }

  Widget _signupButton(BuildContext context, SignupModel model) {
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
        onPressed:
            !model.isUpdate ? null : () => _signupProcess(context, model),
      ),
    );
  }

  Future<void> _signupProcess(BuildContext context, SignupModel model) async {
    try {
      await model.signUp();
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
      // //todo DBaseのチェック
      // final _databaseQuiz = DatabaseModel();
      // Future(() async {
      //   final _datesQuiz = await _databaseQuiz.getQuizzes();
      //   if (_datesQuiz.length == 0) {
      //     //新規の場合はDBが空なのでFBからデータを注入
      //     await _databaseQuiz.insertQuizzes(await fetchQuizFsCloud(cQuizId));
      //   }
      // });
      // final _databaseQa = QaDatabaseModel();
      // Future(() async {
      //   await _databaseQa.deleteAllQa();
      //   await _databaseQa.insertQas(await fetchFsCloud(cQasId));
      // });
      // final _databaseLec = LecDatabaseModel();
      // Future(() async {
      //   final _datesLec = await _databaseLec.getLecs();
      //   if (_datesLec.length == 0) {
      //     //新規の場合はDBが空なのでFBからデータを注入
      //     await _databaseLec.insertLecs(await lFetchFsCloud(cLecsId));
      //   }
      // });
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
    if (_error.contains("ERROR_INVALID_EMAIL")) {
      _error = "メールアドレスの形式が間違っています！";
    }
    if (_error.contains("ERROR_WEAK_PASSWORD")) {
      _error = "パスワードの強度が十分ではありません！";
    }
    if (_error.contains("ERROR_EMAIL_ALREADY_IN_USE")) {
      _error = "メールアドレスが別のアカウントですでに使用されています！"
          "\nメールアドレスを変えるか、ログイン画面でログインしてください！";
    }
    return await MyDialog.instance.okShowDialog(context, _error);
  }
}
