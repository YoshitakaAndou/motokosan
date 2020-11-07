import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motokosan/widgets/convert_items.dart';

import '../organizer_class.dart';

class FSOrganizer {
  static final FSOrganizer instance = FSOrganizer();

  Future<List<Organizer>> fetchDates(
    String _groupName,
  ) async {
    final _docs = await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Organizer")
        .orderBy('organizerNo', descending: false)
        .get();
    return _docs.docs
        .map((doc) => Organizer(
              organizerId: doc["organizerId"],
              organizerNo: doc["organizerNo"],
              title: doc["title"],
              subTitle: doc["subTitle"],
              option1: doc["option1"],
              option2: doc["option2"],
              option3: doc["option3"],
              updateAt: doc["upDate"],
              createAt: doc["createAt"],
            ))
        .toList();
  }

  Future<void> setData(
    bool _isAdd,
    String _groupName,
    Organizer _data,
    DateTime _timeStamp,
  ) async {
    final _organizerId = _isAdd ? _timeStamp.toString() : _data.organizerId;
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Organizer")
        .doc(_organizerId)
        .set({
      "organizerId": _organizerId,
      "organizerNo": _data.organizerNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "upDate": ConvertItems.instance.dateToInt(_timeStamp),
      "createAt":
          _isAdd ? ConvertItems.instance.dateToInt(_timeStamp) : _data.createAt,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteData(
    String _groupName,
    String _organizerId,
  ) async {
    await FirebaseFirestore.instance
        .collection("Groups")
        .doc(_groupName)
        .collection("Organizer")
        .doc(_organizerId)
        .delete();
  }
}
