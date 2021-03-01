import 'package:flutter/cupertino.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';

import 'graduater_class.dart';
import 'graduater_firebase.dart';

class GraduaterModel extends ChangeNotifier {
  List<Graduater> graduaters = List();
  Graduater graduater = Graduater();
  List<GraduaterList> graduaterLists = List();
  GraduaterList graduaterList = GraduaterList();

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> generateGraduaterList(
      String _groupName, WorkshopList _workshopList) async {
    graduaterLists = List();
    graduaters =
        await FSGraduater.instance.fetchDates(_groupName, _workshopList);
    for (Graduater _graduater in graduaters) {
      final _userData =
          await FSUserData.instance.fetchUserData(_graduater.uid, _groupName);
      if (_userData != null) {
        graduaterLists.add(
          GraduaterList(
            userData: _userData,
            graduater: _graduater,
          ),
        );
      } else {
        graduaterLists.add(
          GraduaterList(
            userData: UserData(),
            graduater: _graduater,
          ),
        );
      }
    }
    notifyListeners();
  }
}
