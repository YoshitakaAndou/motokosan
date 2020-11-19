import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/email_signup.dart';
import 'package:motokosan/auth/google_model.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/ok_show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../constants.dart';
import '../home/home.dart';

class GoogleSignin extends StatelessWidget {
  final UserData userData;

  GoogleSignin({this.userData});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GoogleModel>(context, listen: false);
    final groupController = TextEditingController();
    final nameController = TextEditingController();
    final beforeGroup = model.userData.userGroup;
    final beforeName = model.userData.userName;
    final Size _size = MediaQuery.of(context).size;
    model.userData = userData;
    groupController.text = model.userData.userGroup;
    nameController.text = model.userData.userName;
    return Consumer<GoogleModel>(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _toSignUpPage(context, _size),
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
                              shrinkWrap: true,
                              padding: EdgeInsets.all(8),
                              children: [
                                SizedBox(height: 10),
                                _groupNameInput(context, model, groupController,
                                    beforeGroup),
                                _nameInput(
                                    context, model, nameController, beforeName),
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
                  //   Expanded(
                  //     flex: 1,
                  //     child: Container(),
                  //   ),
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
            child: Image.asset("assets/images/nurse02.png",
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
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          "Googleログイン画面",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget _toSignUpPage(BuildContext context, Size _size) {
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
      BuildContext context, GoogleModel model, groupController, beforeGroup) {
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
              // suffixIcon: IconButton(
              //   onPressed: () {
              //     groupController.text = "";
              //     model.changeValue("userGroup", "");
              //   },
              //   icon: Icon(Icons.clear, size: 15),
              // ),
            ),
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
    );
  }

  Widget _nameInput(BuildContext context, GoogleModel model,
      TextEditingController nameController, beforeName) {
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
              // suffixIcon: IconButton(
              //   onPressed: () {
              //     nameController.text = "";
              //     model.changeValue("userName", "");
              //   },
              //   icon: Icon(Icons.clear, size: 15),
              // ),
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

  Widget _loginButton(BuildContext context, GoogleModel model) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.signInAlt, color: Colors.white),
        color: Colors.green,
        label:
            Text("Googleアカウントでログインする", style: cTextUpBarL, textScaleFactor: 1),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
        elevation: 15,
        onPressed: () => _loginProcess(context, model),
      ),
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
        // Navigator.pop(context);
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
