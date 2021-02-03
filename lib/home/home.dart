import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/home/home_info.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_list_page.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:provider/provider.dart';
import '../data/constants.dart';
import '../user_data/userdata_class.dart';
import '../widgets/bar_title.dart';
import 'home_drawer.dart';
import 'home_info_not_signin.dart';

class Home extends StatelessWidget {
  final UserData _userData;
  Home(this._userData);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final model = Provider.of<WorkshopModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: BarTitle.instance.barTitle(context),
        centerTitle: true,
      ),
      drawer: HomeDrawer(_userData),
      body: _body(context, model, _size),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _floatingActionButton(context, model),
      bottomNavigationBar: _bottomNavigationBar(context, _userData),
    );
  }

  Future<List<WorkshopList>> _getWorkshopLists(WorkshopModel model) async {
    await model.fetchListsInfo(_userData.userGroup);
    return model.workshopLists;
  }

  Widget _body(BuildContext context, WorkshopModel model, Size _size) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _imageArea(context, _size),
              FutureBuilder(
                future: _getWorkshopLists(model),
                builder: (BuildContext context,
                    AsyncSnapshot<List<WorkshopList>> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    return HomeInfo(_userData, snapshot.data, _size);
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageArea(BuildContext context, Size _size) {
    return Container(
      child: Image.asset(
        "assets/images/top.png",
        width: _size.width,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context, WorkshopModel model) {
    return FloatingActionButton.extended(
      elevation: 30,
      icon: Icon(FontAwesomeIcons.chalkboardTeacher),
      label: Text(" 研修会一覧", style: cTextUpBarL, textScaleFactor: 1),
      backgroundColor: cFAB,
      // shape: cFABShape,
      onPressed: () async {
        if (FSUserData.instance.isCurrentUserSignIn()) {
          List<Organizer> _organizers = List();
          Organizer _organizer = Organizer(title: "指定無し");
          _organizers.add(_organizer);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkshopListPage(_userData, _organizers[0]),
            ),
          );
          await model.fetchListsInfo(_userData.userGroup);
          // model.stopLoading();
        } else {
          InfoNotSignin.instance.function(
            context,
            "サインアウトしているので\n実行できません",
            "サインインしますか？",
            _userData,
          );
        }
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context, UserData _userData) {
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
        padding: EdgeInsets.only(left: 15, right: 10, top: 3),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: Text("グループ:", style: cTextUpBarS, textScaleFactor: 1),
            //     ),
            //     Expanded(
            //         flex: 5,
            //         child: Text("${_userData.userGroup}",
            //             style: cTextUpBarS, textScaleFactor: 1)),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 1,
            //         child:
            //             Text("Name:", style: cTextUpBarS, textScaleFactor: 1)),
            //     Expanded(
            //         flex: 5,
            //         child: Text("${_userData.userName}",
            //             style: cTextUpBarS, textScaleFactor: 1)),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 1,
            //         child:
            //             Text("Uid:", style: cTextUpBarS, textScaleFactor: 1)),
            //     Expanded(
            //         flex: 5,
            //         child: Text("${_userData.uid}",
            //             style: cTextUpBarS, textScaleFactor: 1)),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
