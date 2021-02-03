import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/buttons/white_button.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_license.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import 'graduater_model.dart';

class GraduaterListPage extends StatelessWidget {
  final UserData _userData;
  final WorkshopList _workshopList;

  GraduaterListPage(this._userData, this._workshopList);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GraduaterModel>(context, listen: false);
    Future(() async {
      await model.generateGraduaterList(_userData.userGroup, _workshopList);
    });
    return Consumer<GraduaterModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          title: BarTitle.instance.barTitle(context),
          leading: Container(),
          actions: [
            GoBack.instance.goBack(
                context: context, icon: Icon(FontAwesomeIcons.times), num: 1),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoArea(),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      // shrinkWrap: true,
                      itemCount: model.graduaters.length,
                      itemBuilder: (context, int index) {
                        return Card(
                          key: Key(model.graduaters[index].graduaterId),
                          shape: cListCardShape,
                          elevation: 20,
                          child: ListTile(
                            // dense: true,
                            title: _title(context, model, index),
                            subtitle: _subtitle(context, model, index),
                            onTap: () {
                              if (model.graduaterLists[index].userData.uid ==
                                  _userData.uid) {
                                GraduaterLicense.instance.licenseShowDialog(
                                  context,
                                  _workshopList,
                                  model.graduaterLists[index],
                                );
                              } else {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red[300],
                                  content: Text('自分以外の修了証は表示できません！',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  duration: Duration(milliseconds: 1500),
                                );
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
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
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${_workshopList.workshop.title}",
                    style: cTextUpBarM, textScaleFactor: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.userGraduate,
                    color: Colors.white, size: 15),
                SizedBox(width: 10),
                Text(" 研修会修了者", style: cTextUpBarL, textScaleFactor: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context, GraduaterModel model, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${model.graduaterLists[index].userData.userName}",
          style: cTextListL,
          textScaleFactor: 1,
        ),
      ],
    );
  }

  Widget _subtitle(BuildContext context, GraduaterModel model, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "修了日：${ConvertItems.instance.intToString(model.graduaterLists[index].graduater.takenAt)}",
          style: cTextListS,
          textScaleFactor: 1,
        ),
      ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              WhiteButton(
                context: context,
                title: '　閉じる',
                icon: FontAwesomeIcons.times,
                iconSize: 20,
                onPress: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
