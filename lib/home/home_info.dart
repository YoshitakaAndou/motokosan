import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/list/lecture_list_page.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_model.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';

import '../constants.dart';

class HomeInfo extends StatelessWidget {
  final UserData _userData;
  final WorkshopModel model;
  final Size _size;
  HomeInfo(this._userData, this.model, this._size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: cContBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _infoTitle(context, _size, _userData),
          _infoList(context, model, _size, _userData),
        ],
      ),
    );
  }

  Widget _infoTitle(BuildContext context, Size size, UserData userData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      width: size.width,
      color: Colors.green,
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

  Widget _infoList(
      BuildContext context, WorkshopModel model, Size size, UserData userData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.workshopLists.length,
      itemBuilder: (context, int index) {
        final bool _isInfoEmpty =
            model.workshopLists[index].workshop.information.isEmpty;
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
                  title: _title(context, model, index),
                  onTap: () async {
                    ReturnArgument returnArgument = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LectureListPage(
                            _userData, model.workshopLists[index], "fromHome"),
                      ),
                    );
                    // todo 必須
                    if (returnArgument == null) {
                      returnArgument = ReturnArgument();
                    } else {
                      model.setWorkshopResult(
                          returnArgument.workshopList.workshopResult, index);
                    }
                  },
                ),
              );
      },
    );
  }

  Widget _title(BuildContext context, WorkshopModel model, int index) {
    final _isSubInfoNotEmpty =
        model.workshopLists[index].workshop.subInformation.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
                "${ConvertItems.instance.intToString(model.workshopLists[index].workshop.updateAt)}",
                style: cTextListM,
                textScaleFactor: 1),
            SizedBox(width: 10),
            if (_isSubInfoNotEmpty)
              Container(
                  color: Colors.red.withOpacity(0.2),
                  child: Text(
                      " ${model.workshopLists[index].workshop.subInformation} ",
                      style: cTextListS,
                      textScaleFactor: 1)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("・${model.workshopLists[index].workshop.information}",
                style: cTextListM, textScaleFactor: 1),
          ],
        ),
      ],
    );
  }
}
