import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/email_signup.dart';
import 'package:motokosan/auth/google_login.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/home/home.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/privacy_policy.dart';

import '../unconnect.dart';
import 'data.dart';

class TopPage extends StatelessWidget {
  final bool unConnect;
  final bool isCurrentUserSignIn;
  final UserData userData;
  TopPage({this.unConnect, this.isCurrentUserSignIn, this.userData});

  @override
  Widget build(BuildContext context) {
    int totalPages = BordItems.loadBoardItem().length;
    Size _size = MediaQuery.of(context).size;
    const double _bar = 20.0;
    const _duration = const Duration(milliseconds: 300);
    const _curve = Curves.ease;

    PageController _controller = PageController();

    Future<void> _showDialog() async {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PrivacyPolicy(
            mdFileName: 'privacy_policy.md',
            buttonTap: (bool result) async {
              if (result) {
                await DataSaveBody.instance.savePolicy(true);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => unConnect
                        ? UnConnect()
                        : isCurrentUserSignIn
                            ? Home(userData)
                            : userData.userPassword == "google認証"
                                ? GoogleLogin(
                                    userName: userData.userName,
                                    groupName: userData.userGroup,
                                  )
                                : userData.userEmail.isEmpty
                                    ? EmailSignup()
                                    : EmailSignin(),
                  ),
                );
              } else {
                await DataSaveBody.instance.savePolicy(false);
                Navigator.of(context).pop();
              }
            },
          );
        },
      );
    }

    return Scaffold(
      body: PageView.builder(
        itemCount: totalPages,
        controller: _controller,
        itemBuilder: (context, int index) {
          BoardItem boardItem = BordItems.loadBoardItem()[index];
          return Container(
            height: _size.height,
            width: _size.width,
            color: boardItem.color,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      child: Text(
                        'スキップ >>',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        await _showDialog();
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    HeroImage(img: boardItem.image, height: _size.height),
                    constHeight10,
                    constHeight10,
                    Text(
                      boardItem.title,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textScaleFactor: 1,
                    ),
                    constHeight10,
                    constHeight10,
                    boardItem.widget,
                    Text(
                      boardItem.subtitle,
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textScaleFactor: 1,
                    ),
                    if (index == totalPages - 1)
                      constHeight10
                    else
                      SizedBox(height: 30),
                    if (index == totalPages - 1)
                      IntroButton(
                        context: context,
                        color: boardItem.buttonColor,
                        icon: FontAwesomeIcons.mouse,
                        iconSize: 20,
                        title: 'ボタンを押して！はじめよう',
                        frameColor: Colors.white12,
                        elevation: 20,
                        onPress: () async {
                          await _showDialog();
                        },
                      ),
                    if (index == totalPages - 1) SizedBox(height: 20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IntroButton(
                      context: context,
                      color: boardItem.lButtonColor,
                      icon: FontAwesomeIcons.angleDoubleLeft,
                      iconSize: 20,
                      iconColor:
                          index > 0 ? Colors.black45 : Colors.transparent,
                      title: '',
                      frameColor: Colors.white12,
                      elevation: 0,
                      onPress: index == 0
                          ? null
                          : () {
                              _controller.previousPage(
                                  duration: _duration, curve: _curve);
                            },
                    ),
                    Container(
                      width: _bar * (totalPages + 2),
                      height: 10,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: totalPages,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              width: index == i ? _bar * 2 : _bar,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: index == i
                                    ? Colors.green[700]
                                    : Colors.black12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IntroButton(
                      context: context,
                      color: boardItem.rButtonColor,
                      icon: FontAwesomeIcons.angleDoubleRight,
                      iconSize: 20,
                      iconColor: Colors.black45,
                      title: '',
                      frameColor: Colors.white12,
                      elevation: 0,
                      onPress: () async {
                        if (index < 4) {
                          _controller.nextPage(
                              duration: _duration, curve: _curve);
                        } else {
                          await _showDialog();
                        }
                      },
                    ),
                  ],
                ),
                // if (index == totalPages - 1) SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  final String img;
  final double height;
  HeroImage({this.img, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height / 2,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(img, fit: BoxFit.fitHeight),
        ),
      ),
    );
  }
}

class IntroButton extends StatelessWidget {
  final BuildContext context;
  final Color color;
  final String title;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color frameColor;
  final double elevation;
  final Function onPress;

  IntroButton({
    this.context,
    this.color,
    this.title,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.frameColor,
    this.elevation,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      disabledColor: Colors.transparent,
      disabledTextColor: Colors.transparent,
      elevation: elevation,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: frameColor),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              textScaleFactor: 1),
        ],
      ),
    );
  }
}
