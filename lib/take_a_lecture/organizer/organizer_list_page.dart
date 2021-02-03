import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_list_page.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/bar_title.dart';
import '../../data/constants.dart';
import 'organizer_model.dart';
import 'organizer_list_bottomsheet_info_items.dart';

class OrganizerListPage extends StatelessWidget {
  final UserData _userData;
  OrganizerListPage(this._userData);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<OrganizerModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchOrganizerList(_userData.userGroup);
      model.stopLoading();
    });
    return Consumer<OrganizerModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: GestureDetector(
            child: BarTitle.instance.barTitle2(context),
            onTap: () => _showModalBottomSheetInfo(context, model),
          ),
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
                      itemBuilder: (context, int index) {
                        return Card(
                          key: Key(model.organizerList[index].organizerId),
                          shape: cListCardShape,
                          elevation: 15,
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "${model.organizerList[index].title}",
                              style: cTextListL,
                              textScaleFactor: 1,
                            ),
                            // trailing: Icon(FontAwesomeIcons.arrowRight, size: 20),
                            onTap: () async {
                              // Workshopへ
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkshopListPage(
                                    _userData,
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

  Future<Widget> _showModalBottomSheetInfo(
      BuildContext context, OrganizerModel model) async {
    return await showModalBottomSheet(
      context: context,
      // isDismissible: false,
      elevation: 20,
      // enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return OrganizerListBottomSheetInfoItems(model);
      },
    );
  }
}
