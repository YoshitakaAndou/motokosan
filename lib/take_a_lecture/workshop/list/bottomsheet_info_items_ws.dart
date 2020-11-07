import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/body_data.dart';

import '../../../constants.dart';
import '../workshop_model.dart';

class BottomSheetInfoItemsWS extends StatelessWidget {
  final WorkshopModel model;
  final bool _isHideBS;
  BottomSheetInfoItemsWS(this.model, this._isHideBS);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bottomSheetTitle(context, model, _isHideBS),
        _bottomSheetText(context),
        _bottomSheetButton(context, model),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _bottomSheetTitle(
      BuildContext context, WorkshopModel model, bool _isHideBS) {
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
        Icon(FontAwesomeIcons.listAlt, size: 15, color: Colors.white),
        SizedBox(width: 12),
        Text(
          "研修会一覧",
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
      BuildContext context, WorkshopModel model, bool _isHideBS) {
    return Row(
      children: [
        Text("自動で表示しない", style: cTextUpBarS, textScaleFactor: 1),
        // SizedBox(width: 5),
        BottomSheetTitleCheckBoxWS(isHideBS: _isHideBS),
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
                "　参加する研修会を、上の一覧から選んで"
                "タップしてください。"
                "\n次のページで、研修会に登録されている"
                "講義の一覧が表示されます。"
                "\n円グラフは「受講済」の割合を表します。"
                "100%を目指して頑張ってください！",
                style: cTextListM,
                textScaleFactor: 1,
                maxLines: 9,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Image.asset(
                "assets/images/nurse02.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetButton(BuildContext context, WorkshopModel model) {
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

  Widget _closedButton(BuildContext context, WorkshopModel model) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomSheetTitleCheckBoxWS extends StatefulWidget {
  final bool isHideBS;
  BottomSheetTitleCheckBoxWS({this.isHideBS});
  @override
  _BottomSheetTitleCheckBoxWSState createState() =>
      _BottomSheetTitleCheckBoxWSState();
}

class _BottomSheetTitleCheckBoxWSState
    extends State<BottomSheetTitleCheckBoxWS> {
  bool _flag;

  @override
  void initState() {
    _flag = widget.isHideBS;
    super.initState();
  }

  void _handleCheckbox(bool e) async {
    await BodyData.instance.saveIsHideWSBS(e);
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
