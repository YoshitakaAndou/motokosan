import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motokosan/take_a_lecture/workshop/list/workshop_list_page.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/bar_title.dart';
import '../../../constants.dart';
import '../organizer_class.dart';
import '../organizer_model.dart';

class OrganizerListPage extends StatefulWidget {
  final UserData _userData;
  final bool isNext;
  final List<Organizer> organizerLists;
  OrganizerListPage(this._userData, this.isNext, this.organizerLists);

  @override
  _OrganizerListPageState createState() => _OrganizerListPageState();
}

class _OrganizerListPageState extends State<OrganizerListPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isNext) {
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkshopListPage(
                    widget._userData, widget.organizerLists[0]),
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context, listen: false);
    Future(() async {
      await model.fetchOrganizerList(widget._userData.userGroup);
    });
    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: barTitle(context),
          leading: GoBack.instance.goBack(
              context: context, icon: Icon(FontAwesomeIcons.home), num: 1),
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: _infoArea()),
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: model.organizerList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: Key(model.organizerList[index].organizerId),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 15,
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "${model.organizerList[index].title}",
                              style: cTextListL,
                              textScaleFactor: 1,
                            ),
                            // trailing: Icon(FontAwesomeIcons.arrowRight, size: 20),
                            onTap: () {
                              // Workshopへ
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkshopListPage(
                                    widget._userData,
                                    model.organizerList[index],
                                  ),
                                ),
                              );
                              // await model.fetchTarget(groupName);
                            },
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
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(" 主催者一覧", style: cTextUpBarLL, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
