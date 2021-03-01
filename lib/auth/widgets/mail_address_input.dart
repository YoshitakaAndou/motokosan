import 'package:flutter/material.dart';

import '../auth_model.dart';

class MailAddressInput extends StatelessWidget {
  const MailAddressInput({
    Key key,
    @required this.context,
    @required this.model,
    @required this.emailController,
  }) : super(key: key);

  final BuildContext context;
  final AuthModel model;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
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
              hintText: "メールアドレス",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  emailController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.changeValue("userEmail", text.trim());
            },
          ),
        ),
      ],
    );
  }
}
