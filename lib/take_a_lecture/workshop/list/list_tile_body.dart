import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/list/lecture_list_page.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../constants.dart';
import '../../return_argument.dart';
import '../workshop_model.dart';

class ListTileBody extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  final WorkshopModel model;
  final int index;
  ListTileBody(this._userData, this._organizer, this.model, this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // dense: true,
      leading: _leading(context, model, index),
      title: _title(context, model, index),
      trailing: _trailing(context, model, index),
      onTap: () => _onTap(context, model, index),
    );
  }

  Widget _leading(BuildContext context, WorkshopModel model, int index) {
    bool _isTakenCount =
        model.workshopLists[index].workshopResult.takenCount == 0
            ? false
            : true;
    bool _isClear = model.workshopLists[index].workshopResult.isTaken == "受講済"
        ? true
        : false;
    return Container(
      padding: EdgeInsets.all(3),
      color: _isClear
          ? Colors.green.withOpacity(0.2)
          : _isTakenCount
              ? Colors.red.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _isTakenCount
                ? "${model.workshopLists[index].workshopResult.isTaken}"
                : "未受講",
            style: cTextListS,
            textScaleFactor: 1,
          ),
          Text(
            "${model.workshopLists[index].workshopResult.takenCount} / ${model.workshopLists[index].workshop.lectureLength}",
            style: TextStyle(
              fontSize: 10,
              color: _isTakenCount ? Colors.black : Colors.transparent,
              fontWeight: FontWeight.w300,
            ),
            textScaleFactor: 1,
          ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context, WorkshopModel model, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${model.workshopLists[index].workshop.title}",
          style: cTextListL,
          textScaleFactor: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.red.withOpacity(0.1),
              child: Text(
                  "期限：${ConvertItems.instance.intToString(model.workshopLists[index].workshop.deadlineAt)}",
                  style: cTextListS,
                  textScaleFactor: 1),
            ),
            if (_organizer.title == "指定無し")
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "主催：${model.workshopLists[index].organizerName}",
                    style: cTextListSS,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _trailing(BuildContext context, WorkshopModel model, int index) {
    final double _percent =
        model.workshopLists[index].workshopResult.lectureCount == 0
            ? 0
            : model.workshopLists[index].workshopResult.takenCount /
                model.workshopLists[index].workshopResult.lectureCount;
    final String _percentString = (_percent * 100).toStringAsFixed(0);
    return CircularPercentIndicator(
      radius: 40.0,
      lineWidth: 8.0,
      percent: _percent,
      addAutomaticKeepAlive: true,
      progressColor: Colors.green,
      center: Text("$_percentString%", style: cTextListSS, textScaleFactor: 1),
      animationDuration: 500,
      animation: true,
    );
  }

  Future<void> _onTap(
      BuildContext context, WorkshopModel model, int index) async {
    // Trainingへ
    ReturnArgument returnArgument = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureListPage(
          _userData,
          _organizer,
          model.workshopLists[index],
        ),
      ),
    );
    // todo 必須
    if (returnArgument == null) {
      returnArgument = ReturnArgument();
    } else {
      model.setWorkshopResult(
          returnArgument.workshopList.workshopResult, index);
    }
  }
}
