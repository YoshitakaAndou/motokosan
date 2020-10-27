import 'package:flutter/material.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../lecture/lecture_list_page.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/go_back.dart';
import '../../constants.dart';

class WorkshopListPage extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  WorkshopListPage(this.groupName, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      if (_organizer.title == "指定無し") {
        //前画面で”指定無し”を選んだ場合は全ての研修会を取得
        await model.fetchLists(groupName, _organizer);
      } else {
        await model.fetchListsByCategory(groupName, _organizer);
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
                          key: Key(model.workshopLists[index].workshopId),
                          elevation: 15,
                          child: ListTile(
                            dense: true,
                            leading: _leading(context, model, index),
                            title: _title(context, model, index),
                            // trailing: Icon(FontAwesomeIcons.arrowRight, size: 20),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" 研修会一覧", style: cTextUpBarLL, textScaleFactor: 1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("主催：", style: cTextUpBarM, textScaleFactor: 1),
                    Text(_organizer.title,
                        style: cTextUpBarM, textScaleFactor: 1),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _leading(BuildContext context, WorkshopModel model, int index) {
    return Text(
      "${model.workshopLists[index].listNo}",
      style: cTextListS,
      textScaleFactor: 1,
    );
  }

  Widget _title(BuildContext context, WorkshopModel model, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_organizer.title == "指定無し")
          Text(
            "主催：${model.workshopLists[index].organizerName}",
            style: cTextListSS,
            textAlign: TextAlign.center,
            textScaleFactor: 1,
          ),
        Text(
          "${model.workshopLists[index].title}",
          style: cTextListL,
          textScaleFactor: 1,
        ),
      ],
    );
  }

  void _onTap(BuildContext context, WorkshopModel model, int index) {
    // Trainingへ
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LectureListPage(
            groupName,
            _organizer,
            model.workshopLists[index],
          ),
        ));
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
}
