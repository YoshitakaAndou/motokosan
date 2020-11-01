// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/go_back_one.dart';
// import '../widgets/ok_show_dialog_func.dart';
// import '../widgets/ok_show_dialog.dart';
// import 'quiz_database_model.dart';
// import '../constants.dart';
// import 'quiz_model.dart';
// import '../quiz/quiz_add.dart';
// import '../quiz/quiz_edit.dart';
// import '../quiz/quiz_db.dart';
//
// class QuizFs extends StatelessWidget {
//   final String quizId;
//
//   QuizFs({this.quizId});
//
//   @override
//   Widget build(BuildContext context) {
//     final _database = DatabaseModel();
//     final model = Provider.of<QuizModel>(context, listen: false);
//     Future(() async {
//       await model.fetchQuestionsFsCloud(quizId);
//     });
//     return Consumer<QuizModel>(builder: (context, model, child) {
//       return Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             "Cloud上のデータ",
//             style: cTextTitleL,
//             textScaleFactor: 1,
//           ),
//           leading: goBackOne(context: context, icon: Icon(Icons.home)),
//           actions: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Center(
//                 child: Text(
//                   "${model.datesFb.length}件   ",
//                   style: cTextTitleS,
//                   textScaleFactor: 1,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               child: ListView.builder(
//                   itemCount: model.datesFb.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       elevation: 15,
//                       child: ListTile(
//                         title: Text(
//                           "${model.datesFb[index].question}",
//                           style: cTextListM,
//                           textScaleFactor: 1,
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(Icons.edit),
//                           iconSize: 18,
//                           //todo 編集画面へ
//                           onPressed: () async {
//                             model.initBeforeEditing(model.datesFb[index]);
//                             model.setCorrectForEditing();
//                             await Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => QuizEdit(
//                                         model.datesFb[index], quizId)));
//                             model.initData();
//                             await model.fetchQuestionsFsCloud(quizId);
//                           },
//                         ),
//                         onTap: () async {
//                           model.initBeforeEditing(model.datesFb[index]);
//                           model.setCorrectForEditing();
//                           await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       QuizEdit(model.datesFb[index], quizId)));
//                           await model.fetchQuestionsFsCloud(quizId);
//                         },
//                         // delete
//                         onLongPress: () {
//                           okShowDialogFunc(
//                             context: context,
//                             mainTitle: model.datesFb[index].question,
//                             subTitle: "削除しますか？",
//                             onPressed: () async {
//                               try {
//                                 model.startLoading();
//                                 await model.deleteQuestionFsCloud(
//                                     quizId, model.datesFb[index].questionId);
//                                 await _database.deleteQuizQid(
//                                     model.datesFb[index].questionId);
//                                 model.setDatesDb(await _database.getQuizzes());
//                                 model.setDates(await _database.getQuizzes());
//                                 model.stopLoading();
//                                 Navigator.pop(context);
//                               } catch (e) {
//                                 okShowDialog(context, e.toString());
//                               }
//                               await model.fetchQuestionsFsCloud(quizId);
//                             },
//                           );
//                         },
//                       ),
//                     );
//                   }),
//             ),
//             if (model.isLoading)
//               Container(
//                   color: Colors.grey.withOpacity(0.5),
//                   child: Center(child: CircularProgressIndicator())),
//           ],
//         ),
//         bottomNavigationBar: BottomAppBar(
//           child: BottomNavigationBar(
//             currentIndex: 0,
//             items: [
//               BottomNavigationBarItem(
//                 label: "Cloud",
//                 icon: Icon(Icons.cloud),
//               ),
//               BottomNavigationBarItem(
//                 label: "本体",
//                 icon: Icon(Icons.phone_android),
//               ),
//             ],
//             onTap: (index) {
//               if (index == 1) {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => QuizDb(
//                             questionsFb: model.datesFb, quizId: quizId)));
//               }
//             },
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.add),
//           onPressed: () async {
//             model.initData();
//             model.data.category = CATEGORY01;
//             await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => QuizAdd(quizId),
//                   fullscreenDialog: true,
//                 ));
//             await model.fetchQuestionsFsCloud(quizId);
//           },
//         ),
//       );
//     });
//   }
// }
