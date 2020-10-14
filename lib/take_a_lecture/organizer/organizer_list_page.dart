import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/bar_title.dart';
import '../workshop/workshop_list_page.dart';
import '../../constants.dart';
import 'organizer_model.dart';

class OrganizerListPage extends StatefulWidget {
  final String groupName;
  final bool isNext;
  final List<Organizer> categoriesList;
  OrganizerListPage(this.groupName, this.isNext, this.categoriesList);

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
                    widget.groupName, widget.categoriesList[0]),
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context, listen: false);
    Future(() async {
      await model.fetchOrganizerList(widget.groupName);
    });
    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: barTitle(context),
          leading: goBack(
              context: context, icon: Icon(FontAwesomeIcons.home), num: 1),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _infoArea(),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: model.organizerList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: Key(model.organizerList[index].organizerId),
                          elevation: 15,
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "${model.organizerList[index].title}",
                              style: cTextListL,
                              textScaleFactor: 1,
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 20,
                            ),
                            onTap: () {
                              // Workshopへ
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkshopListPage(
                                      widget.groupName,
                                      model.organizerList[index]),
                                ),
                              );
                              // await model.fetchTarget(groupName);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (model.isLoading)
              Container(
                  color: Colors.black87.withOpacity(0.8),
                  child: Center(child: CircularProgressIndicator())),
          ],
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
}
