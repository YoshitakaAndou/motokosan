import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_list_page.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
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
import 'bottomsheet_info_items_lec.dart';
import 'bottomsheet_send_items.dart';
import 'list_tile_body.dart';

class LectureListPage extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  final WorkshopList _workshopList;
  LectureListPage(this._userData, this._organizer, this._workshopList);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    bool _isHideBS = false;
    Future(() async {
      // model.startLoading();
      _isHideBS = await BodyData.instance.getIsHideLBS();
      await model.generateLectureList(
          _userData.userGroup, _workshopList.workshop.workshopId);
      // model.stopLoading();
      if (_isHideBS == false) {
        await _showModalBottomSheetInfo(context, model, _isHideBS);
      }
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
                        child: ListTileBody(
                            _userData, _organizer, _workshopList, model, index),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text("研修会  ",
                  //     style: cTextUpBarSS, textScaleFactor: 1, maxLines: 1),
                  Text(
                    _workshopList.workshop.title,
                    style: cTextUpBarM,
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
        return BottomSheetSendItems(
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
        return BottomSheetInfoItemsLec(model, _isHideBS);
      },
    );
  }
}
