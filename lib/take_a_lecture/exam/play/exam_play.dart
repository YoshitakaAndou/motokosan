import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:motokosan/take_a_lecture/exam/exam_class.dart';
import 'package:motokosan/take_a_lecture/exam/exam_model.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:provider/provider.dart';
import '../../../widgets/bar_title.dart';
import '../../../widgets/go_back.dart';
import 'package:soundpool/soundpool.dart';
import '../../../constants.dart';

class ExamPlay extends StatefulWidget {
  final UserData _userData;
  final List<ExamList> datesQs;
  final WorkshopList workshopList;
  final int index;
  final bool isShowOnly;

  ExamPlay(this._userData, this.datesQs, this.workshopList, this.index,
      this.isShowOnly);

  @override
  _ExamPlayState createState() => _ExamPlayState();
}

class _ExamPlayState extends State<ExamPlay> {
  final ScrollController _homeController = ScrollController();
  List<String> choices = List();
  List<ExamList> _datesQs;
  ExamList _dataQs;
  WorkshopList _workshopList;
  int numberOfQuestion = 1;
  int numberOfRemaining;
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
  bool isButton = false;

  int answerNum = 0;

  @override
  void initState() {
    super.initState();
    print(widget._userData.uid);
    isPlaying = !widget.isShowOnly;
    _datesQs = widget.datesQs;
    isButton = true;
    _workshopList = widget.workshopList;
    numberOfRemaining = widget.datesQs.length - widget.index;
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
    choices
        .add(_datesQs[widget.index + numberOfQuestion - 1].question.choices1);
    choices
        .add(_datesQs[widget.index + numberOfQuestion - 1].question.choices2);
    if (_datesQs[widget.index + numberOfQuestion - 1]
        .question
        .choices3
        .isNotEmpty) {
      choices
          .add(_datesQs[widget.index + numberOfQuestion - 1].question.choices3);
    }
    if (_datesQs[widget.index + numberOfQuestion - 1]
        .question
        .choices4
        .isNotEmpty) {
      choices
          .add(_datesQs[widget.index + numberOfQuestion - 1].question.choices4);
    }
    _dataQs = _datesQs[widget.index + numberOfQuestion - 1];

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
    answerNum = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ExamModel>(context, listen: false);
    if (isCorrectImage) {
      Timer(Duration(milliseconds: 1500), () {
        isCorrectImage = false;
        isButton = true;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: cToolBarH,
        centerTitle: true,
        title: barTitle(context),
        leading: GoBack.instance.goBack(
          context: context,
          icon: Icon(Icons.arrow_back_ios),
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
            _infoArea(),
            Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),
                  children: [
                    //問題文
                    _questionTile(_dataQs.question.question),
                    SizedBox(height: 20),
                    //選択肢
                    _choiceTile(context, model, 1),
                    SizedBox(height: 15),
                    _choiceTile(context, model, 2),
                    if (_dataQs.question.choices3.isNotEmpty)
                      SizedBox(height: 15),
                    if (_dataQs.question.choices3.isNotEmpty)
                      _choiceTile(context, model, 3),
                    if (_dataQs.question.choices4.isNotEmpty)
                      SizedBox(height: 15),
                    if (_dataQs.question.choices4.isNotEmpty)
                      _choiceTile(context, model, 4),
                    SizedBox(height: 20),
                    _answerDescriptionTile(),
                    SizedBox(height: 15),
                    _nextButton(isButton, model),
                    SizedBox(height: 30)
                  ],
                ),
                _correctImage(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoArea() {
    return Container(
      height: cInfoAreaH,
      width: double.infinity,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_workshopList.workshop.title}",
              style: cTextUpBarM,
              textScaleFactor: 1,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "残り ",
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

  Widget _choiceTile(BuildContext context, ExamModel model, int _answerNum) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(right: 0, left: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: answerNum == _answerNum ? Colors.green[100] : cQuizButton,
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
                    color: choices[_answerNum - 1] ==
                                _dataQs.question.correctChoices &&
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
          if (choices[_answerNum - 1] == _dataQs.question.correctChoices) {
            // 正解
            isCorrect = true;
            isCorrectImage = true;
            await soundpool.play(soundIdCorrect);
            model.setExamResult(widget.index + numberOfQuestion - 1, "○");
            model.correctCount += 1;
          } else {
            // 不正解
            isCorrect = false;
            isCorrectImage = true;
            await soundpool.play(soundIdInCorrect);
            model.setExamResult(widget.index + numberOfQuestion - 1, "×");
          }
          if (numberOfRemaining == 1) {
            nextTitle = "閉じる";
            nextIcon = Icon(Icons.close);
          } else {
            nextTitle = "次　へ";
            nextIcon = Icon(Icons.next_week);
          }
          isButton = false;
          setState(() {});
        } else {
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
              // 次へ進む
              numberOfQuestion += 1;
              numberOfRemaining -= 1;
              if (!isPlaying) {
                // スクロールリスナー経由でスクロールを一番上に戻す
                _homeController.animateTo(-10,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 100));
              }
              if (numberOfRemaining == 0) {
                // 最後まで行って終了
                Navigator.of(context).pop();
              } else {
                setQuestion();
              }
            }
            setState(() {});
          }
        }
      },
    );
  }

  Widget _answerDescriptionTile() {
    if (isAnswered && _dataQs.question.answerDescription.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          border: Border.all(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Text("【解説】\n${_dataQs.question.answerDescription}",
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

  Widget _nextButton(bool _isButton, ExamModel model) {
    final bool _isElevation = nextTitle == "正解と解説を見る" ? false : true;
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        elevation: _isElevation ? 30 : 0,
        icon: nextIcon,
        color: Colors.green[500],
        label: Text(
          nextTitle,
          style: cTextButtonL,
          textScaleFactor: 1,
        ),
        shape: cFABShape,
        onPressed: !_isButton
            ? null
            : () {
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
                    // 次へ進む
                    numberOfQuestion += 1;
                    numberOfRemaining -= 1;
                    if (!isPlaying) {
                      // スクロールリスナー経由でスクロールを一番上に戻す
                      _homeController.animateTo(-10,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 100));
                    }
                    if (numberOfRemaining == 0) {
                      // 最後まで行って終了
                      Navigator.of(context).pop();
                    } else {
                      setQuestion();
                    }
                  }
                  setState(() {});
                }
              },
      ),
    );
  }
}
