import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/buttons/white_button.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/make/lecture/lecture_edit_image.dart';
import 'package:motokosan/make/lecture/lecture_edit_question.dart';
import 'package:motokosan/make/lecture/lecture_edit_textmovie.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_firebase.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/question/question_class.dart';
import 'package:motokosan/take_a_lecture/question/question_firebase.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

class LectureEditMain extends StatelessWidget {
  final String groupName;
  final Lecture lecture;
  final Workshop workshop;
  final Organizer organizer;
  LectureEditMain(
    this.groupName,
    this.lecture,
    this.workshop,
    this.organizer,
  );

  final _tab = <Tab>[
    Tab(
      text: '本文・動画',
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.fileWord),
          SizedBox(width: 5),
          Icon(FontAwesomeIcons.youtube),
        ],
      ),
    ),
    Tab(text: 'スライド', icon: Icon(FontAwesomeIcons.images)),
    Tab(text: 'テスト', icon: Icon(FontAwesomeIcons.graduationCap)),
  ];

  @override
  Widget build(BuildContext context) {
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final descTextController = TextEditingController();
    final videoUrlTextController = TextEditingController();
    return DefaultTabController(
      length: _tab.length,
      child: Consumer<LectureModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("講義の編集", style: cTextTitleLIndigo, textScaleFactor: 1),
            leading: _batuButton(
              context,
              model,
              titleTextController,
              subTitleTextController,
              descTextController,
              videoUrlTextController,
            ),
            // leading: IconButton(
            //   icon: Icon(FontAwesomeIcons.times),
            //   color: Colors.black87,
            //   onPressed: () => Navigator.pop(context),
            // ),
            bottom: TabBar(
              tabs: _tab,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepOrange,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 8,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0),
              labelColor: Colors.black,
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: <Widget>[
                  LectureEditTextMovie(
                    groupName,
                    lecture,
                    workshop,
                    organizer,
                    titleTextController,
                    subTitleTextController,
                    descTextController,
                    videoUrlTextController,
                    model,
                  ),
                  LectureEditImage(
                    groupName,
                    lecture,
                    workshop,
                    organizer,
                  ),
                  LectureEditQuestion(
                    groupName,
                    lecture,
                    workshop,
                    organizer,
                  ),
                ],
              ),
            ],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _delButton(context, model),
                  model.isUpdate
                      ? _saveButton(
                          context,
                          model,
                          titleTextController,
                          subTitleTextController,
                          descTextController,
                          videoUrlTextController,
                        )
                      : _closeButton(context, model),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _batuButton(
    BuildContext context,
    LectureModel model,
    TextEditingController titleTextController,
    TextEditingController subTitleTextController,
    TextEditingController descTextController,
    TextEditingController videoUrlTextController,
  ) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.times, size: 20),
      onPressed: () {
        if (model.isUpdate) {
          MyDialog.instance.batuButtonDialog(
            context: context,
            mainTitle: 'このまま閉じますか？',
            subTitle: '入力した情報は破棄されます',
            yesText: '登録して閉じる',
            yesPressed: () async {
              Navigator.of(context).pop();
              await _editProcess(
                context,
                model,
                titleTextController,
                subTitleTextController,
                descTextController,
                videoUrlTextController,
              );
            },
            noText: '閉じる',
            noPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _saveButton(
    BuildContext context,
    LectureModel model,
    TextEditingController titleTextController,
    TextEditingController subTitleTextController,
    TextEditingController descTextController,
    TextEditingController videoUrlTextController,
  ) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.solidSave, color: Colors.green),
              label: Text("登録する", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () => _editProcess(
                context,
                model,
                titleTextController,
                subTitleTextController,
                descTextController,
                videoUrlTextController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context, LectureModel model) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.times, color: Colors.green),
              label: Text("やめる", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _delButton(BuildContext context, LectureModel model) {
    return WhiteButton(
      context: context,
      title: " この講義を削除",
      icon: FontAwesomeIcons.trashAlt,
      iconSize: 15,
      onPress: () {
        MyDialog.instance.okShowDialogFunc(
          context: context,
          mainTitle: lecture.title,
          subTitle: "削除しますか？",
          // delete
          onPressed: () async {
            Navigator.pop(context);
            await _deleteAndSave(context, model, lecture.lectureId);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _editProcess(
    BuildContext context,
    LectureModel model,
    TextEditingController titleTextController,
    TextEditingController subTitleTextController,
    TextEditingController descTextController,
    TextEditingController videoUrlTextController,
  ) async {
    // グリグリを回す
    model.startLoading();
    // 更新処理
    model.lecture.title = titleTextController.text;
    model.lecture.subTitle = subTitleTextController.text;
    model.lecture.description = descTextController.text;
    model.lecture.videoUrl = videoUrlTextController.text;
    model.lecture.lectureId = lecture.lectureId;
    model.lecture.lectureNo = lecture.lectureNo;
    model.lecture.createAt = lecture.createAt;
    model.lecture.updateAt = lecture.updateAt;
    model.lecture.targetId = lecture.targetId;
    model.lecture.organizerId = lecture.organizerId;
    model.lecture.workshopId = lecture.workshopId;
    model.lecture.slideLength = lecture.slideLength;
    try {
      // 変更があったときだけSlideの処理を行う
      if (model.isSlideUpdate) {
        // model.slidesをstorageに登録してslideUrlを取得しつつ
        // Group/三原赤十字病院/Lecture/lecId/Slide/0001.../に登録
        await model.updateSlide(groupName, model.lecture.lectureId);
      }
      // 入力チェック
      model.inputCheck();
      await model.updateLectureFs(groupName, DateTime.now());
      await model.fetchLecture(groupName, workshop.workshopId);
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "更新しました", Colors.black);
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
      model.stopLoading();
    }
    model.resetUpdate();
  }

  Future<void> _deleteAndSave(
    BuildContext context,
    LectureModel model,
    lectureId,
  ) async {
    model.startLoading();
    try {
      //QuestionとQuestionResultの削除
      // fetchして削除対象のListを作成
      final _questions =
          await FSQuestion.instance.fetchDates(groupName, lectureId);
      if (_questions.length > 0) {
        for (Question _data in _questions) {
          await FSQuestion.instance.deleteData(groupName, _data.questionId);
          // await QuestionDatabase.instance
          //     .deleteQuestionResult(_data.questionId);
        }
      }
      //StorageのImageとFSのSlideを削除
      await model.deleteStorageImages(groupName, lectureId);
      //FsをLectureIdで削除
      await FSLecture.instance.deleteData(groupName, lectureId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchLecture(groupName, workshop.workshopId);
      //頭から順にlectureNoを振る
      int _count = 1;
      for (Lecture _data in model.lectures) {
        _data.lectureNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await FSLecture.instance
            .setData(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchLecture(groupName, workshop.workshopId);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString(), Colors.red);
    }
    model.stopLoading();
  }
}
