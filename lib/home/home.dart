import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/home/home_info.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_list_page.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../data/user_data/userdata_class.dart';
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
      drawer: HomeDrawer(_userData, _size),
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
        children: [
          Expanded(child: Container(child: _imageArea(context, _size))),
          Expanded(
            child: Container(
              child: FutureBuilder(
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageArea(BuildContext context, Size _size) {
    return Image.asset(
      "assets/images/top.png",
      fit: BoxFit.fitHeight,
    );
  }

  Widget _floatingActionButton(BuildContext context, WorkshopModel model) {
    return FloatingActionButton.extended(
      elevation: 30,
      icon: Icon(FontAwesomeIcons.chalkboardTeacher),
      label: Text(" 研修会一覧", style: cTextUpBarL, textScaleFactor: 1),
      backgroundColor: cFAB,
      // shape: cFABShape,
      onPressed: () => _floatABOnPressed(context, model),
    );
  }

  Future<void> _floatABOnPressed(
      BuildContext context, WorkshopModel model) async {
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
      child: SizedBox(
        height: cBottomAppBarH,
      ),
    );
  }
}
