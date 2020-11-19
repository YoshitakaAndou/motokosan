import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/exam/play/exam_List_page.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_list_page.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/body_data.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants.dart';
import '../lecture_model.dart';
import 'lecture_list_bottomsheet_info_items_lec.dart';
import 'lecture_list_bottomsheet_send_items.dart';
import 'lecture_list_tile_body.dart';

class LectureListPage extends StatelessWidget {
  final UserData _userData;
  final WorkshopList _workshopList;
  final String _routeName;
  LectureListPage(this._userData, this._workshopList, this._routeName);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    bool _isHideBS = false; //取説ボトムシート

    Future(() async {
      await _initBuild(context, model, _isHideBS);
    });
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: GestureDetector(
            child: barTitle(context),
            onTap: () => _showModalBottomSheetInfo(context, model, _isHideBS),
          ),
          leading: GoBack.instance.goBackWithReturArg(
            context: context,
            icon: Icon(FontAwesomeIcons.chevronLeft),
            returnArgument: ReturnArgument(
              workshopList: _workshopList,
            ),
            num: 1,
          ),
          actions: [
            if (_routeName == "fromWorkshop")
              GoBack.instance.goBackWithReturArg(
                context: context,
                icon: Icon(FontAwesomeIcons.home),
                returnArgument: ReturnArgument(
                  workshopList: _workshopList,
                ),
                num: 3,
              ),
            if (_routeName == "fromHome")
              GoBack.instance.goBackWithReturArg(
                context: context,
                icon: Icon(FontAwesomeIcons.home),
                returnArgument: ReturnArgument(
                  workshopList: _workshopList,
                ),
                num: 1,
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
                    itemBuilder: (context, int index) {
                      return Card(
                        key: Key(model.lectureLists[index].lecture.lectureId),
                        shape: cListCardShape,
                        elevation: 20,
                        child: LectureListTileBody(
                            _userData, _workshopList, model, index),
                      );
                    },
                  ),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _floatingActionButton(context, model, _isHideBS),
        bottomNavigationBar: _bottomNavigationBar(context, model),
      );
    });
  }

  Future<void> _initBuild(
      BuildContext context, LectureModel model, bool _isHideBS) async {
    model.startLoading();
    _isHideBS = await BodyData.instance.getIsHideLBS();
    model.generateLectureList(
        _userData.userGroup, _workshopList.workshop.workshopId);
    model.stopLoading();
    if (_isHideBS == false) {
      await _showModalBottomSheetInfo(context, model, _isHideBS);
    }
  }

  Widget _infoArea() {
    final String _isExam = _workshopList.workshop.isExam ? " 修了試験 " : "";
    final String _isExamResult =
        _workshopList.workshopResult.graduaterId.isNotEmpty ? "済 " : "";
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _workshopList.workshop.title,
                    style: cTextUpBarM,
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_workshopList.workshop.isExam)
                    Container(
                      color: Colors.green[600],
                      child: Row(
                        children: [
                          Text("$_isExam",
                              style: cTextUpBarS,
                              textScaleFactor: 1,
                              maxLines: 1),
                          Text("$_isExamResult",
                              style: cTextListSR,
                              textScaleFactor: 1,
                              maxLines: 1),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.chalkboardTeacher,
                          size: 18, color: Colors.white),
                      SizedBox(width: 10),
                      Text(" 講義一覧", style: cTextUpBarL, textScaleFactor: 1),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("主催  ", style: cTextUpBarS, textScaleFactor: 1),
                        Text(
                          _workshopList.organizerName,
                          style: cTextUpBarS,
                          textScaleFactor: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _floatingActionButton(
      BuildContext context, LectureModel model, bool _isHideBS) {
    final bool _isExam = _workshopList.workshop.isExam ? true : false;
    final bool _isTaken =
        _workshopList.workshopResult.isTaken == "受講済" ? true : false;
    final bool _isFAButton = _isExam && _isTaken ? true : false;
    return _isFAButton
        ? FloatingActionButton.extended(
            elevation: 20,
            shape: cFABShape,
            icon: Icon(FontAwesomeIcons.graduationCap),
            label: Text(" 修了試験を受ける", style: cTextUpBarL, textScaleFactor: 1),
            backgroundColor: cFAB,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamListPage(_userData, _workshopList),
                  fullscreenDialog: true,
                ),
              );
              await _initBuild(context, model, _isHideBS);
              if (_workshopList.workshopResult.isSendAt == 0 &&
                  _workshopList.workshopResult.isTaken == "研修済") {
                _showModalBottomSheetSend(context, model, true);
              }
            },
          )
        : Container();
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
                _workshopList.workshopResult.isTaken == "研修済")
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
          _showModalBottomSheetSend(context, model, false);
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
                _workshopList,
              ),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
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
        return LectureListBottomSheetSendItems(
            _userData, _workshopList, model, fromButton);
      },
    );
  }

  Future<Widget> _showModalBottomSheetInfo(
      BuildContext context, LectureModel model, bool _isHideBS) async {
    _isHideBS = await BodyData.instance.getIsHideLBS();
    return await showModalBottomSheet(
      context: context,
      // isDismissible: false,
      elevation: 20,
      // enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return LectureListBottomSheetInfoItemsLec(model, _isHideBS);
      },
    );
  }
}
