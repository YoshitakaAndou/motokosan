import 'package:flutter/material.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import '../../question/make/question_page.dart';
import '../../organizer/organizer_model.dart';
import '../../workshop/workshop_model.dart';
import 'lecture_add.dart';
import 'lecture_edit.dart';
import '../lecture_model.dart';

class LecturePage extends StatelessWidget {
  final String groupName;
  final Organizer _organizerId;
  final Workshop _workshop;
  LecturePage(this.groupName, this._organizerId, this._workshop);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    model.lecture.organizerId = _organizerId.organizerId;
    model.lecture.workshopId = _workshop.workshopId;
    Future(() async {
      model.startLoading();
      await model.fetchLecture(groupName, _workshop.workshopId);
      model.stopLoading();
    });
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
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
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
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
            Text(" 講義を編集", style: cTextUpBarL, textScaleFactor: 1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("研修会：", style: cTextUpBarM, textScaleFactor: 1),
                    Text(_workshop.title,
                        style: cTextUpBarM, textScaleFactor: 1),
                  ],
                )
              ],
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
        await fsLecture.setData(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchLecture(groupName, _workshop.workshopId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
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
      elevation: 15,
      child: ListTile(
        dense: true,
        title: Text("${_lecture.title}", style: cTextListL, textScaleFactor: 1),
        subtitle: Text("   ${_lecture.subTitle}",
            style: cTextListS, textAlign: TextAlign.start, textScaleFactor: 1),
        trailing: InkWell(
          onTap: () async {
            // 確認問題へ
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionPage(
                  groupName,
                  _lecture,
                ),
              ),
            );
            await model.fetchLecture(groupName, _workshop.workshopId);
          },
          child: Container(
            child: Column(
              children: [
                Text("テストを編集", style: cTextListS, textScaleFactor: 1),
                Icon(FontAwesomeIcons.arrowRight),
              ],
            ),
          ),
        ),
        onTap: () async {
          // 編集に移る前　model.categoryに値を渡す
          model.lecture = _lecture;
          model.initProperties();
          // Slideデータの作成 => model.slides
          await model.getSlideUrls(groupName, _lecture.lectureId);
          model.slides.add(Slide(slideImage: null));
          // 編集へ
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LectureEdit(
                groupName,
                _lecture,
                _workshop,
                _organizerId,
              ),
              fullscreenDialog: true,
            ),
          );
          await model.fetchLecture(groupName, _workshop.workshopId);
        },
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, LectureModel model) {
    return FloatingActionButton(
      elevation: 15,
      child: Icon(FontAwesomeIcons.plus),
      onPressed: () async {
        // 新規登録へ
        model.initLecture(_organizerId, _workshop);
        model.initProperties();
        model.initSlide();
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LectureAdd(groupName, _organizerId, _workshop),
              fullscreenDialog: true,
            ));
        await model.fetchLecture(groupName, _workshop.workshopId);
      },
    );
  }

  Widget _bottomAppBar(BuildContext context, LectureModel model) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
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
