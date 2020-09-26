import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/target_page.dart';
import 'package:provider/provider.dart';
import 'lecture/lec_database_model.dart';
import 'auth/user_data.dart';
import 'lecture/lec_list.dart';
import 'q_and_a/qa_fs.dart';
import 'q_and_a/qa_list.dart';
import 'quiz/quiz_fs.dart';
import 'constants.dart';
import 'lecture/lec_fs.dart';
import 'quiz/quiz_database_model.dart';
import 'quiz/quiz_model.dart';
import 'quiz/quiz_list.dart';
import 'pdf_page/pdf.dart';
import 'widgets/bar_title.dart';
import 'quiz/quiz_play.dart';
import 'widgets/ok_show_dialog_func.dart';

class Home extends StatelessWidget {
  final UserData userData;
  Home({this.userData});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QuizModel>(context);
    final _database = DatabaseModel();
    final _databaseLec = LecDatabaseModel();
    const double _sizedBox = 15.0;
    Future(() async {
      model.setDates(await _database.getQuizzesNotKey("○"));
    });
    return Scaffold(
      appBar: AppBar(
        title: barTitle(context),
        centerTitle: true,
      ),
      drawer: _drawer(context, model, _database, _databaseLec),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: _sizedBox),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Image.asset("assets/images/nurse.png")),
            SizedBox(height: 30),
            ChoiceButton(
              label: "講義を受ける",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LecList(lecsId: cLecsId),
                  ),
                );
              },
              backColor: Colors.green,
              borderColor: Colors.black54,
              textColor: Colors.white,
            ),
            SizedBox(height: _sizedBox),
            ChoiceButton(
              label: "問題を解く（残り ${model.dates.length}問）",
              onPressed: () async {
                if (model.dates.length != 0) {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizPlay(
                              datesQs: model.dates,
                              index: 0,
                              isShowOnly: false)));
                }
              },
              backColor: Colors.green,
              borderColor: Colors.black54,
              textColor: Colors.white,
            ),
            SizedBox(height: _sizedBox),
            ChoiceButton(
              label: "解答済み問題",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizList(quizId: cQuizId),
                  ),
                );
              },
              backColor: Colors.green,
              borderColor: Colors.black54,
              textColor: Colors.white,
            ),
            SizedBox(height: _sizedBox),
            ChoiceButton(
              label: "放射線安全 Q & A",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QaList(qasId: cQasId),
                  ),
                );
              },
              backColor: Colors.green,
              borderColor: Colors.black54,
              textColor: Colors.white,
            ),
            SizedBox(height: _sizedBox),
            ChoiceButton(
              label: "看護師のための放射線科入門",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pdf()),
                );
              },
              backColor: Colors.green,
              borderColor: Colors.black54,
              textColor: Colors.white,
            ),
            SizedBox(height: _sizedBox),
            SizedBox(height: _sizedBox),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context, QuizModel model, DatabaseModel _database,
      LecDatabaseModel _databaseLec) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
        child: SizedBox(
          width: 250,
          child: Drawer(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.green[600],
                    child: Center(
                      child:
                          Text("メニュー", style: cTextUpBarLL, textScaleFactor: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: ListView(
                    children: [
                      _menuItem(
                        context: context,
                        title: "データを編集",
                        icon: Icon(Icons.edit, color: Colors.green[800]),
                        onTap: () async {
                          Navigator.pop(context);
                          model.isLoading = true;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TargetPage(groupName: userData.userGroup),
                            ),
                          );
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "Q&Aを編集",
                        icon: Icon(Icons.edit, color: Colors.green[800]),
                        onTap: () async {
                          Navigator.pop(context);
                          model.isLoading = true;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QaFs(qasId: cQasId),
                            ),
                          );
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "講義を編集",
                        icon: Icon(Icons.edit, color: Colors.green[800]),
                        onTap: () async {
                          Navigator.pop(context);
                          model.isLoading = true;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LecFs(lecsId: cLecsId),
                            ),
                          );
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "回答済みをリセット",
                        icon: Icon(Icons.restore, color: Colors.green[800]),
                        onTap: () {
                          Navigator.pop(context);
                          okShowDialogFunc(
                              context: context,
                              mainTitle: "回答済みをリセット",
                              subTitle: "実行しますか？",
                              onPressed: () async {
                                await _database.updateQuizAnswered("");
                                model.setDates(
                                    await _database.getQuizzesNotKey("○"));
                                Navigator.pop(context);
                              });
                        },
                      ),
                      _menuItem(
                        context: context,
                        title: "受講済みをリセット",
                        icon: Icon(Icons.restore, color: Colors.green[800]),
                        onTap: () {
                          Navigator.pop(context);
                          okShowDialogFunc(
                              context: context,
                              mainTitle: "受講済みをリセット",
                              subTitle: "実行しますか？",
                              onPressed: () async {
                                await _databaseLec.resetLecAnswered("", "");
                                Navigator.pop(context);
                              });
                        },
                      ),
                      Container(
                        width: double.infinity,
                        height: 70,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Icon(Icons.person)),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("グループ名：${userData.userGroup}",
                                      style: cTextListSS),
                                  Text("ユーザー名：${userData.userName}",
                                      style: cTextListSS),
                                  Text("e-mail  ：${userData.userEmail}",
                                      style: cTextListSS),
                                  Text("passWord：${userData.userPassword}",
                                      style: cTextListSS),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 5, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    BuildContext context,
    String title,
    Icon icon,
    Function onTap,
  }) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(margin: EdgeInsets.all(10.0), child: icon),
              SizedBox(width: 10),
              Text(title,
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.black, fontSize: 15.0)),
            ],
          )),
      onTap: onTap,
    );
  }
}

class ChoiceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backColor;
  final Color borderColor;
  final Color textColor;
  ChoiceButton(
      {this.label,
      this.onPressed,
      this.backColor,
      this.borderColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: borderColor),
            borderRadius: BorderRadius.circular(10),
            color: backColor),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              label,
              textScaleFactor: 1,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
