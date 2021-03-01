import 'package:flutter/material.dart';

import '../auth_model.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key key,
    @required this.context,
    @required this.model,
    @required this.nameController,
  }) : super(key: key);

  final BuildContext context;
  final AuthModel model;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
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
              hintText: "ユーザー名",
              hintStyle: TextStyle(fontSize: 12),
              suffixIcon: IconButton(
                onPressed: () {
                  nameController.text = "";
                },
                icon: Icon(Icons.clear, size: 15),
              ),
            ),
            onChanged: (text) {
              model.changeValue("userName", text.trim());
            },
          ),
        ),
      ],
    );
  }
}
