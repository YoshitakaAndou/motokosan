import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/buttons/custom_button.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';

class LectureListBottomSheetInfoItemsLec extends StatelessWidget {
  final LectureModel model;
  final bool isHideBS;
  LectureListBottomSheetInfoItemsLec(
    this.model,
    this.isHideBS,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bottomSheetTitle(context, model, isHideBS),
        _bottomSheetText(context),
        _bottomSheetButton(context, model),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _bottomSheetTitle(
      BuildContext context, LectureModel model, bool _isHideBS) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomSheetTitleLetter(),
          _bottomSheetTitleCheckButton(context, model, _isHideBS),
        ],
      ),
    );
  }

  Widget _bottomSheetTitleLetter() {
    return Row(
      children: [
        Icon(FontAwesomeIcons.chalkboardTeacher, size: 15, color: Colors.white),
        SizedBox(width: 12),
        Text(
          "講義一覧",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
        Text(
          "　について",
          style: cTextUpBarS,
          textScaleFactor: 1,
        ),
      ],
    );
  }

  Widget _bottomSheetTitleCheckButton(
      BuildContext context, LectureModel model, bool _isHideBS) {
    return Row(
      children: [
        Text("自動で表示しない", style: cTextUpBarS, textScaleFactor: 1),
        // SizedBox(width: 5),
        BottomSheetTitleCheckBoxLec(isHideBS: _isHideBS),
      ],
    );
  }

  Widget _bottomSheetText(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "　閲覧する講義を、上の一覧から選んでタップしてください。"
                "\n次のページで、講義の動画が再生されて講義を受けられます。"
                "\n確認テストがある講義は解答することで受講完了となります。"
                "\n全て講義が「済」になるように頑張ってください。",
                style: cTextListM,
                textScaleFactor: 1,
                maxLines: 11,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Image.asset(
                "assets/images/guide2.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetButton(BuildContext context, LectureModel model) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
}

class BottomSheetTitleCheckBoxLec extends StatefulWidget {
  final bool isHideBS;
  BottomSheetTitleCheckBoxLec({this.isHideBS});
  @override
  _BottomSheetTitleCheckBoxLecState createState() =>
      _BottomSheetTitleCheckBoxLecState();
}

class _BottomSheetTitleCheckBoxLecState
    extends State<BottomSheetTitleCheckBoxLec> {
  bool _flag;

  @override
  void initState() {
    _flag = widget.isHideBS;
    super.initState();
  }

  void _handleCheckbox(bool e) async {
    await DataSaveBody.instance.saveIsHideLBS(e);
    setState(() {
      _flag = e;
    });
  }

  Widget build(BuildContext context) {
    return Checkbox(
      value: _flag,
      onChanged: _handleCheckbox,
    );
  }
}
