import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:photo_view/photo_view.dart';
import '../../constants.dart';

import 'package:soundpool/soundpool.dart';

import 'qa_model.dart';

class QaPlay extends StatefulWidget {
  final List<QuesAns> datesQa;
  final int index;

  QaPlay({
    this.datesQa,
    this.index,
  });

  @override
  _QaPlayState createState() => _QaPlayState();
}

class _QaPlayState extends State<QaPlay> {
  final ScrollController _homeController = ScrollController();
  List<String> choices = List();
  List<QuesAns> _datesQa = List();
  QuesAns _dataQa;
  int numberOfRemaining;
  int numberOfCorrect = 0;
  int numberOfQuestion = 1;
  Soundpool soundpool;
  int soundIdCorrect = 0;
  int soundIdInCorrect = 0;
  int soundIdOpen = 0;
  String nextTitle = "";
  Icon nextIcon;
  // 状態設定
  int answerNum = 0;
  bool isPopWind = false;

  @override
  void initState() {
    super.initState();
    _datesQa = widget.datesQa;
    numberOfRemaining = _datesQa.length - widget.index;
    initSounds();
    setQa();
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
    _datesQa = List();
  }

  //todo データの作成
  void setQa() {
    _dataQa = _datesQa[widget.index + numberOfQuestion - 1];

    if (numberOfRemaining == 1) {
      nextTitle = "閉じる";
      nextIcon = Icon(Icons.close);
    } else {
      nextTitle = "次　へ";
      nextIcon = Icon(Icons.next_week);
    }

    //todo 初期化
    answerNum = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
        SingleChildScrollView(
          controller: _homeController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //todo カテゴリー表示
              _categoryTile(),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _questionTile(),
                        SizedBox(height: 10),
                        _answerTile(),
                        SizedBox(height: 20),
                        _descriptionTile(),
                        SizedBox(height: 20),
                        _nextButton(),
                        SizedBox(height: 30)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isPopWind) _popWind(),
      ]),
    );
  }

  Widget _categoryTile() {
    return Container(
      height: 30,
      width: double.infinity,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "放射線Q&A",
              style: cTextUpBarL,
              textScaleFactor: 1,
            ),
            Text(
              "${_dataQa.category}",
              style: cTextUpBarM,
              textScaleFactor: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionTile() {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${_dataQa.question}?",
                textScaleFactor: 1,
                style: cTextQuestion,
              ),
            ),
          ),
          SizedBox(
            height: 70,
            child: Image.asset(
              "assets/images/question.png",
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerTile() {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          SizedBox(
            height: 70,
            child: Image.asset(
              "assets/images/answer1.png",
              fit: BoxFit.scaleDown,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${_dataQa.answer}!",
                textScaleFactor: 1,
                style: cTextQuestion,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("【解説】", textScaleFactor: 1, style: cTextListL),
          if (_dataQa.imageUrl != "")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    isPopWind = !isPopWind;
                    setState(() {});
                  },
                  child: CachedNetworkImage(
                    imageUrl: _dataQa.imageUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          Text("${_dataQa.description}", textScaleFactor: 1, style: cTextListL),
        ],
      ),
    );
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
          //todo 次へ進む
          numberOfQuestion += 1;
          numberOfRemaining -= 1;
          if (numberOfRemaining == 0) {
            Navigator.pop(context);
          } else {
            setQa();
            //todo スクロールリスナー経由でスクロールを一番上に戻す
            _homeController.animateTo(
              0.0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 10),
            );
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _popWind() {
    return GestureDetector(
      onTap: () {
        isPopWind = !isPopWind;
        setState(() {});
      },
      child: PhotoView(
        initialScale: 1.0,
        backgroundDecoration:
            BoxDecoration(color: Colors.grey.withOpacity(0.8)),
        imageProvider: CachedNetworkImageProvider(_dataQa.imageUrl, scale: 1),
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
}
