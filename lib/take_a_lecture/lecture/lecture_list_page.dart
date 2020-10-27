import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_argument.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/go_back.dart';
import '../../constants.dart';
import 'lecture_model.dart';
import 'lecture_play.dart';

class LectureListPage extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  final WorkshopList _workshopList;
  LectureListPage(this.groupName, this._organizer, this._workshopList);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.generateLectureList(groupName, _workshopList.workshopId);
      model.stopLoading();
    });
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          leading: GoBack.instance.goBack(
              context: context,
              icon: Icon(FontAwesomeIcons.chevronLeft),
              num: 1),
          actions: [
            GoBack.instance.goBack(
                context: context, icon: Icon(FontAwesomeIcons.home), num: 3),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 1, child: _infoArea()),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: model.lectureLists.length,
                    itemBuilder: (context, index) {
                      return Card(
                        key: Key(model.lectureLists[index].lecture.lectureId),
                        elevation: 15,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                          // dense: true,
                          leading: _leading(context, model, index),
                          title: _title(context, model, index),
                          subtitle: _subtitle(context, model, index),
                          trailing: _trailing(context, model, index),
                          onTap: () => _onTap(context, model, index),
                        ),
                      );
                    },
                  ),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(context),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" 講義一覧", style: cTextUpBarL, textScaleFactor: 1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("主催：", style: cTextUpBarS, textScaleFactor: 1),
                    Text(_workshopList.organizerName,
                        style: cTextUpBarS, textScaleFactor: 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("研修会：", style: cTextUpBarS, textScaleFactor: 1),
                    Text(_workshopList.title,
                        style: cTextUpBarS, textScaleFactor: 1),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<Slide>> _preparationOfSlide(
      model, _slideLength, _lectureId) async {
    List<Slide> _results = List();
    // スライドが登録されていたら準備をする
    if (_slideLength > 0) {
      _results = await FSSlide.instance.fetchDates(groupName, _lectureId);
    }
    return _results;
  }

  Widget _leading(BuildContext context, LectureModel model, int index) {
    final _imageUrl = model.lectureLists[index].lecture.thumbnailUrl ?? "";
    if (_imageUrl.isNotEmpty) {
      return Stack(
        children: [
          Container(
            width: 60,
            height: 50,
            color: Colors.black54.withOpacity(0.8),
            child: Image.network(_imageUrl),
          ),
          if (model.lectures[index].videoDuration.isNotEmpty)
            Container(
              width: 60,
              height: 50,
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black54.withOpacity(0.8),
                child: Text(
                  "${model.lectureLists[index].lecture.videoDuration}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                ),
              ),
            ),
        ],
      );
    } else {
      return Container(
        width: 60,
        height: 50,
        child: Image.asset(
          "assets/images/noImage.png",
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _title(BuildContext context, LectureModel model, int index) {
    return Text(
      "${model.lectureLists[index].lecture.title}",
      style: cTextListM,
      textScaleFactor: 1,
    );
  }

  Widget _subtitle(BuildContext context, LectureModel model, int index) {
    return Padding(
      padding: EdgeInsets.only(left: 25),
      child: Text(
        "${model.lectureLists[index].lecture.subTitle}",
        style: cTextListSS,
        textAlign: TextAlign.left,
        textScaleFactor: 1,
      ),
    );
  }

  Widget _trailing(BuildContext context, LectureModel model, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.lectureLists[index].lecture.questionLength != 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.greenAccent.withOpacity(0.2),
            // decoration: BoxDecoration(
            //   border: Border.all(width: 1.0, color: Colors.grey[600]),
            //   borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            //   color: Colors.greenAccent.withOpacity(0.2),
            // ),
            child: Text(
                "テスト:${model.lectureLists[index].lecture.questionLength}問",
                style: cTextListS,
                textScaleFactor: 1),
          ),
      ],
    );
  }

  Future<void> _onTap(
    BuildContext context,
    LectureModel model,
    int index,
  ) async {
    LectureArgument lectureArgument = LectureArgument();
    lectureArgument.isNextQuestion = true;

    while (lectureArgument.isNextQuestion) {
      final _slides1 = await _preparationOfSlide(
        model,
        model.lectureLists[index].lecture.slideLength,
        model.lectureLists[index].lecture.lectureId,
      );
      if (model.lectures[index].videoUrl.isNotEmpty) {
        //スマホの向きを一時的に上固定から横も可能にする
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
        ]);
      }
      // Trainingへ 終わったら値を受け取る
      lectureArgument = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LecturePlay(
            groupName,
            _organizer,
            _workshopList,
            model.lectureLists[index],
            _slides1,
            model.lectureLists.length - index == 1 ? true : false,
          ),
        ),
      );

      if (model.lectureLists[index].lecture.videoUrl.isNotEmpty) {
        //スマホの向きを上のみに戻す
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
      index = index + 1;
      // リストの最後まで来たら終わり
      if (index >= model.lectureLists.length) {
        lectureArgument.isNextQuestion = false;
      }
    }
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      notchMargin: 6.0,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(
          side: BorderSide(),
        ),
      ),
      child: Container(
        height: cBottomAppBarH,
        padding: EdgeInsets.all(10),
        child: Text("", style: cTextUpBarL, textScaleFactor: 1),
      ),
    );
  }
}
