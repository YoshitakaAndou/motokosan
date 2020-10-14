// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../constants.dart';
// import '../widgets/ok_show_dialog.dart';
// import 'quiz_database_model.dart';
// import 'quiz_model.dart';
//
// class QuizEdit extends StatelessWidget {
//   final Question _question;
//   final String quizId;
//   QuizEdit(this._question, this.quizId);
//
//   @override
//   Widget build(BuildContext context) {
//     final qsTextController = TextEditingController();
//     final op1TextController = TextEditingController();
//     final op2TextController = TextEditingController();
//     final op3TextController = TextEditingController();
//     final op4TextController = TextEditingController();
//     final adTextController = TextEditingController();
//     qsTextController.text = _question.question;
//     op1TextController.text = _question.option1;
//     op2TextController.text = _question.option2;
//     op3TextController.text = _question.option3;
//     op4TextController.text = _question.option4;
//     adTextController.text = _question.answerDescription;
//
//     var _selectedValue = _question.category;
//     var _selectData = [
//       CATEGORY01,
//       CATEGORY02,
//       CATEGORY03,
//       CATEGORY04,
//       CATEGORY05
//     ];
//
//     final _database = DatabaseModel();
//
//     return Consumer<QuizModel>(builder: (context, model, child) {
//       //todo edit_question
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             "問題の編集",
//             style: cTextTitleL,
//             textScaleFactor: 1,
//           ),
//           actions: [
//             if (model.isUpdate)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: RaisedButton(
//                   color: Colors.white,
//                   shape: StadiumBorder(
//                     side: BorderSide(color: Colors.green),
//                   ),
//                   onPressed: () async {
//                     model.data.question = qsTextController.text;
//                     model.data.option1 = op1TextController.text;
//                     model.data.option2 = op2TextController.text;
//                     model.data.option3 = op3TextController.text;
//                     model.data.option4 = op4TextController.text;
//                     model.data.answerDescription = adTextController.text;
//                     try {
//                       model.startLoading();
//                       await model.updateQuestionFsCloud(
//                           quizId, _question.questionId);
//                       await model.fetchQuestionsFsCloud(quizId);
//                       await _database.updateQuizAtQId(model.datesFb);
//                       model.setDatesDb(await _database.getQuizzes());
//                       model.setDates(await _database.getQuizzes());
//                       model.stopLoading();
//                       await okShowDialog(context, "更新しました");
//                       Navigator.pop(context);
//                     } catch (e) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text(
//                     "更新する",
//                     style: cTextListM,
//                     textScaleFactor: 1,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height - 50,
//               padding: EdgeInsets.all(10),
//               child: SingleChildScrollView(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width - 28,
//                   padding: EdgeInsets.all(14),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "項目名「${model.data.category}」",
//                             style: cTextListM,
//                             textScaleFactor: 1,
//                           ),
//                           PopupMenuButton<String>(
//                             icon: Icon(Icons.expand_more),
//                             initialValue: _selectedValue,
//                             onSelected: (String _category) {
//                               model.isUpdate = true;
//                               model.setCategory(_category);
//                             },
//                             itemBuilder: (BuildContext context) {
//                               return _selectData.map((String _category) {
//                                 return PopupMenuItem(
//                                   child: Text(
//                                     _category,
//                                     textScaleFactor: 1,
//                                   ),
//                                   value: _category,
//                                 );
//                               }).toList();
//                             },
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextField(
//                         maxLines: null,
//                         textInputAction: TextInputAction.done,
//                         decoration: const InputDecoration(
//                             labelText: "問題文",
//                             labelStyle: TextStyle(fontSize: 10),
//                             hintText: "問題文を入力してください",
//                             hintStyle: TextStyle(fontSize: 10)),
//                         controller: qsTextController,
//                         onChanged: (text) {
//                           model.changeValue("question", text);
//                           model.isUpdate = true;
//                         },
//                       ),
//                       TextField(
//                         maxLines: null,
//                         textInputAction: TextInputAction.done,
//                         decoration: const InputDecoration(
//                             labelText: "選択肢 1",
//                             labelStyle: TextStyle(fontSize: 10),
//                             hintText: "選択肢 1 を入力してください",
//                             hintStyle: TextStyle(fontSize: 12)),
//                         controller: op1TextController,
//                         onChanged: (text) {
//                           model.changeValue("option1", text);
//                           model.isUpdate = true;
//                         },
//                       ),
//                       TextField(
//                         maxLines: null,
//                         textInputAction: TextInputAction.done,
//                         decoration: const InputDecoration(
//                             labelText: "選択肢 2",
//                             labelStyle: TextStyle(fontSize: 10),
//                             hintText: "選択肢 2 を入力してください",
//                             hintStyle: TextStyle(fontSize: 12)),
//                         controller: op2TextController,
//                         onChanged: (text) {
//                           model.changeValue("option2", text);
//                           model.isUpdate = true;
//                         },
//                       ),
//                       TextField(
//                         maxLines: null,
//                         textInputAction: TextInputAction.done,
//                         decoration: const InputDecoration(
//                             labelText: "選択肢 3",
//                             labelStyle: TextStyle(fontSize: 10),
//                             hintText: "選択肢 3 を入力してください",
//                             hintStyle: TextStyle(fontSize: 12)),
//                         controller: op3TextController,
//                         onChanged: (text) {
//                           model.changeValue("option3", text);
//                           model.isUpdate = true;
//                         },
//                       ),
//                       TextField(
//                         maxLines: null,
//                         textInputAction: TextInputAction.done,
//                         decoration: const InputDecoration(
//                             labelText: "選択肢 4",
//                             labelStyle: TextStyle(fontSize: 10),
//                             hintText: "選択肢 4 を入力してください",
//                             hintStyle: TextStyle(fontSize: 12)),
//                         controller: op4TextController,
//                         onChanged: (text) {
//                           model.changeValue("option4", text);
//                           model.isUpdate = true;
//                         },
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "正解：${model.correct ?? ""}",
//                               style: cTextListM,
//                               textScaleFactor: 1,
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: _answerSelection(
//                                 context, "1", "選択肢1", model.data.option1),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: _answerSelection(
//                                 context, "2", "選択肢2", model.data.option2),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: _answerSelection(
//                                 context, "3", "選択肢3", model.data.option3),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: _answerSelection(
//                                 context, "4", "選択肢4", model.data.option4),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         height: 5,
//                         color: Colors.grey,
//                         thickness: 1,
//                       ),
//                       TextField(
//                         maxLines: null,
//                         textInputAction: TextInputAction.done,
//                         decoration: const InputDecoration(
//                             labelText: "解答・説明",
//                             labelStyle: TextStyle(fontSize: 10),
//                             hintText: "解答・説明を入力してください",
//                             hintStyle: TextStyle(fontSize: 12)),
//                         controller: adTextController,
//                         onChanged: (text) {
//                           model.changeValue("answerDescription", text);
//                           model.isUpdate = true;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             if (model.isLoading)
//               Container(
//                   color: Colors.grey.withOpacity(0.5),
//                   child: Center(child: CircularProgressIndicator())),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _answerSelection(context, label, choice, option) {
//     return Consumer<QuizModel>(builder: (context, model, child) {
//       return RaisedButton(
//         child: Text(
//           label,
//           style: cTextListL,
//           textScaleFactor: 1,
//         ),
//         color: model.correct == choice ? Colors.greenAccent : Colors.white,
//         shape: CircleBorder(
//           side: BorderSide(
//             color: Colors.black,
//             width: 1.0,
//             style: BorderStyle.solid,
//           ),
//         ),
//         onPressed: () {
//           if (option.isEmpty) {
//             okShowDialog(context, "$choiceが入力されていません！");
//           } else {
//             model.setCorrectOption(choice);
//             model.isUpdate = true;
//           }
//         },
//       );
//     });
//   }
// }
