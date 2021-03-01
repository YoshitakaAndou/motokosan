import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_list_page.dart';
import 'package:motokosan/widgets/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/user_data/userdata_firebase.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'home_info_not_signin.dart';

class HomeInfo extends StatelessWidget {
  final UserData _userData;
  final List<WorkshopList> _workshopLists;
  final Size _size;
  HomeInfo(this._userData, this._workshopLists, this._size);

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
          _infoTitle(context, _size, _userData),
          Expanded(child: _infoList(context, _workshopLists, _size, _userData)),
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
          Icon(FontAwesomeIcons.infoCircle, size: 15, color: Colors.white),
          SizedBox(width: 5),
          Text(
            "Information",
            style: cTextUpBarM,
          ),
        ],
      ),
    );
  }

  Widget _infoList(BuildContext context, List<WorkshopList> _workshopLists,
      Size size, UserData userData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _workshopLists.length,
      itemBuilder: (context, int index) {
        final bool _isInfoEmpty =
            _workshopLists[index].workshop.information.isEmpty;
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
                  title: _title(context, _workshopLists, index),
                  onTap: () async {
                    if (FSUserData.instance.isCurrentUserSignIn()) {
                      ReturnArgument returnArgument = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LectureListPage(
                              _userData, _workshopLists[index], "fromHome"),
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
                          _userData);
                    }
                  },
                ),
              );
      },
    );
  }

  Widget _title(
      BuildContext context, List<WorkshopList> _workshopLists, int index) {
    final _isSubInfoNotEmpty =
        _workshopLists[index].workshop.subInformation.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                "${ConvertItems.instance.intToString(_workshopLists[index].workshop.updateAt)}",
                style: cTextListM,
                textScaleFactor: 1),
            SizedBox(width: 10),
            if (_isSubInfoNotEmpty)
              Container(
                  color: Colors.red.withOpacity(0.2),
                  child: Text(
                      " ${_workshopLists[index].workshop.subInformation} ",
                      style: cTextListS,
                      textScaleFactor: 1)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("・${_workshopLists[index].workshop.information}",
                style: cTextListM, textScaleFactor: 1),
          ],
        ),
      ],
    );
  }
}
