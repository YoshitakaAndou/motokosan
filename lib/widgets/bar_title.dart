import 'package:flutter/material.dart';

Widget barTitle(BuildContext context) {
  return RichText(
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: '研修会',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        TextSpan(
          text: 'の',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.deepOrange,
          ),
        ),
        TextSpan(
          text: '素子さん',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
      ],
    ),
  );
}
