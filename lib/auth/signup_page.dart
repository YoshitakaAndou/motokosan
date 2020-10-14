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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 5),
                    Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset("assets/images/nurse03.png")),
                    Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8)),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                "新規登録画面",
                                style: cTextUpBarL,
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.account_circle,
                                            size: 18, color: Colors.black54),
                                        Text("登録済みの方はログイン画面へ→",
                                            style: cTextListS,
                                            textScaleFactor: 1),
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
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(Icons.group,
                                          size: 20, color: Colors.black54),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: groupController,
                                        decoration:
                                            InputDecoration(hintText: "グループ名"),
                                        onChanged: (text) {
                                          model.userData.userGroup = text;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(Icons.person,
                                          size: 20, color: Colors.black54),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: nameController,
                                        decoration:
                                            InputDecoration(hintText: "name"),
                                        onChanged: (text) {
                                          model.userData.userName = text;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(Icons.email,
                                          size: 20, color: Colors.black54),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            hintText: "aaa@bbb.ccc"),
                                        onChanged: (text) {
                                          model.userData.userEmail = text;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
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
                                            hintText: "password（６文字以上）"),
                                        obscureText: true,
                                        onChanged: (text) {
                                          model.userData.userPassword = text;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: RaisedButton.icon(
                              icon:
                                  Icon(Icons.account_box, color: Colors.white),
                              color: Colors.green,
                              label: Text("新規登録する",
                                  style: cTextUpBarL, textScaleFactor: 1),
                              shape: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2),
                              ),
                              elevation: 15,
                              onPressed: () => _signupProcess(context, model),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signupProcess(BuildContext context, SignupModel model) async {
    try {
      await model.signUp();
      await _showDialog(context, "登録完了しました");
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
          builder: (context) => Home(userData: model.userData),
        ),
      );
    } catch (e) {
      _errorMessage(context, e.toString());
    }
  }

  Future _showDialog(BuildContext context, String title) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
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
    return await okShowDialog(context, _error);
  }
}
