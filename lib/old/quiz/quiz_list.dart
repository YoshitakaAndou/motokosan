// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/bar_title.dart';
// import '../widgets/go_back_one.dart';
// import '../widgets/bubble/bubble.dart';
// import '../constants.dart';
// import 'quiz_database_model.dart';
// import 'quiz_model.dart';
// import 'quiz_play.dart';
//
// class QuizList extends StatelessWidget {
//   final String quizId;
//   QuizList({this.quizId});
//
//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<QuizModel>(context, listen: false);
//     final _database = DatabaseModel();
//     String dropdownValue = '×:不正解';
//     Future(() async {
//       model.setDatesSg(await _database.getWhereQuizzes("×"));
//     });
//     return Consumer<QuizModel>(builder: (context, model, child) {
//       //todo list_question
//
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: barTitle(context),
//           leading: goBackOne(context: context, icon: Icon(Icons.home)),
//           actions: [
//             GestureDetector(
//               onTap: () {
//                 if (!model.isHelp) {
//                   model.setIsHelp(true);
//                 } else {
//                   model.setIsHelp(false);
//                 }
//               },
//               child: !model.isHelp
//                   ? Image.asset(
//                       "assets/images/question.png",
//                       width: 60,
//                       alignment: Alignment.topCenter,
//                       fit: BoxFit.fitWidth,
//                     )
//                   : Icon(Icons.close),
//             ),
//             SizedBox(width: 20),
//           ],
//         ),
//         body: Column(
//           children: [
//             _infoArea(model, _database, dropdownValue),
//             if (model.isHelp) _helpTile(),
//             model.datesSg.length < 1 ? Container() : _listTile(context, model),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _infoArea(QuizModel model, DatabaseModel _database, dropdownValue) {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       color: cContBg,
//       child: Row(
//         children: [
//           Expanded(
//               flex: 3,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: Text("解答済み問題", style: cTextUpBarL, textScaleFactor: 1),
//               )),
//           Expanded(
//             flex: 3,
//             child: _dropDownList(
//               dropdownValue: dropdownValue,
//               onChanged: (String newValue) async {
//                 dropdownValue = newValue;
//                 if (dropdownValue == "×:不正解") {
//                   model.setDatesSg(await _database.getWhereQuizzes("×"));
//                 } else {
//                   model.setDatesSg(await _database.getWhereQuizzes("○"));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _helpTile() {
//     return Container(
//       height: 50,
//       width: double.infinity,
//       color: cContBg,
//       child: Row(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           // Icon(Icons.comment, color: Colors.black54, size: 12),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8),
//             child: Bubble(
//               color: Color.fromRGBO(225, 255, 199, 1.0),
//               nip: BubbleNip.rightBottom,
//               nipWidth: 10,
//               nipHeight: 5,
//               child: Text(
//                 " 右上のリストから○×の項目を選んでください。"
//                 "\n下のリストをTapすると問題解説を表示します。",
//                 style: TextStyle(fontSize: 10),
//                 textScaleFactor: 1,
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           Image.asset(
//             "assets/images/nurse02.png",
//             width: 45,
//             alignment: Alignment.topCenter,
//             fit: BoxFit.cover,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _dropDownList({dropdownValue, Function onChanged}) {
//     return Container(
//       width: double.infinity,
//       color: cContBg,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               SizedBox(width: 10),
//               DropdownButton<String>(
//                 value: dropdownValue,
//                 icon: Icon(Icons.arrow_drop_down),
//                 iconSize: 20,
//                 elevation: 20,
//                 style: cTextUpBarL,
//                 dropdownColor: Colors.green[700],
//                 underline: Container(
//                   height: 2,
//                   color: Colors.white,
//                 ),
//                 onChanged: (String newValue) => onChanged(newValue),
//                 items: <String>['×:不正解', '○:️正解']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(width: 10),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _listTile(BuildContext context, QuizModel model) {
//     final ScrollController _homeController = ScrollController();
//     return SingleChildScrollView(
//       controller: _homeController,
//       child: Container(
//         padding: EdgeInsets.all(8),
//         height: model.isHelp
//             ? MediaQuery.of(context).size.height - 200
//             : MediaQuery.of(context).size.height - 170,
//         child: ListView.builder(
//             itemCount: model.datesSg.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 elevation: 15,
//                 child: ListTile(
//                   dense: true,
//                   leading: SizedBox(
//                     width: 40,
//                     child: Text(
//                       model.datesSg[index].answered,
//                       textAlign: TextAlign.center,
//                       textScaleFactor: 1,
//                       style: TextStyle(
//                           fontSize: 25,
//                           fontWeight: FontWeight.w800,
//                           color: model.datesSg[index].answered == "○"
//                               ? Colors.red
//                               : Colors.black54),
//                     ),
//                   ),
//                   title: _questionTile(model.datesSg[index].question),
//                   onTap: () async {
//                     await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => QuizPlay(
//                                   datesQs: model.datesSg,
//                                   index: index,
//                                   isShowOnly: true,
//                                 )));
//                   },
//                 ),
//               );
//             }),
//       ),
//     );
//   }
//
//   Widget _questionTile(_dataQsQuestion) {
//     final List<String> _keyWords = ["正しい", "誤って", "誤った"];
//     for (String _keyWord in _keyWords) {
//       if (_dataQsQuestion.contains(_keyWord)) {
//         final List<String> _questionText = _dataQsQuestion.split(_keyWord);
//         return _richText(_questionText[0], _keyWord, _questionText[1]);
//       }
//     }
//     return Text("$_dataQsQuestion", textScaleFactor: 1, style: cTextListM);
//   }
//
//   Widget _richText(_text1, _text2, _text3) {
//     const double _fontSize = 13.0;
//     return RichText(
//       text: TextSpan(
//         children: <TextSpan>[
//           TextSpan(
//             text: _text1,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: _fontSize,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           TextSpan(
//             text: _text2,
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: _fontSize,
//               fontWeight: FontWeight.w500,
//               // decoration: TextDecoration.underline,
//             ),
//           ),
//           TextSpan(
//             text: _text3,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: _fontSize,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
