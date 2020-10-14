import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import '../question/question_page.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import 'lecture_add.dart';
import 'lecture_edit.dart';
import 'lecture_model.dart';

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
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.home),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
          title: Text("講義を編集", style: cTextTitleL, textScaleFactor: 1),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _infoArea(context),
                Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ReorderableListView(
                      children: model.lectures.map(
                        (_lecture) {
                          return Card(
                              key: Key(_lecture.lectureId),
                              elevation: 15,
                              child: ListTile(
                                dense: true,
                                // contentPadding: EdgeInsets.symmetric(
                                //     horizontal: 0, vertical: 5),
                                title: Text(
                                  "${_lecture.title}",
                                  style: cTextListL,
                                  textScaleFactor: 1,
                                ),
                                subtitle: Text(
                                  "   ${_lecture.subTitle}",
                                  style: cTextListS,
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1,
                                ),
                                trailing: IconButton(
                                  icon: Icon(FontAwesomeIcons.arrowRight),
                                  iconSize: 20,
                                  onPressed: () async {
                                    // 確認問題へ
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionPage(
                                            groupName,
                                            _lecture,
                                          ),
                                        ));
                                    await model.fetchLecture(
                                        groupName, _workshop.workshopId);
                                  },
                                ),
                                onTap: () async {
                                  // 編集に移る前　model.categoryに値を渡す
                                  model.lecture = _lecture;
                                  model.initProperties();
                                  // Slideデータの作成 => model.slides
                                  await model.getSlideUrls(
                                      groupName, _lecture.lectureId);
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
                                      ));
                                  await model.fetchLecture(
                                      groupName, _workshop.workshopId);
                                },
                              ));
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
                    )),
              ],
            ),
          ),
          if (model.isLoading)
            Container(
                color: Colors.black87.withOpacity(0.8),
                child: Center(child: CircularProgressIndicator())),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
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
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Container(
            height: 45,
          ),
        ),
      );
    });
  }

  Widget _infoArea(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Row(
                children: [
                  Text(" ＜ ", style: cTextUpBarLL, textScaleFactor: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_organizerId.title,
                          style: cTextUpBarSS, textScaleFactor: 1),
                      Text(_workshop.title,
                          style: cTextUpBarM, textScaleFactor: 1),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("確 認\nテスト", style: cTextUpBarS, textScaleFactor: 1),
                  Text("➡️", style: cTextUpBarL, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sortedSave(BuildContext context, LectureModel model) async {
    try {
      int _count = 0;
      for (Lecture _data in model.lectures) {
        _data.lectureNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setLectureFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchLecture(groupName, _workshop.workshopId);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
  }
}
