import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_model.dart';

import '../../data/constants.dart';

class OrganizerListBottomSheetInfoItems extends StatelessWidget {
  final OrganizerModel model;
  OrganizerListBottomSheetInfoItems(this.model);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bottomSheetTitle(context, model),
        _bottomSheetText(context),
        _bottomSheetButton(context, model),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _bottomSheetTitle(BuildContext context, OrganizerModel model) {
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
          "主催者一覧",
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
                "　主催者の一覧表です。選んでタップしてください。"
                "\n「指定無し」を選ぶと全ての研修会を表示することができます。",
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
                "assets/images/guide2.png",
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetButton(BuildContext context, OrganizerModel model) {
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

  Widget _closedButton(BuildContext context, OrganizerModel model) {
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
