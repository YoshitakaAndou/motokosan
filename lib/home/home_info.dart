import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/list/lecture_list_page.dart';
import 'package:motokosan/widgets/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/data/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'home_info_not_signin.dart';

class HomeInfo extends StatelessWidget {
  final UserData userData;
  final List<WorkshopList> workshopList;
  final Size size;
  HomeInfo(
    this.userData,
    this.workshopList,
    this.size,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          )
        ],
      ),
      // color: cContBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _infoTitle(context, size, userData),
          Expanded(child: _infoList(context, workshopList, size, userData)),
        ],
      ),
    );
  }

  Widget _infoTitle(BuildContext context, Size size, UserData userData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          Icon(FontAwesomeIcons.infoCircle, size: 15, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Information ",
            style: cTextUpBarM,
          ),
          Text(
            "（${userData.userGroup}）",
            style: cTextUpBarM,
          ),
        ],
      ),
    );
  }

  Widget _infoList(BuildContext context, List<WorkshopList> workshopList,
      Size size, UserData userData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: workshopList.length,
      itemBuilder: (context, int index) {
        final bool _isInfoEmpty =
            workshopList[index].workshop.information.isEmpty;
        return _isInfoEmpty
            ? Container()
            : Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                child: ListTile(
                  dense: true,
                  title: _title(context, workshopList, index),
                  onTap: () async {
                    if (FSUserData.instance.isCurrentUserSignIn()) {
                      ReturnArgument returnArgument = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LectureListPage(
                            userData: userData,
                            workshopList: workshopList[index],
                            routeName: "fromHome",
                          ),
                        ),
                      );
                      // todo 必須
                      if (returnArgument == null) {
                        returnArgument = ReturnArgument();
                      } else {
                        final model =
                            Provider.of<WorkshopModel>(context, listen: false);
                        model.setWorkshopResult(
                            returnArgument.workshopList.workshopResult, index);
                      }
                    } else {
                      InfoNotSignin.instance.function(
                          context,
                          "サインアウトしているので"
                              "\n実行できません",
                          "サインインしますか？",
                          userData);
                    }
                  },
                ),
              );
      },
    );
  }

  Widget _title(
      BuildContext context, List<WorkshopList> workshopList, int index) {
    final _isSubInfoNotEmpty =
        workshopList[index].workshop.subInformation.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                "${ConvertDateTime.instance.intToString(workshopList[index].workshop.updateAt)}",
                style: cTextListM,
                textScaleFactor: 1),
            SizedBox(width: 10),
            if (_isSubInfoNotEmpty)
              Container(
                  color: Colors.red.withOpacity(0.2),
                  child: Text(
                      " ${workshopList[index].workshop.subInformation} ",
                      style: cTextListS,
                      textScaleFactor: 1)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("・${workshopList[index].workshop.information}",
                style: cTextListM, textScaleFactor: 1),
          ],
        ),
      ],
    );
  }
}
