import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motokosan/take_a_lecture/question/question_database.dart';
import 'package:motokosan/widgets/convert_items.dart';
import '../lecture/lecture_model.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/go_back.dart';
import 'package:soundpool/soundpool.dart';
import '../../constants.dart';
import 'question_model.dart';

class QuestionPlay extends StatefulWidget {
  final String groupName;
  final Question dataQs;
  final Lecture lecture;
  final int _remains;
  final bool isShowOnly;

  QuestionPlay(this.groupName, this.dataQs, this.lecture, this._remains,
      this.isShowOnly);

  @override
  _QuestionPlayState createState() => _QuestionPlayState();
}

class _QuestionPlayState extends State<QuestionPlay> {
  final ScrollController _homeController = ScrollController();
  List<String> choices = List();
  Question _dataQs;
  Lecture _lecture;
  QuestionResult _questionResult = QuestionResult();
  int numberOfRemaining;
  // int numberOfCorrect = 0;
  // int numberOfQuestion = 1;
  Soundpool soundpool;
  int soundIdCorrect = 0;
  int soundIdInCorrect = 0;
  int soundIdOpen = 0;
  String nextTitle = "";
  Icon nextIcon;
  // 状態設定
  bool isCorrect = false;
  bool isAnswered = false;
  bool isCorrectImage = false;
  bool isDescription = false;
  bool isPlaying = false;
  String lastTimeResult = "";

  int answerNum = 0;

  @override
  void initState() {
    super.initState();
    isPlaying = !widget.isShowOnly;
    _dataQs = widget.dataQs;
    _lecture = widget.lecture;
    numberOfRemaining = widget._remains;
    //todo
    initSounds();
    setQuestion();
  }

  void initSounds() async {
    try {
      soundpool = Soundpool();
      soundIdCorrect = await loadSound("assets/sounds/sound_correct.mp3");
      soundIdInCorrect = await loadSound("assets/sounds/sound_incorrect.mp3");
      soundIdOpen = await loadSound("assets/sounds/sound_open.mp3");
      setState(() {});
    } on IOException catch (error) {
      print(error);
    }
  }

  Future<int> loadSound(String soundPath) async {
    return await rootBundle
        .load(soundPath)
        .then((value) => soundpool.load(value));
  }

  @override
  void dispose() {
    super.dispose();
    soundpool.release();
  }

