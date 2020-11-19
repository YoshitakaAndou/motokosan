import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/widgets/convert_items.dart';

class GraduaterLicense {
  static final GraduaterLicense instance = GraduaterLicense();

  Future<Widget> licenseShowDialog(
    BuildContext context,
    WorkshopList _workshopList,
    GraduaterList _graduaterList,
  ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 20,
          title: Column(
            children: [
              Text("修了証書",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontWeight: FontWeight.w800),
                  textScaleFactor: 1),
              Row(
                children: [
                  Text("研修会名 ",
                      style: TextStyle(
                          fontSize: 8,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1),
                  Text("${_workshopList.workshop.title}",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1),
                ],
              ),
              Row(
                children: [
                  Text("受講者 ",
                      style: TextStyle(
                          fontSize: 8,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1),
                  Text("${_graduaterList.userData.userName}",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1),
                ],
              ),
              Row(
                children: [
                  Text("修了日 ",
                      style: TextStyle(
                          fontSize: 8,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1),
                  Text(
                      "${ConvertItems.instance.intToString((_graduaterList.graduater.takenAt))}",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800),
                      textScaleFactor: 1),
                ],
              ),
            ],
          ),
          actions: [
            MaterialButton(
              child: Text("OK"),
              elevation: 10,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
