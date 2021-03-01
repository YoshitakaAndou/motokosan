import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../take_a_lecture/lecture/lecture_class.dart';
import '../../take_a_lecture/lecture/lecture_model.dart';

class LectureEditImage extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  final Workshop _workshop;
  final Organizer _organizer;
  LectureEditImage(
      this.groupName, this._lecture, this._workshop, this._organizer);

  @override
  Widget build(BuildContext context) {
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                _infoArea(model),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _gridSlide(model, context),
                    ),
                  ],
                ),
              ],
            ),
            if (model.isLoading)
              Container(
                color: Colors.black87.withOpacity(0.8),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    });
  }

  Widget _infoArea(LectureModel model) {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text("　番号：${_lecture.lectureNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("主催：${_organizer.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                  Text("研修会：${_workshop.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridSlide(LectureModel model, context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cPopWindow),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
              ),
              color: cPopWindow,
            ),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.images, color: cTextPopIcon),
                Text("  スライド登録 ： ", style: cTextPopM, textScaleFactor: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                      "+を押してスライドを登録してください。"
                      "\nタイルを長押しして削除もできます。",
                      style: cTextPopS,
                      textScaleFactor: 1),
                ),
              ],
            ),
          ),
          _gridView(model, context),
        ],
      ),
    );
  }

  Widget _gridView(LectureModel model, context) {
    // グリッドリストの高さを調整するための数式（１段増えるごとに１行増やす）
    double a = (model.slides.length - 1) / 3;
    int b = a.toInt() + 1;
    return Container(
      width: MediaQuery.of(context).size.width - cEditOffsetW,
      height: (MediaQuery.of(context).size.width) / 3 * b,
      // color: Colors.greenAccent.withOpacity(0.2),
      padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 3,
        ),
        itemCount: model.slides.length,
        itemBuilder: (context, index) {
          return _gridTile(model, model.slides[index], index);
        },
      ),
    );
  }

  Widget _gridTile(LectureModel model, Slide _slide, int _index) {
    return GestureDetector(
      onTap: () {
        _slideTileOnTap(model, _slide, _index);
        if (_index == model.slides.length - 1) {
          model.slides.add(Slide(slideImage: null));
        }
      },
      onLongPress: () async {
        if (_slide.slideUrl.isNotEmpty || _slide.slideImage != null) {
          model.isUpdate = true;
          model.isSlideUpdate = true;
          model.deletedSlides.add(
              DeletedSlide(slideNo: _slide.slideNo, slideUrl: _slide.slideUrl));
          model.slideRemoveAt(_index);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.orange,
          child: _slide.slideImage != null
              ? Image.file(_slide.slideImage, fit: BoxFit.cover)
              : _slide.slideUrl.isNotEmpty
                  ? Image.network(_slide.slideUrl, fit: BoxFit.cover)
                  : Icon(FontAwesomeIcons.plus, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _slideTileOnTap(
      LectureModel model, Slide _slide, int _index) async {
    final File _image = await model.selectImage(_slide.slideImage);
    if (_image != null) {
      model.isUpdate = true;
      model.isSlideUpdate = true;
      model.setSlideImage(_index, _image);
    }
  }
}
