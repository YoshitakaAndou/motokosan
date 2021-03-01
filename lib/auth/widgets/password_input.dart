import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../auth_model.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    @required this.context,
    @required this.model,
    @required this.passwordController,
  }) : super(key: key);

  final BuildContext context;
  final AuthModel model;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
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
          child: AuthPasswordText(
            passwordController: passwordController,
            model: model,
          ),
        ),
      ],
    );
  }
}

class AuthPasswordText extends StatefulWidget {
  final TextEditingController passwordController;
  final AuthModel model;

  AuthPasswordText({
    this.passwordController,
    this.model,
  });

  @override
  _AuthPasswordTextState createState() => _AuthPasswordTextState();
}

class _AuthPasswordTextState extends State<AuthPasswordText> {
  bool _passwordHide = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: _passwordHide,
      controller: widget.passwordController,
      decoration: InputDecoration(
        hintText: "password（６文字以上）",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _passwordHide
                    ? FontAwesomeIcons.solidEyeSlash
                    : FontAwesomeIcons.solidEye,
                size: 15,
              ),
              onPressed: () {
                this.setState(() {
                  _passwordHide = !_passwordHide;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.clear, size: 15),
              onPressed: () {
                widget.passwordController.text = "";
              },
            )
          ],
        ),
      ),
      onChanged: (text) {
        widget.model.changeValue("userPassword", text.trim());
      },
    );
  }
}
