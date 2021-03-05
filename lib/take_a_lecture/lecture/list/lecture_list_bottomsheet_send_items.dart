import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/buttons/custom_button.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LectureListBottomSheetSendItems extends StatelessWidget {
  final UserData userData;
  final WorkshopList workshopList;
  final LectureModel model;
  final bool fromButton;
  LectureListBottomSheetSendItems(
    this.userData,
    this.workshopList,
    this.model,
    this.fromButton,
  );

  @override
  Widget build(BuildContext context) {
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
                ? "「${workshopList.workshop.title}」を修了済み"
                : "「${workshopList.workshop.title}」を修了されました。",
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
                "${userData.userName}",
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
                "${workshopList.workshopResult.isTakenAt}",
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
            child: CustomButton(
              context: context,
              title: '閉じる',
              icon: FontAwesomeIcons.times,
              iconSize: 15,
              onPress: () {
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
                  uid: userData.uid,
                  workshopId: workshopList.workshopResult.workshopId,
                  takenAt: workshopList.workshopResult.isTakenAt,
                  sendAt: ConvertDateTime.instance.dateToInt(DateTime.now()),
                );
                // todo FSのGraduatesに送信
                await model.sendGraduaterData(userData.userGroup, graduater);
                // todo DBのworkshopResultも更新
                await _saveWorkshopResult(
                    context, model, graduater.sendAt, graduater.graduaterId);
                await MyDialog.instance.okShowDialog(
                  context,
                  "登録完了しました",
                  Colors.black,
                );
                model.stopLoading();
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveWorkshopResult(BuildContext context, LectureModel model,
      int _isSendAt, String _graduaterId) async {
    workshopList.workshopResult.graduaterId = _graduaterId;
    workshopList.workshopResult.workshopId = workshopList.workshop.workshopId;
    workshopList.workshopResult.lectureCount = model.lectureLists.length;
    workshopList.workshopResult.takenCount = model.takenCount;
    workshopList.workshopResult.isTakenAt =
        ConvertDateTime.instance.dateToInt(DateTime.now());
    workshopList.workshopResult.isSendAt = _isSendAt;
    await WorkshopDatabase.instance
        .saveValue(workshopList.workshopResult, true);
  }
}
