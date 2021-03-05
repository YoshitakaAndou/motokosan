import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/take_a_lecture/exam/exam_List_page.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_list_page.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/lecture/list/lecture_list_info.dart';
import 'package:motokosan/widgets/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/widgets/check_deadline_at.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'lecture_list_bottomsheet_info_items_lec.dart';
import 'lecture_list_bottomsheet_send_items.dart';
import 'lecture_list_tile_body.dart';

class LectureListPage extends StatelessWidget {
  final UserData userData;
  final WorkshopList workshopList;
  final String routeName;

  LectureListPage({
    this.userData,
    this.workshopList,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    // final Size _size = MediaQuery.of(context).size;
    bool _isHideBS = false; //取説ボトムシート
    Future(() async {
      await _initBuild(context, model, _isHideBS);
    });

    //  backWorkshopList() {
    //   Navigator.pop(context);
    //   Navigator.of(context).pop(ReturnArgument(workshopList: workshopList));
    // }

    // backHome() {
    //   Navigator.popUntil(context, ModalRoute.withName("/home"));
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => Home(userData: userData),
    //     ),
    //   );
    // }

    // showInfo(){
    //   //タップすると研修会の情報をダイアログに表示
    //     LectureListInfo.instance.lectureListInfo(context, workshopList);
    // }
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: BarTitle.instance.barTitle(context),
          leading: GoBack.instance.goBackWithReturnArg(
            context: context,
            icon: Icon(FontAwesomeIcons.arrowLeft),
            returnArgument: ReturnArgument(
              workshopList: workshopList,
            ),
            num: 1,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.questionCircle, size: 20),
              color: Colors.black54,
              onPressed: () =>
                  _showModalBottomSheetInfo(context, model, _isHideBS),
            ),
            if (routeName == "fromWorkshop")
              //研修会一覧から来たら研修会一覧へ帰る
              GoBack.instance.goBackWithReturnArg(
                context: context,
                icon: Icon(FontAwesomeIcons.home),
                returnArgument: ReturnArgument(
                  workshopList: workshopList,
                ),
                num: 2,
              ),
            if (routeName == "fromHome")
              //ホームページから来たらホームページに帰る
              GoBack.instance.goBackWithReturnArg(
                context: context,
                icon: Icon(FontAwesomeIcons.home),
                returnArgument: ReturnArgument(
                  workshopList: workshopList,
                ),
                num: 1,
              ),
          ],
        ),
        // ドローワーだぞ！
      // drawer: LectureListDrawer(
      //   size: _size,
      //   backWorkshopList: backWorkshopList,
      //   backHome: backHome,
      //   showInfo: showInfo,
      // ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 1, child: _infoArea(context)),
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
                          userData,
                          workshopList,
                          model,
                          index,
                          routeName,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _floatingActionButton(context, model, _isHideBS),
        bottomNavigationBar: _bottomNavigationBar(context, model),
      );
    });
  }

  Future<void> _initBuild(
      BuildContext context, LectureModel model, bool _isHideBS) async {
    model.startLoading();
    _isHideBS = await DataSaveBody.instance.getIsHideLBS();
    model.generateLectureList(
        userData.userGroup, workshopList.workshop.workshopId);
    model.stopLoading();
    if (_isHideBS == false) {
      await _showModalBottomSheetInfo(context, model, _isHideBS);
    }
  }

  Widget _infoArea(BuildContext context) {
    final String _isExam = workshopList.workshop.isExam ? "修了試験：未受験" : "";
    final String _isExamResult =
        workshopList.workshopResult.graduaterId.isNotEmpty ? "修了試験：受験済" : "";
    return GestureDetector(
      onTap: () {
        //タップすると研修会の情報をダイアログに表示
        LectureListInfo.instance.lectureListInfo(context, workshopList);
      },
      child: Container(
        width: double.infinity,
        height: cInfoAreaH,
        color: cContBg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          workshopList.workshop.title,
                          style: cTextUpBarM,
                          textScaleFactor: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
                              Text(" 講義一覧",
                                  style: cTextUpBarL, textScaleFactor: 1),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if (workshopList.workshop.isExam)
                              Container(
                                color: Colors.green[600],
                                child: Row(
                                  children: [
                                    Text(
                                      "$_isExam",
                                      style: cTextUpBarM,
                                      textScaleFactor: 1,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      "$_isExamResult",
                                      style: cTextListM,
                                      textScaleFactor: 1,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/nurse_quiz.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingActionButton(
      BuildContext context, LectureModel model, bool _isHideBS) {
    final bool _isExam = workshopList.workshop.isExam ? true : false;
    final bool _isTaken =
        workshopList.workshopResult.isTaken == "受講済" ? true : false;
    final bool _isFAButton = _isExam && _isTaken ? true : false;
    final CheckDeadlineAt _checkDeadlineAt =
        CheckDeadlineAt(deadlineAt: workshopList.workshop.deadlineAt);
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
                  builder: (context) => ExamListPage(userData, workshopList),
                  fullscreenDialog: true,
                ),
              );
              await _initBuild(context, model, _isHideBS);

              // todo 修了書を送るボトムシート
              if (workshopList.workshopResult.isSendAt == 0 &&
                  workshopList.workshopResult.isTaken == "研修済" &&
                  _checkDeadlineAt.check()) {
                _showModalBottomSheetSend(context, model, true);
              }
            },
          )
        : Container();
  }

  Widget _bottomNavigationBar(BuildContext context, LectureModel model) {
    final CheckDeadlineAt _checkDeadlineAt =
        CheckDeadlineAt(deadlineAt: workshopList.workshop.deadlineAt);
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
            // todo 修了書の送付ボタン
            _bottomWebButton(context, model),
            if (workshopList.workshopResult.isSendAt == 0 &&
                workshopList.workshopResult.isTaken == "研修済" &&
                _checkDeadlineAt.check())
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
                userData,
                workshopList,
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
            userData, workshopList, model, fromButton);
      },
    );
  }

  Future<Widget> _showModalBottomSheetInfo(
      BuildContext context, LectureModel model, bool _isHideBS) async {
    _isHideBS = await DataSaveBody.instance.getIsHideLBS();
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
