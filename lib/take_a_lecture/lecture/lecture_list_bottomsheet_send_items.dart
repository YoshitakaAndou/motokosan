import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_database.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/buttons/custom_button.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/constants.dart';
import 'lecture_model.dart';

class LectureListBottomSheetSendItems extends StatelessWidget {
  final UserData _userData;
  final WorkshopList _workshopList;
  final LectureModel model;
  final bool fromButton;
  LectureListBottomSheetSendItems(
      this._userData, this._workshopList, this.model, this.fromButton);

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

  Future<void> _saveWorkshopResult(BuildContext context, LectureModel model,
      int _isSendAt, String _graduaterId) async {
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
}
