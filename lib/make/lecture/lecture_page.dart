import 'package:flutter/material.dart';
import 'package:motokosan/home/home.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_firebase.dart';
import 'package:motokosan/make/lecture/lecture_add_main.dart';
import 'package:motokosan/make/lecture/lecture_edit_main.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/show_dialog.dart';
import '../../constants.dart';
import '../question/question_page.dart';
import '../../take_a_lecture/lecture/lecture_model.dart';

class LecturePage extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  final Workshop _workshop;
  LecturePage(this._userData, this._organizer, this._workshop);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    model.lecture.organizerId = _organizer.organizerId;
    model.lecture.workshopId = _workshop.workshopId;
    Future(() async {
      model.startLoading();
      await model.fetchLecture(_userData.userGroup, _workshop.workshopId);
      model.stopLoading();
    });
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: BarTitle.instance.barTitle(context),
          actions: [
            _homeButton(context),
          ],
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _infoArea()),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  _listBody(context, model),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _floatingActionButton(context, model),
        bottomNavigationBar: _bottomAppBar(context, model),
      );
    });
  }

  Widget _homeButton(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.home),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => Home(_userData),
          ),
        );
      },
    );
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
            Expanded(
                flex: 2,
                child: Text(" 講義を編集", style: cTextUpBarL, textScaleFactor: 1)),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    // border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Text("研修会：", style: cTextListS, textScaleFactor: 1),
                          Text(
                            "${_organizer.title}",
                            style: cTextUpBarS,
                            textScaleFactor: 1,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 10),
                          Text(
                            " ${_workshop.title}",
                            style: cTextUpBarS,
                            textScaleFactor: 1,
                            maxLines: 1,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, LectureModel model) async {
    final FSLecture fsLecture = FSLecture();
    try {
      int _count = 1;
      for (Lecture _data in model.lectures) {
        _data.lectureNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await fsLecture.setData(
            false, _userData.userGroup, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchLecture(_userData.userGroup, _workshop.workshopId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
    }
  }

  Widget _listBody(BuildContext context, LectureModel model) {
    return ReorderableListView(
      children: model.lectures.map(
        (_lecture) {
          return _listItem(context, model, _lecture);
        },
      ).toList(),
      // ドラッグで移動できる様にする
      onReorder: (oldIndex, newIndex) {
        model.startLoading();
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final _move = model.lectures.removeAt(oldIndex);
        model.lectures.insert(newIndex, _move);
        _sortedSave(context, model);
        model.stopLoading();
      },
    );
  }

  Widget _listItem(BuildContext context, LectureModel model, Lecture _lecture) {
    return Card(
      key: Key(_lecture.lectureId),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.03, 0.03],
            colors: [cCardLeft, Colors.white],
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          dense: true,
          title:
              Text("${_lecture.title}", style: cTextListL, textScaleFactor: 1),
          subtitle: _subtitle(context, _lecture),
          trailing: InkWell(
            onTap: () async {
              // 確認問題へ
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionPage(
                    _userData,
                    _lecture,
                  ),
                ),
              );
              await model.fetchLecture(
                  _userData.userGroup, _workshop.workshopId);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(3),
              child: Column(
                children: [
                  Text("テスト", style: cTextListS, textScaleFactor: 1),
                  Icon(FontAwesomeIcons.list),
                ],
              ),
            ),
          ),
          onTap: () async {
            // 編集に移る前　model.categoryに値を渡す
            model.lecture = _lecture;
            model.initProperties();
            // Slideデータの作成 => model.slides
            await model.getSlideUrls(_userData.userGroup, _lecture.lectureId);
            model.slides.add(Slide(slideImage: null));
            // 編集へ
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LectureEditMain(
                  _userData.userGroup,
                  _lecture,
                  _workshop,
                  _organizer,
                ),
                fullscreenDialog: true,
              ),
            );
            await model.fetchLecture(_userData.userGroup, _workshop.workshopId);
          },
        ),
      ),
    );
  }

  Widget _subtitle(BuildContext context, Lecture _lecture) {
    bool _haveTest = _lecture.questionLength == 0 ? false : true;
    bool _haveImg = _lecture.slideLength == 0 ? false : true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 10),
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "問題 ${_lecture.questionLength}問",
            style: _haveTest ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "${_lecture.allAnswers} ",
            style: _haveTest ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "合格 ${_lecture.passingScore}点",
            style: _haveTest ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "画像 ${_lecture.slideLength}枚",
            style: _haveImg ? cTextListS : cTextUpBarS,
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButton(BuildContext context, LectureModel model) {
    return FloatingActionButton.extended(
      elevation: 15,
      backgroundColor: cFAB,
      icon: Icon(FontAwesomeIcons.plus),
      label: Text(" 講義を追加", style: cTextUpBarL, textScaleFactor: 1),
      onPressed: () async {
        // 新規登録へ
        model.initLecture(_organizer, _workshop);
        model.initProperties();
        model.initSlide();
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LectureAddMain(_userData.userGroup, _organizer, _workshop),
              fullscreenDialog: true,
            ));
        await model.fetchLecture(_userData.userGroup, _workshop.workshopId);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, LectureModel model) {
    return BottomAppBar(
      color: cContBg,
      notchMargin: 6.0,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(
          side: BorderSide(),
        ),
      ),
      child: Container(height: 45),
    );
  }
}
