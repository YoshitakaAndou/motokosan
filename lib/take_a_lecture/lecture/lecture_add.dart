import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../lecture/lecture_video.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import 'lecture_model.dart';
import 'lecture_web.dart';

class LectureAdd extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  final Workshop _workshop;
  LectureAdd(this.groupName, this._organizer, this._workshop);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    final videoUrlTextController = TextEditingController();
    videoUrlTextController.text = model.lecture.videoUrl;
    model.lecture.lectureNo =
        (model.lectures.length + 1).toString().padLeft(4, "0");
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text("講義の新規登録", style: cTextTitleL, textScaleFactor: 1),
          leading: Container(),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                color: Colors.green,
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.white),
                ),
                onPressed: () => _addProcess(context, model),
                child: Text(
                  "登　録",
                  style: cTextUpBarL,
                  textScaleFactor: 1,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _infoArea(model),
                  Container(
                    width: MediaQuery.of(context).size.width - 28,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(model),
                        _subTitle(model),
                        _videoUrl(model, videoUrlTextController, context),
                        _videoButton(model, context),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        SizedBox(height: 5),
                        _gridDescription(),
                        _gridView(model, context),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        _description(model),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (model.isLoading)
              Container(
                  color: Colors.black87.withOpacity(0.8),
                  child: Center(child: CircularProgressIndicator())),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Container(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton.icon(
                    icon: Icon(FontAwesomeIcons.times, color: Colors.green),
                    label: Text("やめて戻る", style: cTextListM, textScaleFactor: 1),
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
            ),
          ),
        ),
      );
    });
  }

  Widget _infoArea(LectureModel model) {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text("　番号：${model.lecture.lectureNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("＞${_organizer.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                  Text("＞${_workshop.title}",
                      style: cTextUpBarS, textScaleFactor: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(LectureModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "講義名:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "講義名 を入力してください（必須）",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(LectureModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "subTitle:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "subTitle を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("subTitle", text);
      },
    );
  }

  Widget _videoUrl(LectureModel model, _videoUrlTextController, context) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "YouTubeURL:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "YouTube動画URL を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _videoUrlTextController,
      onChanged: (text) {
        if (model.isVideoUrl(text)) {
          model.changeValue("videoUrl", text);
        } else {
          okShowDialog(context, "YouTubeのURLを\n入力してください！");
          _videoUrlTextController.text = "";
        }
      },
    );
  }

  Widget _videoButton(LectureModel model, context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (model.lecture.videoUrl.isNotEmpty && model.isVideoPlay)
            RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.film, color: Colors.green),
              label: Text("動画を確認", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () async {
                await _checkVideo(context, model.lecture.videoUrl);
              },
            ),
          RaisedButton.icon(
            icon: Icon(FontAwesomeIcons.youtube, color: Colors.red),
            label: Text("Webを表示", style: cTextListM, textScaleFactor: 1),
            color: Colors.white,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            onPressed: () {
              // await _checkWeb(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LectureWeb(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<Widget> _checkVideo(BuildContext context, String _videoUrl) async {
    // ボトムシートを表示して次の動作を選択してもらう
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

  Widget _gridDescription() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey[600]),
        borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
        color: Colors.greenAccent.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(FontAwesomeIcons.images, color: Colors.black54),
          Text("  スライド登録： ", style: cTextListM, textScaleFactor: 1),
          Text(
            "+を押してスライドを登録してください。"
            "\nタイルを長押しして削除もできます。",
            style: cTextListS,
            textScaleFactor: 1,
          ),
        ],
      ),
    );
  }

  Widget _gridView(LectureModel model, context) {
    if (model.slides.length == 0) {
      model.slides.add(Slide(slideImage: null));
    }
    // グリッドリストの高さを調整するための数式（１段増えるごとに１行増やす）
    double a = (model.slides.length - 1) / 3;
    int b = a.toInt() + 1;
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: (MediaQuery.of(context).size.width) / 3 * b,
      color: Colors.greenAccent.withOpacity(0.2),
      padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
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
      },
      onLongPress: () {
        model.slideRemoveAt(_index);
      },
      child: Container(
        color: Colors.orange,
        child: _slide.slideImage == null
            ? Icon(FontAwesomeIcons.plus, color: Colors.white)
            : Image.file(_slide.slideImage, fit: BoxFit.cover),
      ),
    );
  }

  Future<void> _slideTileOnTap(
      LectureModel model, Slide _slide, int _index) async {
    final File _image = await model.selectImage(_slide.slideImage);
    if (_image != null) {
      if (_slide.slideImage == null) {
        model.slides.add(Slide());
      }
      model.setSlideImage(_index, _image);
    }
  }

  Widget _description(LectureModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "説明:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "説明 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("description", text);
      },
    );
  }

  Future<void> _addProcess(BuildContext context, LectureModel model) async {
    try {
      // グリグリを回す
      model.startLoading();
      // 入力チェック
      model.inputCheck();
      // lectureIdにタイムスタンプを設定
      DateTime _timeStamp = DateTime.now();
      model.lecture.lectureId = _timeStamp.toString();
      // model.slidesをstorageに登録してslideUrlを取得しつつ
      // Group/三原赤十字病院/Lecture/lecId/Slide/0.../に登録
      await model.addSlide(groupName, model.lecture.lectureId);
      // model.lectureをFBに登録
      await model.addLectureFs(groupName, _timeStamp);
      // グリグリを止める
      model.stopLoading();
      await okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }
}
