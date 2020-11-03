import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_list_page.dart';
import 'package:motokosan/take_a_lecture/organizer/play/organizer_class.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/play/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/play/workshop_database.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:motokosan/widgets/ok_show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../../../widgets/bar_title.dart';
import '../../../widgets/go_back.dart';
import '../../../constants.dart';
import 'lecture_class.dart';
import 'lecture_firebase.dart';
import 'lecture_model.dart';
import 'lecture_play.dart';

class LectureListPage extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  final WorkshopList _workshopList;
  LectureListPage(this._userData, this._organizer, this._workshopList);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    Future(() async {
      // model.startLoading();
      await model.generateLectureList(
          _userData.userGroup, _workshopList.workshop.workshopId);
      // model.stopLoading();
    });
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          leading: GoBack.instance.goBackWithReturArg(
            context: context,
            icon: Icon(FontAwesomeIcons.chevronLeft),
            returnArgument: ReturnArgument(
              workshopList: _workshopList,
            ),
            num: 1,
          ),
          actions: [
            GoBack.instance.goBackWithReturArg(
              context: context,
              icon: Icon(FontAwesomeIcons.home),
              returnArgument: ReturnArgument(
                workshopList: _workshopList,
              ),
              num: 3,
            ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 20,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                          // dense: true,
                          leading: _leading(context, model, index),
                          title: _title(context, model, index),
                          subtitle: _subtitle(context, model, index),
                          trailing: _trailing(context, model, index),
                          onTap: () => _onTap(
                              context,
                              model,
                              index,
                              _userData.userGroup,
                              _workshopList.workshop.workshopId),
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
        bottomNavigationBar: _bottomNavigationBar(context, model),
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
                    Text(
                      _workshopList.organizerName,
                      style: cTextUpBarS,
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("研修会：", style: cTextUpBarS, textScaleFactor: 1),
                    Text(
                      _workshopList.workshop.title,
                      style: cTextUpBarS,
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
      _results =
          await FSSlide.instance.fetchDates(_userData.userGroup, _lectureId);
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
      child: Column(
        children: [
          Text(
            "${model.lectureLists[index].lecture.subTitle}",
            style: cTextListSS,
            textAlign: TextAlign.left,
            textScaleFactor: 1,
          ),
          _statusInfo(context, model, index),
        ],
      ),
    );
  }

  Widget _statusInfo(BuildContext context, LectureModel model, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (model.lectureLists[index].lecture.questionLength != 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.greenAccent.withOpacity(0.2),
            child: Text(
                "テスト:${model.lectureLists[index].lecture.questionLength}問",
                style: cTextListSS,
                textScaleFactor: 1),
          ),
        if (model.lectureLists[index].lecture.questionLength == 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey.withOpacity(0.2),
            child: Text("テスト無し", style: cTextUpBarSS, textScaleFactor: 1),
          ),
        if (model.lectureLists[index].lecture.questionLength != 0 &&
            model.lectureLists[index].lecture.allAnswers.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.greenAccent.withOpacity(0.2),
            child: Text("${model.lectureLists[index].lecture.allAnswers}",
                style: cTextListSS, textScaleFactor: 1),
          ),
        if (model.lectureLists[index].lecture.questionLength == 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey.withOpacity(0.2),
            child: Text("特に指定は無し", style: cTextUpBarSS, textScaleFactor: 1),
          ),
      ],
    );
  }

  Widget _trailing(BuildContext context, LectureModel model, int index) {
    // todo
    print("${model.lectureLists[index].lectureResult.isTaken}");
    return model.lectureLists[index].lectureResult.isTaken == "受講済"
        ? Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text("済", style: cTextButtonL, textScaleFactor: 1),
            ),
          )
        : Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text("未", style: cTextButtonL, textScaleFactor: 1),
            ),
          );
  }

  Future<void> _onTap(BuildContext context, LectureModel model, int index,
      String _groupName, String _workshopId) async {
    ReturnArgument returnArgument = ReturnArgument();
    returnArgument.isNextQuestion = true;

    while (returnArgument.isNextQuestion) {
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
      returnArgument = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LecturePlay(
            _userData,
            _organizer,
            _workshopList,
            model.lectureLists[index],
            _slides1,
            model.lectureLists.length - index == 1 ? true : false,
          ),
        ),
      );
      if (returnArgument == null) {
        returnArgument = ReturnArgument();
      }
      if (model.lectureLists[index].lecture.videoUrl.isNotEmpty) {
        //スマホの向きを上のみに戻す
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
      index = index + 1;
      // リストの最後まで来たら終わり
      if (index >= model.lectureLists.length) {
        returnArgument.isNextQuestion = false;
      }
    }
    await model.generateLectureList(_groupName, _workshopId);
    _checkWorkshopIsTaken(model);
    final _sendCheck =
        await WorkshopDatabase.instance.getWorkshopResult(_workshopId);
    if (_sendCheck.length > 0) {
      if (_sendCheck[0].graduaterId.isNotEmpty) {
        return;
      }
    }
    // todo workshopResultの保存
    await _saveWorkshopResult(context, model, 0, "");
    if (model.lectureLists.length == model.takenCount) {
      final _results =
          await WorkshopDatabase.instance.getWorkshopResult(_workshopId);
      if (_results.length > 0) {
        if (_results[0].graduaterId.isEmpty) {
          await _showModalBottomSheetSend(context, model, false);
        }
      }
    }
  }

  _checkWorkshopIsTaken(LectureModel model) {
    if (model.lectureLists.length > model.takenCount) {
      _workshopList.workshopResult.isTaken = "受講中";
    } else {
      _workshopList.workshopResult.isTaken = "受講済";
    }
  }

  Future<void> _saveWorkshopResult(BuildContext context, LectureModel model,
      int _isSendAt, String _graduaterId) async {
    print(
        "_saveWorkshopResult .isTaken: ${_workshopList.workshopResult.isTaken}");
    _workshopList.workshopResult.graduaterId = _graduaterId;
    _workshopList.workshopResult.workshopId = _workshopList.workshop.workshopId;
    _workshopList.workshopResult.lectureCount = model.lectureLists.length;
    _workshopList.workshopResult.takenCount = model.takenCount;
    _workshopList.workshopResult.isTakenAt =
        ConvertItems.instance.dateToInt(DateTime.now());
    _workshopList.workshopResult.isSendAt = _isSendAt;
    await WorkshopDatabase.instance
        .saveValue(_workshopList.workshopResult, true);
  }

  Future<Widget> _showModalBottomSheetSend(
      BuildContext context, LectureModel model, bool fromButton) async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: false,
      elevation: 15,
      // enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottomSheetTitle(fromButton),
            _bottomSheetText(context, fromButton),
            SizedBox(height: 10),
            _bottomSheetUserData(context),
            SizedBox(height: 10),
            _bottomSheetButton(context, model),
            SizedBox(height: 30),
          ],
        );
      },
    );
  }

  Widget _bottomSheetTitle(_fromButton) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          _fromButton ? "修了情報が送信されていません" : "おつかれさまでした！",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget _bottomSheetText(BuildContext context, _fromButton) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            _fromButton
                ? "「${_workshopList.workshop.title}」を修了済み"
                : "「${_workshopList.workshop.title}」を修了されました。",
            style: cTextListM,
            textScaleFactor: 1,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _bottomSheetUserData(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                "修了者 : ",
                style: cTextListS,
                textScaleFactor: 1,
                maxLines: 1,
              ),
              Text(
                "${_userData.userName}",
                style: cTextListM,
                textScaleFactor: 1,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "修了日 : ",
                style: cTextListS,
                textScaleFactor: 1,
                maxLines: 1,
              ),
              Text(
                "${_workshopList.workshopResult.isTakenAt}",
                style: cTextListM,
                textScaleFactor: 1,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetButton(BuildContext context, LectureModel model) {
    return Column(
      children: [
        Text(
          "以上の情報を主催者に送信しますか？",
          style: cTextListM,
          textScaleFactor: 1,
          maxLines: 1,
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _sendButton(context, model),
            _closedButton(context, model),
          ],
        ),
      ],
    );
  }

  Widget _closedButton(BuildContext context, LectureModel model) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.times, color: Colors.green),
              label: Text(
                "閉じる",
                style: cTextListM,
                textScaleFactor: 1,
              ),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sendButton(BuildContext context, LectureModel model) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.paperPlane, color: Colors.green),
              label: Text(
                "送  る",
                style: cTextListM,
                textScaleFactor: 1,
              ),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () async {
                model.startLoading();
                // todo 送信する情報
                final graduater = Graduater(
                  graduaterId: DateTime.now().toString(),
                  uid: _userData.uid,
                  workshopId: _workshopList.workshopResult.workshopId,
                  takenAt: _workshopList.workshopResult.isTakenAt,
                  sendAt: ConvertItems.instance.dateToInt(DateTime.now()),
                );
                // todo FSのGraduatesに送信
                await model.sendGraduaterData(_userData.userGroup, graduater);
                // todo DBのworkshopResultも更新
                await _saveWorkshopResult(
                    context, model, graduater.sendAt, graduater.graduaterId);
                await MyDialog.instance.okShowDialog(context, "登録完了しました");
                model.stopLoading();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context, LectureModel model) {
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomWebButton(context, model),
            if (_workshopList.workshopResult.isSendAt == 0 &&
                _workshopList.workshopResult.isTaken == "受講済")
              _bottomSendButton(context, model),
          ],
        ),
      ),
    );
  }

  Widget _bottomSendButton(BuildContext context, LectureModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton.icon(
        icon: Icon(FontAwesomeIcons.paperPlane),
        color: Colors.green,
        textColor: Colors.white,
        label: Text("未送信", style: cTextUpBarM, textScaleFactor: 1),
        onPressed: () {
          _showModalBottomSheetSend(context, model, true);
        },
      ),
    );
  }

  Widget _bottomWebButton(BuildContext context, LectureModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton.icon(
        icon: Icon(FontAwesomeIcons.userGraduate),
        color: Colors.green,
        textColor: Colors.white,
        label: Text("修了者", style: cTextUpBarM, textScaleFactor: 1),
        onPressed: () {
          // 編集へ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GraduaterListPage(
                _userData,
                _organizer,
                _workshopList,
              ),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}
