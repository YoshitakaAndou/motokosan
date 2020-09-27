import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:motokosan/create_edit/category/category_model.dart';
import 'package:provider/provider.dart';
import 'auth/login_page.dart';
import 'auth/signup_model.dart';
import 'auth/signup_page.dart';
import 'create_edit/target/target_model.dart';
import 'widgets/user_data.dart';
import 'lecture/lec_model.dart';
import 'quiz/quiz_model.dart';
import 'auth/login_model.dart';
import 'q_and_a/qa_model.dart';
import 'widgets/datasave_widget.dart';

void main() {
  runApp((MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => QuizModel()),
    ChangeNotifierProvider(create: (context) => QaModel()),
    ChangeNotifierProvider(create: (context) => LecModel()),
    ChangeNotifierProvider(create: (context) => LoginModel()),
    ChangeNotifierProvider(create: (context) => SignupModel()),
    ChangeNotifierProvider(create: (context) => TargetModel()),
    ChangeNotifierProvider(create: (context) => CategoryModel()),
  ], child: MyApp())));
  //Future処理に必要
  WidgetsFlutterBinding.ensureInitialized();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _uid = "";
  String _group = "";
  String _name = "";
  String _email = "";
  String _password = "";

  @override
  void initState() {
    //内臓メモリ
    checkUserId();
    checkUserGroup();
    checkUserName();
    checkEmail();
    checkPassword();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context, listen: false);
    model.userData.uid = _uid;
    model.userData.userGroup = _group;
    model.userData.userName = _name;
    model.userData.userEmail = _email;
    model.userData.userPassword = _password;
    //todo print
    userDataPrint(model.userData, "main");
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
      home: (model.userData.userEmail == "") ? SignUpPage() : LoginPage(),
    );
  }
}
