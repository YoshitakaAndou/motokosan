// import 'package:flutter/material.dart';
// import '../quiz/quiz_model.dart';
// import '../widgets/bar_title.dart';
// import '../widgets/go_back_one.dart';
//
// class QuizEnd extends StatelessWidget {
//   final List<Question> datesAns;
//   QuizEnd({this.datesAns});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: barTitle(context),
//         leading: goBackOne(context: context, icon: Icon(Icons.home)),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height - 170,
//           child: ListView.builder(
//               itemCount: datesAns.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(datesAns[index].question),
//                   subtitle: Text("チャレンジ日：${datesAns[index].updateAt}"),
//                   trailing: Text(datesAns[index].answered),
//                 );
//               }),
//         ),
//       ),
//     );
//   }
// }
