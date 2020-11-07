import 'package:flutter/material.dart';
import 'package:motokosan/home/home_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_firebase.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';

class HomeModel extends ChangeNotifier {
  HomeData homeData = HomeData();
  List<Workshop> infoLists = List();

  Future<void> fetchInfoList(_groupName) async {
    infoLists = await FSWorkshop.instance.fetchDatesAll(_groupName);
    notifyListeners();
  }
}
