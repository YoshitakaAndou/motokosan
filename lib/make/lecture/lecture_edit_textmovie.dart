import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/widgets/show_dialog.dart';

import '../../constants.dart';
import '../../take_a_lecture/lecture/lecture_class.dart';
import '../../take_a_lecture/lecture/lecture_model.dart';
import 'lecture_video.dart';
import 'lecture_web.dart';

class LectureEditTextMovie extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  final Workshop _workshop;
  final Organizer _organizer;
  final TextEditingController titleTextController;
  final TextEditingController subTitleTextController;
  final TextEditingController descTextController;
  final TextEditingController videoUrlTextController;
  final LectureModel model;

  LectureEditTextMovie(
    this.groupName,
    this._lecture,
    this._workshop,
    this._organizer,
    this.titleTextController,
    this.subTitleTextController,
    this.descTextController,
    this.videoUrlTextController,
    this.model,
  );

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<LectureModel>(context, listen: false);
    final Size _size = MediaQuery.of(context).size;
    titleTextController.text = _lecture.title;
    subTitleTextController.text = _lecture.subTitle;
    descTextController.text = _lecture.description;
    videoUrlTextController.text = _lecture.videoUrl;
    model.isVideoPlay = _lecture.videoUrl.isNotEmpty ? true : false;

    // return Consumer<LectureModel>(builder: (context, model, child) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _infoArea(model),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _title(model, titleTextController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _subTitle(model, subTitleTextController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _videoUrl(model, videoUrlTextController, context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          if (model.lecture.videoUrl.isNotEmpty &&
                              model.isVideoPlay)
                            _videoButton(model, context, _size),
                          _webButton(
                            model,
                            context,
                            titleTextController,
                            videoUrlTextController,
                            descTextController,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _description(model, descTextController),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (model.isLoading)
            Container(
              color: Colors.black87.withOpacity(0.8),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
    // });
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

  Widget _title(LectureModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _titleTextController,
      decoration: InputDecoration(
        labelText: "講義名",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "講義名 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _titleTextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      // onChanged: (text) {
      //   // model.isUpdate = true;
      //   model.changeValue("title", text);
      // },
      onSubmitted: (text) {
        model.changeValue("title", text);
        model.setUpdate();
      },
    );
  }

  Widget _subTitle(LectureModel model, _subTitleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _subTitleTextController,
      decoration: InputDecoration(
        labelText: "subTitle",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "subTitle を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _subTitleTextController.text = "";
            model.setUpdate();
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      // onChanged: (text) {
      //   model.changeValue("subTitle", text);
      //   // model.isUpdate = true;
      // },
      onSubmitted: (text) {
        model.changeValue("subTitle", text);
        model.setUpdate();
      },
    );
  }

  Widget _description(LectureModel model, _descTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _descTextController,
      decoration: InputDecoration(
        labelText: "説明:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "説明 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _descTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      // onChanged: (text) {
      //   model.changeValue("description", text);
      //   // model.isUpdate = true;
      // },
      onSubmitted: (text) {
        model.changeValue("description", text);
        model.setUpdate();
      },
    );
  }

  Widget _videoUrl(
    LectureModel model,
    _videoUrlTextController,
    context,
  ) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "YouTubeURL",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "YouTube動画URL を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _videoUrlTextController.text = "";
            model.changeValue("videoUrl", "");
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: _videoUrlTextController,
      // onChanged: (text) {
      //   model.changeValue("videoUrl", text);
      // },
      onSubmitted: (text) {
        if (model.isVideoUrl(text)) {
          model.changeValue("videoUrl", text);
          // model.isUpdate = true;
        } else {
          MyDialog.instance.okShowDialog(
            context,
            "YouTubeのURLを\n入力してください！",
            Colors.red,
          );
          _videoUrlTextController.text = "";
        }
      },
    );
  }

  Widget _webButton(
    LectureModel model,
    context,
    titleTextController,
    videoUrlTextController,
    descTextController,
  ) {
    // webBookmarkUrlの読み込み
    Future(() async {
      await DataSave.getString("_bookmark").then((value) {
        model.webBookmarkUrl = value ?? "";
      });
    });
    return Expanded(
      child: Container(
        height: 57,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: RaisedButton.icon(
          icon: Icon(FontAwesomeIcons.youtube, color: Colors.red, size: 30),
          label: Text("Webから取込む", style: cTextListM, textScaleFactor: 1),
          color: Colors.yellow[50],
          padding: EdgeInsets.symmetric(horizontal: 10),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          onPressed: () async {
            // await _checkWeb(context);
            bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LectureWeb(),
                fullscreenDialog: true,
              ),
            );
            if (result) {
              titleTextController.text = model.lecture.title;
              videoUrlTextController.text = model.lecture.videoUrl;
              descTextController.text = model.lecture.description;
              model.setVideoPlay(true);
              model.setUpdate();
            }
          },
        ),
      ),
    );
  }

  Widget _videoButton(
    LectureModel model,
    BuildContext context,
    Size _size,
  ) {
    final _imageUrl = model.lecture.thumbnailUrl ?? "";
    return Container(
      width: _size.width / 2 - 10,
      child: RaisedButton.icon(
        padding: EdgeInsets.only(left: 0, right: 10),
        icon: _imageUrl.isNotEmpty
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    child: Container(
                      width: 60,
                      height: 50,
                      color: Colors.black54.withOpacity(0.8),
                      child: Image.network(_imageUrl),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 50,
                    alignment: Alignment.bottomRight,
                    child: Container(
                      color: Colors.black54.withOpacity(0.8),
                      child: Text("${model.lecture.videoDuration}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1),
                    ),
                  ),
                ],
              )
            : Container(
                width: 60,
                height: 50,
                child: Image.asset(
                  "assets/images/noImage.png",
                  fit: BoxFit.cover,
                ),
              ),
        label: Text("動画を確認", style: cTextListM, textScaleFactor: 1),
        color: Colors.yellow[50],
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        onPressed: () async {
          if (model.isVideoUrl(model.lecture.videoUrl)) {
            await _checkVideoSheet(context, model.lecture.videoUrl);
          } else {
            MyDialog.instance.okShowDialog(
              context,
              "URL が変です！",
              Colors.red,
            );
          }
        },
      ),
    );
  }

  Future<Widget> _checkVideoSheet(
      BuildContext context, String _videoUrl) async {
    // ボトムシートを表示して動画の確認
    return await showModalBottomSheet(
      context: context,
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                color: Colors.green,
              ),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text("YouTube動画を確認",
                  textAlign: TextAlign.center,
                  style: cTextUpBarM,
                  textScaleFactor: 1),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              height: (MediaQuery.of(context).size.width - 20) / 2,
              child: LectureVideo(_videoUrl),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(right: 10, bottom: 10),
              alignment: Alignment.topRight,
              child: RaisedButton.icon(
                icon: Icon(FontAwesomeIcons.times, color: Colors.green),
                label: Text("閉じる", style: cTextListM, textScaleFactor: 1),
                color: Colors.white,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
