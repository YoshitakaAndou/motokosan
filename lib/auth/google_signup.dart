import 'package:flutter/material.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/email_signup.dart';
import 'package:motokosan/auth/google_model.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../data/constants.dart';
import '../home/home.dart';
import 'group_button/google_group_button.dart';
import 'widgets/login_button.dart';

class GoogleSignup extends StatelessWidget {
  final String userName;
  final String groupName;

  GoogleSignup({this.userName, this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GoogleModel>(context, listen: false);
    final groupController = TextEditingController();
    final nameController = TextEditingController();
    final beforeName = model.userData.userName;
    final Size _size = MediaQuery.of(context).size;
    model.userData.userGroup = groupName;
    groupController.text = model.userData.userGroup;
    nameController.text = model.userData.userName;
    return Consumer<GoogleModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: BarTitle.instance.barTitle(context),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Container()),
                    Expanded(flex: 10, child: _imageArea(context, model)),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _toSignInPage(context, model, _size),
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
                                padding: EdgeInsets.all(8),
                                shrinkWrap: true,
                                children: [
                                  GoogleGroupButton(
                                      context: context, model: model),
                                  SizedBox(height: 20),
                                  _nameInput(context, model, nameController,
                                      beforeName),
                                ],
                              ),
                              SizedBox(height: 40),
                              LoginButton(
                                context: context,
                                label: 'Googleアカウントでログイン',
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
              if (model.isLoading)
                Container(color: Colors.black.withOpacity(0.7)),
              if (model.isLoading) Center(child: CircularProgressIndicator()),
            ]),
          ),
        );
      },
    );
  }

  Widget _imageArea(BuildContext context, GoogleModel model) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      padding: EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.isUpdate == false && model.userData.userName.isNotEmpty)
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
            child: Image.asset("assets/images/protector.png",
                fit: BoxFit.fitHeight, alignment: Alignment.bottomRight),
          ),
        ],
      ),
    );
  }

  Widget _loginTitle(BuildContext context, GoogleModel model) {
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
          "Googleアカウントでログイン",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget _toSignInPage(BuildContext context, GoogleModel model, Size _size) {
    return Container(
      height: 30,
      width: _size.width / 2.2,
      child: RaisedButton.icon(
        icon: Icon(Icons.account_box, size: 18, color: Colors.black54),
        label: Text("ログイン画面へ→",
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
              builder: (context) => EmailSignin(
                groupName: model.userData.userGroup,
                userName: model.userData.userName,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _nameInput(BuildContext context, GoogleModel model,
      TextEditingController nameController, beforeName) {
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
                  model.changeValue("userName", "");
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              if (beforeName != text) {
                model.setIsUpdate(true);
              } else {
                model.setIsUpdate(false);
              }
              model.userData.userName = text;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _loginProcess(BuildContext context, GoogleModel model) async {
    model.setIsLoading(true);
    try {
      if (await model.googleSignin()) {
        // google認証成功
        await FlareActors.instance.done(context);
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(model.userData),
          ),
        );
      } else {
        // google認証失敗
        await MyDialog.instance.okShowDialog(
          context,
          "google認証に失敗しました！"
          "\n新規登録画面へ戻って登録してください！",
        );
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSignup(),
          ),
        );
      }
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
