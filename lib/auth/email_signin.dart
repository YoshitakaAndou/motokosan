import 'package:flutter/material.dart';
import 'package:motokosan/auth/auth_model.dart';
import 'package:motokosan/auth/widgets/save_group_email.dart';
import 'package:motokosan/data/group_data/group_data_save_body.dart';
import 'package:motokosan/data/user_data/userdata_body.dart';
import 'package:motokosan/widgets/flare_actors.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/show_dialog.dart';
import '../widgets/bubble/bubble.dart';
import '../constants.dart';
import '../home/home.dart';
import 'email_signup.dart';
import '../data/user_data/userdata_firebase.dart';
import 'widgets/auth_title.dart';
import 'widgets/group_button.dart';
import 'widgets/forgot_password.dart';
import 'widgets/auth_button.dart';
import 'widgets/mail_address_input.dart';
import 'widgets/password_input.dart';
import 'widgets/to_google_button.dart';
import 'widgets/to_signUp_button.dart';

class EmailSignin extends StatelessWidget {
  final String userName;
  final String groupName;
  EmailSignin({this.userName, this.groupName});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthModel>(context, listen: false);
    final groupController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final Size _size = MediaQuery.of(context).size;

    groupController.text = model.userData.userGroup;
    emailController.text = model.userData.userPassword == "google認証"
        ? ""
        : model.userData.userEmail;
    passwordController.text = model.userData.userPassword == "google認証"
        ? ""
        : model.userData.userPassword;
    return Consumer<AuthModel>(
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
                  // Expanded(flex: 2, child: Container()),
                  Expanded(
                      flex: _size.height >= 800 ? 8 : 7,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: _imageArea(context, model),
                      )),
                  Expanded(
                    flex: _size.height >= 800 ? 2 : 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ToGoogleButton(
                          context: context,
                          model: model,
                          height: 30,
                          width: _size.width,
                        ),
                        ToSignUpButton(
                          context: context,
                          model: model,
                          height: 30,
                          width: _size.width,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: _size.height >= 800 ? 9 : 10,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AuthTitle(
                                    context: context,
                                    model: model,
                                    title: "ログイン画面"),
                                constHeight10,
                                GroupButton(context: context, model: model),
                                constHeight10,
                                MailAddressInput(
                                  context: context,
                                  model: model,
                                  emailController: emailController,
                                ),
                                constHeight10,
                                PasswordInput(
                                    context: context,
                                    model: model,
                                    passwordController: passwordController),
                                ForgotPassword(
                                  context: context,
                                  model: model,
                                ),
                                AuthButton(
                                  context: context,
                                  label: 'ログインする',
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
            child: Image.asset(
              "assets/images/protector.png",
              fit: BoxFit.fitHeight,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loginProcess(BuildContext context, AuthModel model) async {
    model.setIsLoading(true);
    try {
      //Authにログインしてuidを取得
      final _uid = await model.signIn();
      // 新規にグループを作ったらここでemailをグループデータに登録
      if (isGroupCreate) {
        await saveGroupEmail(createGroupName, model.userData.userEmail);
        model.groupData.email = model.userData.userEmail;
        await GroupDataSaveBody.instance.save(model.groupData);
      }
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
          '新規登録画面に移動します！',
          Colors.blue,
        );
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
      _error = "指定したユーザーとしてログインする試みが多すぎます！";
    }
    if (_error.contains("operation-not-allowed")) {
      _error = "指定したユーザのログインが許されていません！";
    }
    return await MyDialog.instance.okShowDialog(context, _error, Colors.red);
  }
}
