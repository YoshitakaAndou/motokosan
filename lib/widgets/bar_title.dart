import 'package:flutter/material.dart';

class BarTitle {
  static final BarTitle instance = BarTitle();

  Widget introTitle() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '「',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
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
          TextSpan(
            text: '」です！',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

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

  Widget barTitle2(BuildContext context) {
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
          TextSpan(
            text: '？',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
