import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_list_page.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../data/constants.dart';
import '../../widgets/return_argument.dart';
import 'workshop_model.dart';

class WorkshopListTileBody extends StatelessWidget {
  final UserData _userData;
  final WorkshopModel model;
  final int index;
  WorkshopListTileBody(this._userData, this.model, this.index);

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
    final String _isTaken = model.workshopLists[index].workshopResult.isTaken;
    bool _isTakenCount =
        model.workshopLists[index].workshopResult.takenCount == 0
            ? false
            : true;
    bool _isExam = model.workshopLists[index].workshop.isExam;
    bool _isClear = _isTaken == "受講済" ? true : false;
    bool _isFinish = _isTaken == "研修済" ? true : false;
    return Container(
      padding: EdgeInsets.all(3),
      color: _isFinish
          ? Colors.green[800]
          : _isClear
              ? Colors.green.withOpacity(0.2)
              : _isTakenCount
                  ? Colors.red.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_isFinish)
            Text(
              " $_isTaken ",
              style: cTextUpBarS,
              textScaleFactor: 1,
            ),
          if (!_isFinish)
            Text(
              _isTakenCount ? " $_isTaken " : " 未受講 ",
              style: cTextListS,
              textScaleFactor: 1,
            ),
          if (_isExam && _isClear)
            Text(
              " 試験未 ",
              style: cTextListSR,
              textScaleFactor: 1,
            ),
          if (_isTaken == "受講中")
            Text(
              "${model.workshopLists[index].workshopResult.takenCount} /"
              " ${model.workshopLists[index].workshop.lectureLength}",
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
    final bool _overDeadlineAt =
        model.workshopLists[index].workshop.deadlineAt <=
            ConvertItems.instance.dateToInt(DateTime.now());
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
                style: _overDeadlineAt ? cTextListSR : cTextListS,
                textScaleFactor: 1,
              ),
            ),
            if (model.workshopLists[index].organizerTitle == "指定無し")
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
  //
  // Widget _trailing(BuildContext context, WorkshopModel model, int index) {
  //   final double _percent =
  //       model.workshopLists[index].workshopResult.lectureCount == 0
  //           ? 0
  //           : model.workshopLists[index].workshopResult.takenCount /
  //               model.workshopLists[index].workshopResult.lectureCount;
  //   final String _percentString = (_percent * 100).toStringAsFixed(0);
  //   return GFProgressBar(
  //     animation: true,
  //     animationDuration: 500,
  //     percentage: _percent,
  //     width: 50,
  //     radius: 40,
  //     backgroundColor: Colors.black26,
  //     progressBarColor: Colors.green[800],
  //     child: Text("$_percentString %", style: cTextListSS, textScaleFactor: 1),
  //   );
  // }

  Future<void> _onTap(
      BuildContext context, WorkshopModel model, int index) async {
    // Trainingへ
    ReturnArgument returnArgument = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureListPage(
            _userData, model.workshopLists[index], "fromWorkshop"),
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
