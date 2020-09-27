import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/done.dart';
import '../widgets/bar_title.dart';
import '../widgets/user_data.dart';
import '../widgets/ok_show_dialog_func.dart';
import '../widgets/ok_show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../lecture/lec_database_model.dart';
import '../lecture/lec_firestore_model.dart';
import '../q_and_a/qa_database_model.dart';
import '../quiz/quiz_database_model.dart';
import '../quiz/quiz_firestore_model.dart';
import '../q_and_a/qa_firestore_model.dart';
import '../constants.dart';
import '../home.dart';
import 'login_model.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context, listen: false);
    final groupController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final beforeGroup = model.userData.userGroup;
    final beforeEmail = model.userData.userEmail;
    final beforePassword = model.userData.userPassword;
    //todo print
    userDataPrint(model.userData, "login_page");
    groupController.text = model.userData.userGroup;
    emailController.text = model.userData.userEmail;
    passwordController.text = model.userData.userPassword;
    return Consumer<LoginModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: barTitle(context),
            centerTitle: true,
          ),
          body: Stack(children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (model.isUpdate == false &&
                              model.userData.userName.isNotEmpty)
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
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.bottomRight),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                                "ログイン画面",
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
                                  height: 30,
                                  width: double.infinity,
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.account_box,
                                            size: 18, color: Colors.black54),
                                        Text("新規登録の方はこちら→",
                                            style: cTextListS,
                                            textScaleFactor: 1),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUpPage(),
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
                                            size: 20, color: Colors.black54)),
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: groupController,
                                        decoration:
                                            InputDecoration(hintText: "グループ名"),
                                        onChanged: (text) {
                                          if (beforeGroup != text) {
                                            model.setIsUpdate(true);
                                          } else {
                                            model.setIsUpdate(false);
                                          }
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
                                        child: Icon(Icons.email,
                                            size: 20, color: Colors.black54)),
                                    Expanded(
                                      flex: 5,
                                      child: TextField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            hintText: "aaa@bbb.ccc"),
                                        onChanged: (text) {
                                          if (beforeEmail != text) {
                                            model.setIsUpdate(true);
                                          } else {
                                            model.setIsUpdate(false);
                                          }
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
                                            hintText: "password"),
                                        obscureText: true,
                                        onChanged: (text) {
                                          if (beforePassword != text) {
                                            model.setIsUpdate(true);
                                          } else {
                                            model.setIsUpdate(false);
                                          }
                                          model.userData.userPassword = text;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: RaisedButton.icon(
                                    icon: Icon(FontAwesomeIcons.signInAlt,
                                        color: Colors.white),
                                    color: Colors.green,
                                    label: Text("ログインする",
                                        style: cTextUpBarL, textScaleFactor: 1),
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 2),
                                    ),
                                    elevation: 15,
                                    onPressed: () =>
                                        _loginProcess(context, model),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (model.isLoading)
              Container(color: Colors.black.withOpacity(0.7)),
            if (model.isLoading) Center(child: CircularProgressIndicator()),
          ]),
        );
      },
    );
  }

  Future<void> _loginProcess(BuildContext context, LoginModel model) async {
    model.setIsLoading(true);
    try {
      //Authにログインしてuidを取得
      final _uid = await model.logIn();
      //FirebaseStorageからUser情報を取得
      print("_uid:$_uid");
      print("model.userData.uid:${model.userData.uid}");
      //Authのuidと本体のuidを比較
      if (_uid != model.userData.uid) {
        model.userData = await model.getUserDataFromFs(_uid);
        //違っていたら本体に保存するか？
        await okShowDialogFunc(
            context: context,
            mainTitle: "本体情報と違うアカウントでログインしました！",
            subTitle: "\ngroup :${model.userData.userGroup}"
                "\nname  :${model.userData.userName}"
                "\nemail :${model.userData.userEmail}\n"
                "\n本体情報を上書き保存しますか？",
            onPressed: () async {
              await model.saveDataToPhone(model.userData);
              Navigator.pop(context);
            });
      }
      // await okShowDialog(context, "ログインしました");
      await done(context);
      // await firework(context);
      //DataBaseのチェック
      final _databaseQuiz = DatabaseModel();
      Future(() async {
        final _datesQuiz = await _databaseQuiz.getQuizzes();
        if (_datesQuiz.length == 0) {
          //新規の場合はDBが空なのでFBからデータを注入
          await _databaseQuiz.insertQuizzes(await fetchQuizFsCloud(cQuizId));
        }
      });
      final _databaseQa = QaDatabaseModel();
      Future(() async {
        await _databaseQa.deleteAllQa();
        await _databaseQa.insertQas(await fetchFsCloud(cQasId));
      });
      final _databaseLec = LecDatabaseModel();
      Future(() async {
        final _datesLec = await _databaseLec.getLecs();
        if (_datesLec.length == 0) {
          //新規の場合はDBが空なのでFBからデータを注入
          await _databaseLec.insertLecs(await lFetchFsCloud(cLecsId));
        }
      });
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userData: model.userData),
        ),
      );
      model.setIsLoading(false);
    } catch (e) {
      model.setIsLoading(false);
      _errorMessage(context, e.toString());
    }
  }

  Future<Widget> _errorMessage(BuildContext context, String _error) async {
    if (_error.contains("ERROR_INVALID_EMAIL")) {
      _error = "メールアドレスの形式が間違っています！";
    }
    if (_error.contains("ERROR_WRONG_PASSWORD")) {
      _error = "パスワードが間違っています！";
    }
    if (_error.contains("ERROR_USER_NOT_FOUND")) {
      _error = "指定されたメールアドレスでのユーザ登録がありません！";
    }
    if (_error.contains("ERROR_USER_DISABLED")) {
      _error = "指定したユーザーが無効になっています！";
    }
    if (_error.contains("ERROR_TOO_MANY_REQUESTS")) {
      _error = "指定したユーザーとしてサインインする試みが多すぎます！";
    }
    if (_error.contains("ERROR_OPERATION_NOT_ALLOWED")) {
      _error = "指定したユーザのログインが許されていません！";
    }
    return await okShowDialog(context, _error);
  }
}
