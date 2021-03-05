import 'package:flutter/material.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:provider/provider.dart';


class LectureEditQuestion extends StatelessWidget {
  final String groupName;
  final Lecture lecture;
  final Workshop workshop;
  final Organizer organizer;
  LectureEditQuestion(
    this.groupName,
    this.lecture,
    this.workshop,
    this.organizer,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                _infoArea(model),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _testTile(context, model),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
            if (model.isLoading)
              Container(
                color: Colors.black87.withOpacity(0.8),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    });
  }

  Widget _infoArea(LectureModel model) {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text("　番号：${lecture.lectureNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("主催：${organizer.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                  Text("研修会：${workshop.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testTile(BuildContext context, LectureModel model) {
    return Column(
      children: [
        _testTitle(context, model),
        _testAllAnswers(context, model),
        SizedBox(height: 10),
        if (model.lecture.allAnswers == "全問解答が必要")
          _testPassingScore(context, model),
      ],
    );
  }

  Widget _testTitle(BuildContext context, LectureModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "■　確認テスト",
            style: cTextListM,
            textScaleFactor: 1,
          ),
          Text(
            "${model.lecture.questionLength}問",
            style: cTextListM,
            textScaleFactor: 1,
          ),
        ],
      ),
    );
  }

  Widget _testAllAnswers(BuildContext context, LectureModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cPopWindow),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
              ),
              color: cPopWindow,
            ),
            child: Center(
                child:
                    Text("  受講完了の条件は？", style: cTextPopM, textScaleFactor: 1)),
          ),
          RadioListTile(
            title: Text('全問解答が必要', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: "全問解答が必要",
            groupValue: model.lecture.allAnswers,
            onChanged: (value) {
              model.setAllAnswers(value);
              model.setUpdate();
            },
          ),
          RadioListTile(
            title: Text('全問解答は不要', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: "全問解答は不要",
            groupValue: model.lecture.allAnswers,
            onChanged: (value) {
              model.setAllAnswers(value);
              model.setUpdate();
            },
          ),
        ],
      ),
    );
  }

  Widget _testPassingScore(BuildContext context, LectureModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cPopWindow),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
                color: cPopWindow,
              ),
              child: Center(
                child: Text("  確認テストの合格条件は？",
                    style: cTextPopM, textScaleFactor: 1),
              )),
          RadioListTile(
            title: Text('全問正解で合格', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 100,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setUpdate();
            },
          ),
          RadioListTile(
            title: Text('60点以上が合格', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 60,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setUpdate();
            },
          ),
          RadioListTile(
            title: Text('特に合格点数は設けない', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 0,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setUpdate();
            },
          ),
        ],
      ),
    );
  }
}
