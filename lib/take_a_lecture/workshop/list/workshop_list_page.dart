import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/body_data.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants.dart';
import '../workshop_model.dart';
import 'bottomsheet_info_items_ws.dart';
import 'list_tile_body.dart';

class WorkshopListPage extends StatelessWidget {
  final UserData _userData;
  final Organizer _organizer;
  WorkshopListPage(this._userData, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WorkshopModel>(context, listen: false);
    bool _isHideBS = false;
    Future(() async {
      _isHideBS = await BodyData.instance.getIsHideWSBS();
      model.startLoading();
      if (_organizer.title == "指定無し") {
        //前画面で”指定無し”を選んだ場合は全ての研修会を取得
        await model.fetchLists(_userData.userGroup, _organizer);
      } else {
        await model.fetchListsByOrganizer(_userData.userGroup, _organizer);
      }
      model.stopLoading();
      if (_isHideBS == false) {
        await _showModalBottomSheetInfo(context, model, _isHideBS);
      }
    });
    return Consumer<WorkshopModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: GestureDetector(
            child: barTitle(context),
            onTap: () => _showModalBottomSheetInfo(context, model, _isHideBS),
          ),
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
                          child:
                              ListTileBody(_userData, _organizer, model, index),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.listAlt, size: 18, color: Colors.white),
                  SizedBox(width: 10),
                  Text(" 研修会一覧", style: cTextUpBarLL, textScaleFactor: 1),
                ],
              ),
            ),
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
        child: Text("", style: cTextUpBarL, textScaleFactor: 1),
      ),
    );
  }

  Future<Widget> _showModalBottomSheetInfo(
      BuildContext context, WorkshopModel model, bool _isHideBS) async {
    _isHideBS = await BodyData.instance.getIsHideWSBS();
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
        return BottomSheetInfoItemsWS(model, _isHideBS);
      },
    );
  }
}
