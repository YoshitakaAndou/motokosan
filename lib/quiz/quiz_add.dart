// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/ok_show_dialog.dart';
// import '../constants.dart';
// import 'quiz_database_model.dart';
// import 'quiz_model.dart';
//
// class QuizAdd extends StatelessWidget {
//   final String quizId;
//   QuizAdd(this.quizId);
//
//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<QuizModel>(context);
//     final _database = DatabaseModel();
//     var _selectedValue = model.data.category;
//     var _selectData = [
//       CATEGORY01,
//       CATEGORY02,
//       CATEGORY03,
//       CATEGORY04,
//       CATEGORY05
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           "問題の新規登録",
//           style: cTextTitleL,
//           textScaleFactor: 1,
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: RaisedButton(
//               color: Colors.white,
//               shape: StadiumBorder(
//                 side: BorderSide(color: Colors.green),
//               ),
//               onPressed: () async {
//                 DateTime _timeStamp = DateTime.now();
//                 model.data.questionId = _timeStamp.toString(); //questionId
//                 try {
//                   model.startLoading();
//                   await model.addQuestionFsCloud(quizId, _timeStamp);
//                   await model.fetchQuestionsFsCloud(quizId);
//                   await _database.insertQuiz(model.data);
//                   await _database.updateQuizAtQId(model.datesFb);
//                   model.setDatesDb(await _database.getQuizzes());
//                   model.setDates(await _database.getQuizzes());
//                   model.stopLoading();
//                   await okShowDialog(context, "登録完了しました");
//                   Navigator.pop(context);
//                 } catch (e) {
//                   okShowDialog(context, e.toString());
//                   model.stopLoading();
//                 }
//               },
//               child: Text(
//                 "登録する",
//                 style: cTextListM,
//                 textScaleFactor: 1,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height - 50,
//             padding: EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Container(
//                 width: MediaQuery.of(context).size.width - 28,
//                 padding: EdgeInsets.all(14),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "項目名「${model.data.category}」",
//                           style: cTextListM,
//                           textScaleFactor: 1,
//                         ),
//                         PopupMenuButton<String>(
//                           icon: Icon(Icons.expand_more),
//                           initialValue: _selectedValue,
//                           onSelected: (String _category) {
//                             model.setCategory(_category);
//                           },
//                           itemBuilder: (BuildContext context) {
//                             return _selectData.map((String _category) {
//                               return PopupMenuItem(
//                                 child: Text(
//                                   _category,
//                                   textScaleFactor: 1,
//                                 ),
//                                 value: _category,
//                               );
//                             }).toList();
//                           },
//                         )
//                       ],
//                     ),
//                     TextField(
//                       maxLines: null,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                           labelText: "問題文",
//                           labelStyle: TextStyle(fontSize: 10),
//                           hintText: "問題文を入力してください",
//                           hintStyle: TextStyle(fontSize: 12)),
//                       onChanged: (text) {
//                         model.changeValue("question", text);
//                       },
//                     ),
//                     TextField(
//                       maxLines: null,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                           labelText: "選択肢 1",
//                           labelStyle: TextStyle(fontSize: 10),
//                           hintText: "選択肢 1 を入力してください",
//                           hintStyle: TextStyle(fontSize: 12)),
//                       onChanged: (text) {
//                         model.changeValue("option1", text);
//                       },
//                     ),
//                     TextField(
//                       maxLines: null,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                           labelText: "選択肢 2",
//                           labelStyle: TextStyle(fontSize: 10),
//                           hintText: "選択肢 2 を入力してください",
//                           hintStyle: TextStyle(fontSize: 12)),
//                       onChanged: (text) {
//                         model.changeValue("option2", text);
//                       },
//                     ),
//                     TextField(
//                       maxLines: null,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                           labelText: "選択肢 3",
//                           labelStyle: TextStyle(fontSize: 10),
//                           hintText: "選択肢 3 を入力してください",
//                           hintStyle: TextStyle(fontSize: 12)),
//                       onChanged: (text) {
//                         model.changeValue("option3", text);
//                       },
//                     ),
//                     TextField(
//                       maxLines: null,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                           labelText: "選択肢 4",
//                           labelStyle: TextStyle(fontSize: 10),
//                           hintText: "選択肢 4 を入力してください",
//                           hintStyle: TextStyle(fontSize: 12)),
//                       onChanged: (text) {
//                         model.changeValue("option4", text);
//                       },
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             "正解：${model.correct ?? ""}",
//                             style: cTextListM,
//                             textScaleFactor: 1,
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: _answerSelection(
//                               model, context, "1", "選択肢1", model.data.option1),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: _answerSelection(
//                               model, context, "2", "選択肢2", model.data.option2),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: _answerSelection(
//                               model, context, "3", "選択肢3", model.data.option3),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: _answerSelection(
//                               model, context, "4", "選択肢4", model.data.option4),
//                         ),
//                       ],
//                     ),
//                     Divider(
//                       height: 5,
//                       color: Colors.grey,
//                       thickness: 1,
//                     ),
//                     TextField(
//                       maxLines: null,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                           labelText: "解答・説明",
//                           labelStyle: TextStyle(fontSize: 10),
//                           hintText: "解答・説明を入力してください",
//                           hintStyle: TextStyle(fontSize: 12)),
//                       onChanged: (text) {
//                         model.changeValue("answerDescription", text);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (model.isLoading)
//             Container(
//                 color: Colors.grey.withOpacity(0.5),
//                 child: Center(child: CircularProgressIndicator())),
//         ],
//       ),
//     );
//   }
//
//   Widget _answerSelection(
//     model,
//     context,
//     label,
//     choice,
//     option,
//   ) {
//     // return Consumer<QuizModel>(builder: (context, model, child) {
//     return RaisedButton(
//       child: Text(
//         label,
//         style: cTextListL,
//         textScaleFactor: 1,
//       ),
//       color: model.correct == choice ? Colors.greenAccent : Colors.white,
//       shape: CircleBorder(
//         side: BorderSide(
//           color: Colors.black,
//           width: 1.0,
//           style: BorderStyle.solid,
//         ),
//       ),
//       onPressed: () {
//         print("$choice:$option");
//         if (option.isEmpty) {
//           okShowDialog(context, "$choiceが入力されていません！");
//         } else {
//           model.setCorrectOption(choice);
//         }
//       },
//     );
//     // });
//   }
// }
