import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../take_a_lecture/lecture/lecture_model.dart';

class LectureAddQuestion extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  final Workshop _workshop;
  LectureAddQuestion(this.groupName, this._organizer, this._workshop);

  final BoxDecoration _boxDecoration = BoxDecoration(
    border: Border.all(color: cPopWindow),
    borderRadius: BorderRadius.circular(5),
  );

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    model.lecture.lectureNo =
        (model.lectures.length + 1).toString().padLeft(4, "0");

    return Consumer<LectureModel>(builder: (context, model, child) {
      model.isEditing = _checkValue(model);
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

  bool _checkValue(LectureModel model) {
    bool _result = false;
    _result = model.lecture.title.isNotEmpty ? true : _result;
    _result = model.lecture.subTitle.isNotEmpty ? true : _result;
    _result = model.lecture.description.isNotEmpty ? true : _result;
    _result = model.lecture.videoUrl.isNotEmpty ? true : _result;
    _result = model.lecture.thumbnailUrl.isNotEmpty ? true : _result;
    _result = model.slides.length > 1 ? true : _result;
    return _result;
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
              child: Text("　番号：${model.lecture.lectureNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("主催：${_organizer.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                  Text("研修会：${_workshop.title}",
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
      decoration: _boxDecoration,
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
              model.setIsEditing();
            },
          ),
          RadioListTile(
            title: Text('全問解答は不要', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: "全問解答は不要",
            groupValue: model.lecture.allAnswers,
            onChanged: (value) {
              model.setAllAnswers(value);
              model.setIsEditing();
            },
          ),
        ],
      ),
    );
  }

  Widget _testPassingScore(BuildContext context, LectureModel model) {
    return Container(
      decoration: _boxDecoration,
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
              model.setIsEditing();
            },
          ),
          RadioListTile(
            title: Text('60点以上が合格', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 60,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setIsEditing();
            },
          ),
          RadioListTile(
            title: Text('特に合格点数は設けない', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 0,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setIsEditing();
            },
          ),
        ],
      ),
    );
  }
}
