import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/play/organizer_class.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../lecture/play/lecture_list_page.dart';
import 'workshop_model.dart';
import '../../../widgets/bar_title.dart';
import '../../../widgets/go_back.dart';
import '../../../constants.dart';

class WorkshopListPage extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  WorkshopListPage(this._userData, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      if (_organizer.title == "指定無し") {
        //前画面で”指定無し”を選んだ場合は全ての研修会を取得
        await model.fetchLists(_userData.userGroup, _organizer);
      } else {
        await model.fetchListsByOrganizer(_userData.userGroup, _organizer);
      }
      model.stopLoading();
    });
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          leading: GoBack.instance.goBack(
              context: context,
              icon: Icon(FontAwesomeIcons.chevronLeft),
              num: 1),
          actions: [
            GoBack.instance.goBack(
                context: context, icon: Icon(FontAwesomeIcons.home), num: 2),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: model.workshopLists.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: Key(
                              model.workshopLists[index].workshop.workshopId),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 20,
                          child: ListTile(
                            // dense: true,
                            leading: _leading(context, model, index),
                            title: _title(context, model, index),
                            trailing: _trailing(context, model, index),
                            onTap: () => _onTap(context, model, index),
                          ),
                        );
                      },
                    ),
                  ),
                  if (model.isLoading) GuriGuri.instance.guriguri3(context),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(context),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" 研修会一覧", style: cTextUpBarLL, textScaleFactor: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("主催：${_organizer.title}",
                    style: cTextUpBarS, textScaleFactor: 1),
              ],
            )
          ],
        ),
      ),
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
    model.setWorkshopResult(returnArgument.workshopList.workshopResult, index);
    // await model.fetchTarget(groupName);
  }

  Widget _bottomNavigationBar(BuildContext context) {
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
        padding: EdgeInsets.all(10),
        child: Text(
          "",
          style: cTextUpBarL,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  // Future<void> _initWorkshop(WorkshopModel model) async {
  //   model.startLoading();
  //   if (_organizer.title == "指定無し") {
  //     //前画面で”指定無し”を選んだ場合は全ての研修会を取得
  //     await model.fetchLists(groupName, _organizer);
  //   } else {
  //     await model.fetchListsByCategory(groupName, _organizer);
  //   }
  //   model.stopLoading();
  // }
}
