import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/bubble/bubble.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../data/constants.dart';
import 'lec_database_model.dart';
import 'lec_model.dart';

import 'package:soundpool/soundpool.dart';

enum LecMode {
  LECTURE,
  TEST,
}

class LecPlay extends StatefulWidget {
  final List<Lec> datesLec;
  final int index;

  LecPlay({
    this.datesLec,
    this.index,
  });

  @override
  _LecPlayState createState() => _LecPlayState();
}

class _LecPlayState extends State<LecPlay> {
  final _database = LecDatabaseModel();
  final ScrollController _homeController = ScrollController();
  List<Lec> _datesLec = List();
  Lec _dataLec;
  int numberOfRemaining;
  int numberOfCorrect = 0;
  int numberOfLecture = 1;
  Soundpool soundpool;
  int soundIdCorrect = 0;
  int soundIdInCorrect = 0;
  int soundIdOpen = 0;
  String nextTitle = "";
  Icon nextIcon;
  // 状態設定
  int answerNum = 0;
  bool isPopWind = false;
  bool isPlaying = false;
  bool isCorrect = false;
  bool isAnswered = false;
  bool isCorrectImage = false;
  bool isDescription = false;
  bool isHelp = false;
  bool isVideoPlay = false;
  LecMode _lecMode = LecMode.LECTURE;
  String testDesc = "";
  String testQues = "";
  String testAns = "";
  List choices = ["○", "×"];
  var rand = math.Random();
  var _videoUrl = "";
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _datesLec = widget.datesLec;
    numberOfRemaining = _datesLec.length - widget.index;
    initSounds();
    setLec();
    startVideo(_videoUrl, true);
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
    _datesLec = List();
    _controller.dispose();
  }

  void stopVideo() {
    if (_controller != null) {
      _controller.pause();
    }
  }

  void startVideo(String _videoUrl, bool _autoPlay) {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_videoUrl),
        flags: YoutubePlayerFlags(
          autoPlay: _autoPlay,
          mute: false,
        ));
  }

  void setLec() {
    stopVideo();
    _dataLec = _datesLec[widget.index + numberOfLecture - 1];
    _videoUrl = _dataLec.videoUrl;
    // startVideo(_dataLec.videoUrl, true);
    if (numberOfRemaining == 1) {
      if (_dataLec.answered != "○") {
        nextTitle = "確認テストへ";
        nextIcon = Icon(Icons.next_week);
      } else {
        nextTitle = "閉じる";
        nextIcon = Icon(Icons.close);
      }
    } else {
      if (_dataLec.answered != "○") {
        nextTitle = "確認テストへ";
        nextIcon = Icon(Icons.next_week);
      } else {
        nextTitle = "次の講義へ";
        nextIcon = Icon(Icons.next_week);
      }
    }
    answerNum = 0;
    // setState(() {});
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  void setTest() {
    if (rand.nextInt(2) == 0) {
      testQues = _dataLec.correctQuestion;
      testDesc = _dataLec.correctAnswer;
      testAns = "○";
    } else {
      testQues = _dataLec.incorrectQuestion;
      testDesc = _dataLec.incorrectAnswer;
      testAns = "×";
    }
    if (isPlaying) {
      isAnswered = false;
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
    isCorrect = false;
    isCorrectImage = false;
    isDescription = false;
    answerNum = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //todo サイズ
    final _mediaHeight = MediaQuery.of(context).size.height;
    final _mediaWidth = MediaQuery.of(context).size.width;
    final _upHeight = _mediaWidth / 1.33 + 45;
    final _bottomHeight = _mediaHeight - _upHeight - 105;
    return _lecMode == LecMode.LECTURE
        ? _lecture(
            context: context,
            mediaWidth: _mediaWidth,
            upHeight: _upHeight,
            bottomHeight: _bottomHeight)
        : _test(context);
  }

  Widget _lecture({BuildContext context, mediaWidth, upHeight, bottomHeight}) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BarTitle.instance.barTitle(context),
        leading: isPopWind
            ? Container()
            : GoBack.instance.goBack(
                context: context, icon: Icon(Icons.arrow_back_ios), num: 1),
        actions: [
          isPopWind ? _closeButton(context) : Container(),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
              width: mediaWidth,
              height: upHeight,
              child: Column(
                children: [
                  _categoryTile(),
                  _videoTile(),
                  // _slideTile(context),
                ],
              ),
            ),
            Divider(height: 5, color: Colors.grey, thickness: 1),
            SizedBox(
              width: mediaWidth,
              height: bottomHeight,
              child: SingleChildScrollView(
                controller: _homeController,
                child: Column(
                  children: [
                    _descriptionTile(),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _nextButton(),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isPopWind) _popWind(),
      ]),
    );
  }

  Widget _categoryTile() {
    return Container(
      height: 45,
      width: double.infinity,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("講義  ", style: cTextUpBarLL, textScaleFactor: 1),
                if (_dataLec.answered == "○")
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    child: Text("合格済", style: cTextUpBarS, textScaleFactor: 1),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: Colors.yellow,
                        )),
                  ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${_dataLec.category} - "
                  "${_dataLec.subcategory}",
                  style: cTextUpBarSS,
                  textScaleFactor: 1,
                ),
                Text(
                  "${_dataLec.lecTitle}",
                  textScaleFactor: 1,
                  style: cTextUpBarS,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _slideTile(BuildContext context) {
  //   return Center(
  //     child: InkWell(
  //       onTap: () {
  //         isPopWind = !isPopWind;
  //         setState(() {});
  //       },
  //       child: CachedNetworkImage(
  //         imageUrl: _dataLec.slideUrl,
  //         imageBuilder: (context, imageProvider) => Container(
  //           width: MediaQuery.of(context).size.width,
  //           height: MediaQuery.of(context).size.width / 1.33,
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: imageProvider,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         placeholder: (context, url) => CircularProgressIndicator(),
  //         errorWidget: (context, url, error) => Icon(Icons.error),
  //       ),
  //     ),
  //   );
  // }

  Widget _videoTile() {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          child: SingleChildScrollView(
            child: YoutubePlayer(
              controller: _controller,
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("【解説】", textScaleFactor: 1, style: cTextListL),
          Text("${_dataLec.description}",
              textScaleFactor: 1, style: cTextListL),
        ],
      ),
    );
  }

  Widget _nextButton() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 10,
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
            stopVideo();
            if (_dataLec.answered != "○") {
              _lecMode = LecMode.TEST;
              isPlaying = true;
              setTest();
            } else {
              //todo 次へ進む
              numberOfLecture += 1;
              numberOfRemaining -= 1;
              if (numberOfRemaining <= 0) {
                Navigator.pop(context, widget.index + numberOfLecture - 1);
              } else {
                setState(() {
                  setLec();
                  print("_videoUrl:$_videoUrl");
                  startVideo(_videoUrl, true);
                  //todo スクロールリスナー経由でスクロールを一番上に戻す
                  _homeController.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 10),
                  );
                });
              }
            }
          }
          // setState(() {});
          ),
    );
  }

  Widget _popWind() {
    return GestureDetector(
      onTap: () {
        isPopWind = false;
        setState(() {});
      },
      child: PhotoView(
        initialScale: 1.0,
        backgroundDecoration:
            BoxDecoration(color: Colors.grey.withOpacity(0.8)),
        imageProvider: CachedNetworkImageProvider(_dataLec.slideUrl, scale: 1),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close),
      iconSize: 35,
      color: Colors.black54,
      onPressed: () {
        isPopWind = false;
        setState(() {});
      },
    );
  }

  Widget _test(BuildContext context) {
    if (isCorrectImage) {
      Timer(Duration(milliseconds: 1500), () {
        isCorrectImage = false;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BarTitle.instance.barTitle(context),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black54,
          iconSize: 35,
          onPressed: () {
            setState(() {
              _lecMode = LecMode.LECTURE;
              setLec();
            });
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              isHelp = !isHelp;
              setState(() {});
            },
            child: !isHelp
                ? Image.asset(
                    "assets/images/nurse_quiz.png",
                    width: 50,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.close, size: 35, color: Colors.black54),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        controller: _homeController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //todo カテゴリー表示
            _testCategoryTile(),
            if (isHelp) _instruction(),

            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      _questionTile(),
                      SizedBox(height: 20),
                      //todo 選択肢
                      _choiceTile(context, 1),
                      SizedBox(height: 20),
                      _choiceTile(context, 2),
                      SizedBox(height: 20),
                      _answerDescriptionTile(),
                      SizedBox(height: 15),
                      _testNextButton(),
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

  Widget _testCategoryTile() {
    return Container(
      height: 45,
      width: double.infinity,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "確認テスト",
              style: cTextUpBarLL,
              textScaleFactor: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${_dataLec.category} - ${_dataLec.subcategory}",
                    style: cTextUpBarSS, textScaleFactor: 1),
                Text("${_dataLec.lecTitle}",
                    textScaleFactor: 1, style: cTextUpBarS),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _instruction() {
    return Container(
      height: 80,
      width: double.infinity,
      color: cContBg,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(Icons.comment, color: Colors.black54, size: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Bubble(
              color: Color.fromRGBO(225, 255, 199, 1.0),
              nip: BubbleNip.rightBottom,
              nipWidth: 10,
              nipHeight: 5,
              child: Text(
                "次の文章を読んで、正しい場合は○を、"
                "\n間違っている場合には×を選んでください。"
                "\n正解すると次に進めます！",
                style: TextStyle(fontSize: 10),
                textScaleFactor: 1,
              ),
            ),
          ),
          SizedBox(width: 10),
          Image.asset(
            "assets/images/nurse02.png",
            width: 45,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _questionTile() {
    return Text("$testQues", textScaleFactor: 1, style: cTextQuestion);
  }

  Widget _choiceTile(BuildContext context, int _answerNum) {
    return GestureDetector(
      child: Container(
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          // padding: EdgeInsets.only(right: 0, left: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: choices[_answerNum - 1] == testAns && isAnswered
                  ? Colors.redAccent
                  : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
            color: answerNum == _answerNum
                ? Colors.green[100]
                : Colors.transparent,
          ),
          child: Text(choices[_answerNum - 1],
              textScaleFactor: 1, style: cTextChoiceLL)),
      onTap: () {
        if (!isAnswered) {
          answerNum = _answerNum;
          isAnswered = true;
          if (choices[_answerNum - 1] == testAns) {
            //todo 正解
            isCorrect = true;
            isCorrectImage = true;
            soundpool.play(soundIdCorrect);
            _datesLec[widget.index + numberOfLecture - 1].answered = "○";
            _dataLec.answered = "○";
            _dataLec.viewed = "済み";
            _dataLec.answeredDate =
                ConvertItems.instance.dateToInt(DateTime.now());
            _database.updateLecAtId(_dataLec);
            if (numberOfRemaining == 1) {
              nextTitle = "閉じる";
              nextIcon = Icon(Icons.close);
            } else {
              nextTitle = "次の講義へ";
              nextIcon = Icon(Icons.next_week);
            }
          } else {
            //todo 不正解
            isCorrect = false;
            isCorrectImage = true;
            soundpool.play(soundIdInCorrect);
            nextIcon = Icon(FontAwesomeIcons.backspace, color: Colors.white);
            nextTitle = "  講義へ戻る";
          }
          setState(() {});
        }
      },
    );
  }

  Widget _answerDescriptionTile() {
    if (isAnswered && testDesc.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          border: Border.all(width: 2, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Text("【解説】\n$testDesc", textScaleFactor: 1, style: cTextListL),
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

  Widget _testNextButton() {
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
            if (nextTitle == "講義へ戻る") {
              setState(() {
                _lecMode = LecMode.LECTURE;
                setLec();
              });
            } else {
              if (!isCorrectImage) {
                /// 音と○×が消えるまで受け付けない
                //todo 正解と解説を見る
                if (!isAnswered) {
                  /// 答えていない時に押されたら
                  soundpool.play(soundIdOpen);
                  isCorrect = true;
                  isAnswered = true;
                  nextTitle = "講義へ戻る";
                  nextIcon = Icon(Icons.close);
                  setState(() {});
                } else {
                  //todo 次へ進む
                  numberOfLecture += 1;
                  numberOfRemaining -= 1;
                  if (numberOfRemaining <= 0) {
                    Navigator.pop(context, widget.index + numberOfLecture - 1);
                  } else {
                    setState(() {
                      _lecMode = LecMode.LECTURE;
                      setLec();
                      //todo スクロールリスナー経由でスクロールを一番上に戻す
                      _homeController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 10),
                      );
                    });
                  }
                  // setState(() {});
                }
                // setState(() {});
              }
            }
          }),
    );
  }
}
