import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/take_a_lecture/graduater/graduater_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/widgets/convert_datetime.dart';

class GraduaterLicense {
  static final GraduaterLicense instance = GraduaterLicense();

  Radius _radius = Radius.circular(15);

  Future<Widget> licenseShowDialog(BuildContext context,
      WorkshopList _workshopList, GraduaterList _graduaterList) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cContBg,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              _radius,
            ),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: _radius,
                topRight: _radius,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.userGraduate,
                  color: Colors.black54,
                  size: 18,
                ),
                Text(
                  "   修了証書",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _columnItem("研修会名", _workshopList.workshop.title),
              _columnItem("受講者", _graduaterList.userData.userName),
              _columnItem(
                "修了日",
                ConvertDateTime.instance
                    .intToString((_graduaterList.graduater.takenAt)),
              ),
            ],
          ),
          buttonPadding: EdgeInsets.zero,
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 18,
                    ),
                    Text(
                      " 閉じる　　",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1,
                    ),
                  ],
                ),
                height: 30,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: _radius,
                    bottomRight: _radius,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _columnItem(String _subTitle, _mainTitle) {
    Color _fontColor = Colors.white;
    FontWeight _fontWeight = FontWeight.w800;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              _subTitle,
              style: TextStyle(
                fontSize: 9,
                color: _fontColor,
                fontWeight: _fontWeight,
              ),
              textScaleFactor: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(_mainTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: _fontColor,
                  fontWeight: _fontWeight,
                ),
                textScaleFactor: 1),
          ),
        ],
      ),
    );
  }
}
