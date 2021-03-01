import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:motokosan/auth/email_signin.dart';
import 'package:motokosan/auth/email_signup.dart';
import 'package:motokosan/auth/google_login.dart';
import 'package:motokosan/home/home.dart';
import 'package:motokosan/intro/top_page.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';
import 'auth/auth_model.dart';
import 'data/data_save_body.dart';
import 'home/home_model.dart';
import 'take_a_lecture/exam/exam_model.dart';
import 'take_a_lecture/graduater/graduater_model.dart';
import 'take_a_lecture/organizer/organizer_model.dart';
import 'take_a_lecture/question/question_model.dart';
import 'take_a_lecture/workshop/workshop_model.dart';
import 'package:provider/provider.dart';
import 'take_a_lecture/target/target_model.dart';
import 'take_a_lecture/lecture/lecture_model.dart';
import 'dart:io';

import 'unconnect.dart';

void main() async {
  //Future処理に必要
  WidgetsFlutterBinding.ensureInitialized();
  //Firebaseの必須事項
  await Firebase.initializeApp();

  runApp((MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => HomeModel()),
    ChangeNotifierProvider(create: (context) => AuthModel()),
    ChangeNotifierProvider(create: (context) => TargetModel()),
    ChangeNotifierProvider(create: (context) => OrganizerModel()),
    ChangeNotifierProvider(create: (context) => WorkshopModel()),
    ChangeNotifierProvider(create: (context) => LectureModel()),
    ChangeNotifierProvider(create: (context) => QuestionModel()),
    ChangeNotifierProvider(create: (context) => GraduaterModel()),
    ChangeNotifierProvider(create: (context) => ExamModel()),
  ], child: MyApp())));

  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _policy = false;
  String _uid = "";
  String _group = "";
  String _name = "";
  String _email = "";
  String _password = "";
  String _groupName = "";
  String _groupPassword = "";
  String _groupCode = "";
  String _groupEmail = "";
  bool _unConnect = false;

  @override
  void initState() {
    checkNet();
    super.initState();
  }

  checkNet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _unConnect = false;
      }
    } on SocketException catch (_) {
      print('not connected');
      _unConnect = true;
    }
  }

  @override
  void didChangeDependencies() {
    //内蔵メモリの読み出し
    checkPolicy();
    checkUserId();
    checkUserGroup();
    checkUserName();
    checkEmail();
    checkPassword();

    checkGroupName();
    checkGroupPassword();
    checkGroupCode();
    checkGroupEmail();
    super.didChangeDependencies();
  }

  checkPolicy() async {
    DataSave.getBool("_policy").then((value) {
      setState(() {
        _policy = value ?? false;
      });
    });
  }

  checkUserId() async {
    DataSave.getString("_uid").then((value) {
      setState(() {
        _uid = value ?? "";
      });
    });
  }

  checkUserGroup() async {
    DataSave.getString("_group").then((value) {
      setState(() {
        _group = value ?? "";
      });
    });
  }

  checkUserName() async {
    DataSave.getString("_name").then((value) {
      setState(() {
        _name = value ?? "";
      });
    });
  }

  checkEmail() async {
    DataSave.getString("_email").then((value) {
      setState(() {
        _email = value ?? "";
      });
    });
  }

  checkPassword() async {
    DataSave.getString("_password").then((value) {
      setState(() {
        _password = value ?? "";
      });
    });
  }

  checkGroupName() async {
    DataSave.getString("_groupName").then((value) {
      setState(() {
        _groupName = value ?? "";
      });
    });
  }

  checkGroupPassword() async {
    DataSave.getString("_groupPassword").then((value) {
      setState(() {
        _groupPassword = value ?? "";
      });
    });
  }

  checkGroupCode() async {
    DataSave.getString("_groupCode").then((value) {
      setState(() {
        _groupCode = value ?? "";
      });
    });
  }

  checkGroupEmail() async {
    DataSave.getString("_groupEmail").then((value) {
      setState(() {
        _groupEmail = value ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthModel>(context, listen: false);
    model.userData.uid = _uid;
    model.userData.userGroup = _group;
    model.userData.userName = _name;
    model.userData.userEmail = _email;
    model.userData.userPassword = _password;
    model.groupData.name = _groupName;
    model.groupData.password = _groupPassword;
    model.groupData.groupCode = _groupCode;
    model.groupData.email = _groupEmail;
    bool _isCurrentUserSignIn = FSUserData.instance.isCurrentUserSignIn();
    if (_isCurrentUserSignIn) {
      if (_group.isEmpty) {
        _isCurrentUserSignIn = false;
      }
    }
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ja'),
      ],
      title: 'motokosan',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 5,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: !_policy
          ? TopPage(
              unConnect: _unConnect,
              isCurrentUserSignIn: _isCurrentUserSignIn,
              userData: model.userData,
            )
          : _unConnect
              ? UnConnect()
              : _isCurrentUserSignIn
                  ? Home(model.userData)
                  : model.userData.userPassword == "google認証"
                      ? GoogleLogin(
                          userName: model.userData.userName,
                          groupName: model.userData.userGroup,
                        )
                      : model.userData.userEmail.isEmpty
                          ? EmailSignup()
                          : EmailSignin(),
    );
  }
}
