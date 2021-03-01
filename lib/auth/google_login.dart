import 'package:flutter/material.dart';
import 'package:motokosan/auth/email_signup.dart';
import 'package:motokosan/data/group_data/group_data_save_body.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../constants.dart';
import '../home/home.dart';
import 'auth_model.dart';
import 'widgets/auth_title.dart';
import 'widgets/group_button.dart';
import 'widgets/name_input.dart';
import 'widgets/save_group_email.dart';
import 'widgets/auth_button.dart';
import 'widgets/to_signIn_button.dart';

class GoogleLogin extends StatelessWidget {
  final String userName;
  final String groupName;

  GoogleLogin({this.userName, this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthModel>(context, listen: false);
    final groupController = TextEditingController();
    final nameController = TextEditingController();
    final Size _size = MediaQuery.of(context).size;
    groupController.text = model.userData.userGroup;
    nameController.text = model.userData.userName;
    return Consumer<AuthModel>(
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
                          ToSignInButton(
                            context: context,
                            model: model,
                            height: 30,
                            width: _size.width,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Container(
                            child: Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AuthTitle(
                                      context: context,
                                      model: model,
                                      title: "Googleアカウントでログイン"),
                                  constHeight10,
                                  ListView(
                                    padding: EdgeInsets.all(8),
                                    shrinkWrap: true,
                                    children: [
                                      GroupButton(
                                          context: context, model: model),
                                      constHeight10,
                                      constHeight10,
                                      NameInput(
                                          context: context,
                                          model: model,
                                          nameController: nameController),
                                    ],
                                  ),
                                  constHeight10,
                                  constHeight10,
                                  constHeight10,
                                  constHeight10,
                                  AuthButton(
                                    context: context,
                                    label: 'Googleアカウントでログイン',
                                    onPressed: () {
                                      _loginProcess(context, model);
                                    },
                                  ),
                                  constHeight10,
                                  constHeight10,
                                ],
                              ),
                            ),
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

  Widget _imageArea(BuildContext context, AuthModel model) {
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

  Future<void> _loginProcess(BuildContext context, AuthModel model) async {
    model.setIsLoading(true);
    try {
      if (await model.googleLogin()) {
        // 新規にグループを作ったらここでemailをグループデータに登録
        if (isGroupCreate) {
          await saveGroupEmail(createGroupName, model.userData.userEmail);
          model.groupData.email = model.userData.userEmail;
          await GroupDataSaveBody.instance.save(model.groupData);
        }
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
            Colors.red);
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
      _error = "指定したユーザーとしてログインする試みが多すぎます！";
    }
    if (_error.contains("operation-not-allowed")) {
      _error = "指定したユーザのログインが許されていません！";
    }
    return await MyDialog.instance.okShowDialog(context, _error, Colors.red);
  }
}
