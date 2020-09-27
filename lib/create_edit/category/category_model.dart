import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motokosan/create_edit/target/target_model.dart';
import 'package:motokosan/widgets/convert_date_to_int.dart';

class Category {
  String categoryId;
  String categoryNo;
  String title;
  String subTitle;
  String option1;
  String option2;
  String option3;
  int updateAt;
  int createAt;
  String targetId;
  String key;

  Category({
    this.categoryId = "",
    this.categoryNo = "",
    this.title = "",
    this.subTitle = "",
    this.option1 = "",
    this.option2 = "",
    this.option3 = "",
    this.updateAt = 0,
    this.createAt = 0,
    this.targetId = "",
    this.key = "",
  });
}

class CategoryModel extends ChangeNotifier {
  List<Category> categories = [];
  Category category = Category();
  bool isLoading = false;
  bool isUpdate = false;

  void initData(Target _target) {
    category.categoryId = "";
    category.categoryNo = "";
    category.title = "";
    category.subTitle = "";
    category.option1 = "";
    category.option2 = "";
    category.option3 = "";
    category.updateAt = 0;
    category.createAt = 0;
    category.targetId = _target.targetId;
  }

  void changeValue(String _arg, String _val) {
    switch (_arg) {
      case "categoryId":
        category.categoryId = _val;
        break;
      case "categoryNo":
        category.categoryNo = _val;
        break;
      case "title":
        category.title = _val;
        break;
      case "subTitle":
        category.subTitle = _val;
        break;
      case "option1":
        category.option1 = _val;
        break;
      case "option2":
        category.option2 = _val;
        break;
      case "option3":
        category.option3 = _val;
        break;
    }
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setUpdate() {
    isUpdate = true;
    notifyListeners();
  }

  void resetUpdate() {
    isUpdate = false;
    notifyListeners();
  }

  Future<void> fetchCategory(String _groupName) async {
    categories = await _fetchCategory(_groupName);
    notifyListeners();
  }

  Future<List<Category>> _fetchCategory(_groupName) async {
    final _docs = await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Target")
        .document(category.targetId)
        .collection("Category")
        .orderBy('categoryNo', descending: false)
        .getDocuments();
    return _docs.documents
        .map((doc) => Category(
              categoryId: doc["categoryId"],
              categoryNo: doc["categoryNo"],
              title: doc["title"],
              subTitle: doc["subTitle"],
              option1: doc["option1"],
              option2: doc["option2"],
              option3: doc["option3"],
              updateAt: doc["upDate"],
              createAt: doc["createAt"],
              targetId: doc["targetId"],
            ))
        .toList();
  }

  Future<void> addCategoryFs(_groupName, _timeStamp) async {
    if (category.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    category.categoryId = _timeStamp.toString();
    await setCategoryFs(true, _groupName, category, _timeStamp);
    notifyListeners();
  }

  Future<void> updateCategoryFs(_groupName, _timeStamp) async {
    if (category.title.isEmpty) {
      throw "タイトル が入力されていません！";
    }
    await setCategoryFs(false, _groupName, category, _timeStamp);
    notifyListeners();
  }

  Future<void> setCategoryFs(bool _isAdd, String _groupName, Category _data,
      DateTime _timeStamp) async {
    final _categoryId = _isAdd ? _timeStamp.toString() : _data.categoryId;
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Target")
        .document(category.targetId)
        .collection("Category")
        .document(_categoryId)
        .setData({
      "categoryId": _categoryId,
      "categoryNo": _data.categoryNo,
      "title": _data.title,
      "subTitle": _data.subTitle,
      "option1": _data.option1,
      "option2": _data.option2,
      "option3": _data.option3,
      "upDate": convertDateToInt(_timeStamp),
      "createAt": _isAdd ? convertDateToInt(_timeStamp) : _data.createAt,
      "targetId": _data.targetId,
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> deleteCategoryFs(_groupName, _targetId, _categoryId) async {
    await Firestore.instance
        .collection("Groups")
        .document(_groupName)
        .collection("Target")
        .document(_targetId)
        .collection("Category")
        .document(_categoryId)
        .delete();
    notifyListeners();
  }
}
