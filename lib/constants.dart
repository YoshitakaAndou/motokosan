import 'package:flutter/material.dart';

// youtubeの再生時間（短い値）
int videoEndAt = 5;

//FireBaseのID
const String cQuizId = "Question:2020-08-18";
const String cQasId = "QA:2020-08-29";
const String cLecsId = "Lecture:2020-09-05";
//カテゴリーの名前
const String CATEGORY01 = "医療被ばくの基本的考え方";
const String CATEGORY02 = "放射線診療の正当化";
const String CATEGORY03 = "放射線診療の防護の最適化";
const String CATEGORY04 = "放射線障害が生じた場合の対応";
const String CATEGORY05 = "患者への情報提供";

// toolBarの高さ
const double cToolBarH = 40.0;
// infoAreaの高さ
const double cInfoAreaH = 50.0;
// bottomAppBarのContainerの高さ
const double cBottomAppBarH = 45.0;
// listの高さ用offset値
const double cListOffsetH = 220;
// listの幅用offset値
const double cListOffsetW = 10;
// edit/add areaの高さ用offset値
const double cEditOffsetH = 170;
// edit/add areaの幅用offset値
const double cEditOffsetW = 20;
//上下のバー
const cContBg = Colors.green;
// Data編集リストのCardの左端の色
const cCardLeft = Colors.green; //編集画面

//Edit/AddのpopWindow
const cPopWindow = Colors.black26;
const cTextPopIcon = Colors.black54;
const cTextPopM = TextStyle(
  color: Colors.black54,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
const cTextPopS = TextStyle(
  color: Colors.black54,
  fontSize: 10,
  fontWeight: FontWeight.w600,
);

// フローティングアクションボタンのshape
final cFABShape = OutlineInputBorder(
  borderSide: BorderSide(width: 3, color: Colors.white),
  borderRadius: BorderRadius.all(Radius.circular(15.0)),
);

// リストカードのshape
final cListCardShape = OutlineInputBorder(
  borderSide: BorderSide(width: 0.5, color: Colors.grey),
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
);

// FABの色
final cFAB = Colors.green[800];

// ボトムシートのボタン
final cBSButton = Colors.grey[50];
// クイズの答えボタン
final cQuizButton = Colors.grey[50];

// ボトムシートのバック色
final cBSBack = Colors.white;

//Text
final TextStyle cTextTitleLIndigo = TextStyle(
  color: Colors.indigo,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
final TextStyle cTextTitleL = TextStyle(
  color: Colors.green[700],
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
final TextStyle ceTextTitleL = TextStyle(
  color: Colors.orange[700],
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
const cTextTitleM = TextStyle(
  color: Colors.green,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
const cTextTitleS = TextStyle(
  color: Colors.green,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
const cTextUpBarLL = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);
const cTextUpBarL = TextStyle(
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.w600,
);
const cTextUpBarM = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
const cTextUpBarS = TextStyle(
  color: Colors.white,
  fontSize: 10,
  fontWeight: FontWeight.w600,
);
const cTextUpBarSS = TextStyle(
  color: Colors.white,
  fontSize: 8,
  fontWeight: FontWeight.w600,
);
const cTextButtonL = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
const cTextUnderBarS = TextStyle(
  color: Colors.black54,
  fontSize: 10,
  fontWeight: FontWeight.w600,
);
const cTextUnderBarSS = TextStyle(
  color: Colors.black,
  fontSize: 8,
  fontWeight: FontWeight.w600,
);
const cTextUnderBarM = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
const cTextListL = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontWeight: FontWeight.w300,
);
const cTextListM = TextStyle(
  color: Colors.black,
  fontSize: 13,
  fontWeight: FontWeight.w500,
);
const cTextListMR = TextStyle(
  color: Colors.red,
  fontSize: 13,
  fontWeight: FontWeight.w500,
);
const cTextListS = TextStyle(
  color: Colors.black,
  fontSize: 10,
  fontWeight: FontWeight.w300,
);
const cTextListSR = TextStyle(
  color: Colors.red,
  fontSize: 10,
  fontWeight: FontWeight.w300,
);
const cTextListSS = TextStyle(
  color: Colors.black,
  fontSize: 8,
  fontWeight: FontWeight.w300,
);

//PlayQuestion
const cTextQuestion = TextStyle(
  color: Colors.black,
  fontSize: 15,
  fontWeight: FontWeight.w900,
);
final cTextInstruction = TextStyle(
  color: Colors.blue[700],
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
const cTextChoice = TextStyle(
  color: Colors.black87,
  fontSize: 15,
  fontWeight: FontWeight.w500,
);
const cTextChoiceLL = TextStyle(
  color: Colors.black87,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);
const cTextAlertL = TextStyle(
  color: Colors.black87,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);
const cTextAlertMes = TextStyle(
  color: Colors.black87,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);
const cTextAlertYes = TextStyle(
  color: Colors.deepOrange,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);
const cTextAlertNo = TextStyle(
  color: Colors.blueAccent,
  fontSize: 14,
  fontWeight: FontWeight.w300,
);