  //todo データの作成
  void setQuestion() {
    // 解答選択肢
    choices = [];
    choices.add(_dataQs.choices1);
    choices.add(_dataQs.choices2);
    if (_dataQs.choices3.isNotEmpty) {
      choices.add(_dataQs.choices3);
    }
    if (_dataQs.choices4.isNotEmpty) {
      choices.add(_dataQs.choices4);
    }
    if (isPlaying) {
      isAnswered = false;
      choices.shuffle();
      nextTitle = "正解と解説を見る";
      nextIcon = Icon(Icons.chat);
    } else {
      isAnswered = true;
      if (numberOfRemaining == 1) {
        nextTitle = "閉じる";
        nextIcon = Icon(Icons.close);
      } else {
        nextTitle = "次　へ";
        nextIcon = Icon(Icons.next_week);
      }
    }

    //todo 初期化
    isCorrect = false;
    isCorrectImage = false;
    isDescription = false;
    lastTimeResult = _dataQs.answered;
    answerNum = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isCorrectImage) {
      Timer(Duration(milliseconds: 1500), () {
        isCorrectImage = false;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: cToolBarH,
        centerTitle: true,
        title: barTitle(context),
        leading: GoBack.instance.goBackWithArg(
          context: context,
          icon: Icon(Icons.arrow_back_ios),
          arg: false,
          num: 1,
        ),
        actions: [
          Image.asset(
            "assets/images/nurse_quiz.png",
            width: 50,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        controller: _homeController,
        reverse: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //カテゴリー表示
            _categoryTile(),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //問題文
                      _questionTile(_dataQs.question),
                      SizedBox(height: 20),
                      //選択肢
                      _choiceTile(context, 1),
                      SizedBox(height: 15),
                      _choiceTile(context, 2),
                      if (_dataQs.choices3.isNotEmpty) SizedBox(height: 15),
                      if (_dataQs.choices3.isNotEmpty) _choiceTile(context, 3),
                      if (_dataQs.choices4.isNotEmpty) SizedBox(height: 15),
                      if (_dataQs.choices4.isNotEmpty) _choiceTile(context, 4),
                      SizedBox(height: 20),
                      _answerDescriptionTile(),
                      SizedBox(height: 15),
                      _nextButton(),
                      SizedBox(height: 30)
                    ],
                  ),
                  _correctImage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryTile() {
    return Container(
      height: cInfoAreaH,
      width: double.infinity,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_lecture.title}",
              style: cTextUpBarM,
              textScaleFactor: 1,
            ),
            if (lastTimeResult.isNotEmpty)
              Text("前回：$lastTimeResult",
                  textScaleFactor: 1, style: cTextUpBarS),
            Row(
              children: [
                Text(
                  "残り",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "$numberOfRemaining 問  ",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionTile(_dataQsQuestion) {
    final List<String> _keyWords = ["正しい", "誤って", "誤った"];
    for (String _keyWord in _keyWords) {
      if (_dataQsQuestion.contains(_keyWord)) {
        final List<String> _questionText = _dataQsQuestion.split(_keyWord);
        return _richText(_questionText[0], _keyWord, _questionText[1]);
      }
    }
    return Text("$_dataQsQuestion", textScaleFactor: 1, style: cTextQuestion);
  }

  Widget _richText(_text1, _text2, _text3) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: _text1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: _text2,
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              // decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: _text3,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _choiceTile(BuildContext context, int _answerNum) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 0, left: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color:
              answerNum == _answerNum ? Colors.green[100] : Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: FlatButton(
                child: Text("$_answerNum",
                    textScaleFactor: 1,
                    style: TextStyle(fontSize: 15, color: Colors.black54)),
                color: Colors.transparent,
                shape: CircleBorder(
                  side: BorderSide(
                    color: choices[_answerNum - 1] == _dataQs.correctChoices &&
                            isAnswered
                        ? Colors.redAccent
                        : Colors.transparent,
                    width: 3.0,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: null,
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                  padding: EdgeInsets.only(right: 13),
                  child: Text(choices[_answerNum - 1],
                      textScaleFactor: 1, style: cTextChoice)),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (!isAnswered) {
          answerNum = _answerNum;
          isAnswered = true;
          if (choices[_answerNum - 1] == _dataQs.correctChoices) {
            // 正解
            isCorrect = true;
            isCorrectImage = true;
            await soundpool.play(soundIdCorrect);
            _questionResult.questionId = _dataQs.questionId;
            _questionResult.answerResult = "○";
            _questionResult.answerAt =
                ConvertItems.instance.dateToInt(DateTime.now());
            await QuestionDatabase.instance.saveValue(_questionResult);
            final result = await QuestionDatabase.instance
                .getAnswerResult(_questionResult.questionId);
            print("dbの値：${result[0].answerResult}");
          } else {
            // 不正解
            isCorrect = false;
            isCorrectImage = true;
            await soundpool.play(soundIdInCorrect);
            _questionResult.questionId = _dataQs.questionId;
            _questionResult.answerResult = "×";
            _questionResult.answerAt =
                ConvertItems.instance.dateToInt(DateTime.now());
            await QuestionDatabase.instance.saveValue(_questionResult);

            final result = await QuestionDatabase.instance
                .getAnswerResult(_questionResult.questionId);
            print("dbの値：${result[0].answerResult}");
          }
          if (numberOfRemaining == 1) {
            nextTitle = "閉じる";
            nextIcon = Icon(Icons.close);
          } else {
            nextTitle = "次　へ";
            nextIcon = Icon(Icons.next_week);
          }
          setState(() {});
        }
      },
    );
  }

  Widget _answerDescriptionTile() {
    if (isAnswered && _dataQs.answerDescription.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          border: Border.all(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Text("【解説】\n${_dataQs.answerDescription}",
            textScaleFactor: 1, style: cTextListL),
      );
    } else {
      return Container();
    }
  }

  Widget _correctImage() {
    if (isCorrectImage) {
      if (isCorrect) {
        return Center(
          child: Image.asset("assets/images/nurse_ok.png"),
        );
      } else {
        return Center(
          child: Image.asset("assets/images/nurse_ng.png"),
        );
      }
    } else {
      return Container();
    }
  }

  Widget _nextButton() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
          icon: nextIcon,
          color: Colors.green[500],
          label: Text(
            nextTitle,
            style: cTextButtonL,
            textScaleFactor: 1,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () {
            if (!isCorrectImage) {
              // 正解と解説を見る
              if (!isAnswered) {
                soundpool.play(soundIdOpen);
                isCorrect = true;
                isAnswered = true;
                if (numberOfRemaining == 1) {
                  nextTitle = "閉じる";
                  nextIcon = Icon(Icons.close);
                } else {
                  nextTitle = "次　へ";
                  nextIcon = Icon(Icons.next_week);
                }
                setState(() {});
              } else {
                // 問題を閉じる動作
                if (nextTitle == "閉じる") {
                  Navigator.of(context).pop(false);
                } else {
                  Navigator.of(context).pop(true);
                }
              }
              setState(() {});
            }
          }),
    );
  }
}
