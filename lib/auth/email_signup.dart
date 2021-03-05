import 'package:flutter/material.dart';
import 'package:motokosan/auth/auth_model.dart';
import 'package:motokosan/auth/widgets/save_group_email.dart';
import 'package:motokosan/auth/widgets/to_signIn_button.dart';
import 'package:motokosan/data/group_data/group_data_save_body.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/show_dialog.dart';
import '../constants.dart';
import '../home/home.dart';
import 'widgets/auth_title.dart';
import 'widgets/group_button.dart';
import 'widgets/auth_button.dart';
import 'widgets/mail_address_input.dart';
import 'widgets/name_input.dart';
import 'widgets/password_input.dart';
import 'widgets/to_google_button.dart';

class EmailSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthModel>(context, listen: false);
    final groupController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    groupController.text = model.userData.userGroup;
    nameController.text = model.userData.userName;
    emailController.text = model.userData.userEmail;
    passwordController.text = model.userData.userPassword;
    final Size _size = MediaQuery.of(context).size;
    return Consumer<AuthModel>(
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
                  Expanded(
                    flex: 5,
                    child: Container(
                      // height: _size.height / 4,
                      child: Image.asset("assets/images/nurse03.png"),
                    ),
                  ),
                  Expanded(
                    flex: _size.height >= 800 ? 2 : 1,
                    child: Container(
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
                          ToSignInButton(
                            context: context,
                            model: model,
                            height: 30,
                            width: _size.width,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _size.height >= 800 ? 8 : 9,
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
                                    title: "新規登録画面"),
                                constHeight10,
                                GroupButton(context: context, model: model),
                                constHeight10,
                                NameInput(
                                    context: context,
                                    model: model,
                                    nameController: nameController),
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
                                constHeight10,
                                constHeight10,
                                AuthButton(
                                  context: context,
                                  label: '新規登録する',
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
          ),
        );
      },
    );
  }

  Future<void> _loginProcess(BuildContext context, AuthModel model) async {
    try {
      await model.signUp();
      // 新規にグループを作ったらここでemailをグループデータに登録
      if (isGroupCreate) {
        await saveGroupEmail(createGroupName, model.userData.userEmail);
        model.groupData.email = model.userData.userEmail;
        await GroupDataSaveBody.instance.save(model.groupData);
      }
      await MyDialog.instance.okShowDialog(context, "登録完了しました", Colors.black);
      Navigator.pop(context);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(userData:model.userData),
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
    return await MyDialog.instance.okShowDialog(context, _error, Colors.red);
  }
}
