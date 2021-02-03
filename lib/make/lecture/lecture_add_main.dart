import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../take_a_lecture/lecture/lecture_model.dart';
import 'lecture_add_image.dart';
import 'lecture_add_question.dart';
import 'lecture_add_textmovie.dart';

class LectureAddMain extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  final Workshop _workshop;
  LectureAddMain(this.groupName, this._organizer, this._workshop);

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
    final model = Provider.of<LectureModel>(context, listen: false);
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final descTextController = TextEditingController();
    final videoUrlTextController = TextEditingController();
    model.lecture.lectureNo =
        (model.lectures.length + 1).toString().padLeft(4, "0");
    return DefaultTabController(
      length: _tab.length,
      child: Consumer<LectureModel>(builder: (context, model, child) {
        model.isEditing = _checkValue(model);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:
                Text("講義の新規登録", style: cTextTitleLIndigo, textScaleFactor: 1),
            leading: _batuButton(context, model),
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
                  LectureAddTextMovie(
                    groupName,
                    _organizer,
                    _workshop,
                    titleTextController,
                    subTitleTextController,
                    descTextController,
                    videoUrlTextController,
                  ),
                  LectureAddImage(
                    groupName,
                    _organizer,
                    _workshop,
                  ),
                  LectureAddQuestion(
                    groupName,
                    _organizer,
                    _workshop,
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
            child: model.isEditing
                ? _saveButton(context, model)
                : _closeButton(context, model),
          ),
        );
      }),
    );
  }

  Widget _batuButton(BuildContext context, LectureModel model) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.times, size: 20),
      onPressed: () {
        if (_checkValue(model)) {
          MyDialog.instance.batuButtonDialog(
            context: context,
            mainTitle: 'このまま閉じますか？',
            subTitle: '入力した情報は破棄されます',
            yesText: '登録して閉じる',
            yesPressed: () async {
              Navigator.of(context).pop();
              await _addProcess(context, model);
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

  Widget _saveButton(BuildContext context, LectureModel model) {
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
              onPressed: () => _addProcess(context, model),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addProcess(BuildContext context, LectureModel model) async {
    try {
      // グリグリを回す
      model.startLoading();
      // 入力チェック
      model.inputCheck();
      // lectureIdにタイムスタンプを設定
      DateTime _timeStamp = DateTime.now();
      model.lecture.lectureId = _timeStamp.toString();
      // model.slidesをstorageに登録してslideUrlを取得しつつ
      // Group/三原赤十字病院/Lecture/lecId/Slide/0.../に登録
      await model.addSlide(groupName, model.lecture.lectureId);
      // model.lectureをFBに登録
      await model.addLectureFs(groupName, _timeStamp);
      // グリグリを止める
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
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
}
