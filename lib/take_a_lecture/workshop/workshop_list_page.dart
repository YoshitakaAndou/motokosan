import 'package:flutter/material.dart';
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
          title: barTitle(context),
          leading: goBack(
              context: context,
              icon: Icon(FontAwesomeIcons.chevronLeft),
              num: 1),
          actions: [
            goBack(context: context, icon: Icon(FontAwesomeIcons.home), num: 2),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _infoArea(),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height - 175,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: model.workshopLists.length,
                      itemBuilder: (context, index) {
                        return Card(
                            key: Key(model.workshopLists[index].workshopId),
                            elevation: 15,
                            child: ListTile(
                              dense: true,
                              leading: Text(
                                "${model.workshopLists[index].listNo}",
                                style: cTextListS,
                                textScaleFactor: 1,
                              ),
                              title: Column(
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
                              ),
                              trailing: Icon(
                                FontAwesomeIcons.arrowRight,
                                size: 20,
                              ),
                              onTap: () {
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
                              },
                            ));
                      },
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height - 175,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black87.withOpacity(0.8),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Container(
            height: 45,
            padding: EdgeInsets.all(10),
            child: Text(
              "",
              style: cTextUpBarL,
              textScaleFactor: 1,
            ),
          ),
        ),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
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
}
