import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_web.dart';
import 'package:provider/provider.dart';
import '../lecture/lecture_model.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import '../../widgets/ok_show_dialog.dart';
import '../../constants.dart';
import 'lecture_video.dart';

class LectureEdit extends StatelessWidget {
  final String groupName;
  final Lecture _lecture;
  final Workshop _workshop;
  final Organizer _organizer;
  LectureEdit(this.groupName, this._lecture, this._workshop, this._organizer);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final descTextController = TextEditingController();
    final videoUrlTextController = TextEditingController();
    titleTextController.text = _lecture.title;
    subTitleTextController.text = _lecture.subTitle;
    descTextController.text = _lecture.description;
    videoUrlTextController.text = _lecture.videoUrl;
    model.isVideoPlay = _lecture.videoUrl.isNotEmpty ? true : false;

    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text("講義の編集", style: cTextTitleL, textScaleFactor: 1),
          leading: Container(),
          actions: [
            if (model.isUpdate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.green,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () async {
                    // グリグリを回す
                    model.startLoading();
                    // 更新処理（外だしは出来ません）
                    model.lecture.title = titleTextController.text;
                    model.lecture.subTitle = subTitleTextController.text;
                    model.lecture.description = descTextController.text;
                    model.lecture.videoUrl = videoUrlTextController.text;
                    model.lecture.lectureId = _lecture.lectureId;
                    model.lecture.lectureNo = _lecture.lectureNo;
                    model.lecture.createAt = _lecture.createAt;
                    model.lecture.updateAt = _lecture.updateAt;
                    model.lecture.targetId = _lecture.targetId;
                    model.lecture.organizerId = _lecture.organizerId;
                    model.lecture.workshopId = _lecture.workshopId;
                    model.lecture.slideLength = _lecture.slideLength;
                    try {
                      // 変更があったときだけSlideの処理を行う
                      if (model.isSlideUpdate) {
                        // model.slidesをstorageに登録してslideUrlを取得しつつ
                        // Group/三原赤十字病院/Lecture/lecId/Slide/0001.../に登録
                        await model.updateSlide(
                            groupName, model.lecture.lectureId);
                      }
                      // 入力チェック
                      model.inputCheck();
                      await model.updateLectureFs(groupName, DateTime.now());
                      await model.fetchLecture(groupName, _workshop.workshopId);
                      model.stopLoading();
                      await okShowDialog(context, "更新しました");
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                    }
                    model.resetUpdate();
                  },
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
                    // height: MediaQuery.of(context).size.height + 300,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _title(model, titleTextController),
                        _subTitle(model, subTitleTextController),
                        _videoUrl(model, videoUrlTextController, context),
                        _videoButton(model, context),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        SizedBox(height: 5),
                        _gridDescription(),
                        _gridView(model, context),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        _description(model, descTextController),
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
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
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
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 15,
          child: Icon(FontAwesomeIcons.trashAlt),
          // todo 削除
          onPressed: () {
            okShowDialogFunc(
              context: context,
              mainTitle: _lecture.title,
              subTitle: "削除しますか？",
              // delete
              onPressed: () async {
                Navigator.pop(context);
                await _deleteSave(
                  context,
                  model,
                  _lecture.lectureId,
                );
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    });
  }

  Future<void> _deleteSave(
      BuildContext context, LectureModel model, _lectureId) async {
    model.startLoading();
    try {
      //StorageのImageとFSのSlideを削除
      await model.deleteStorageImages(groupName, _lectureId);
      //FsをLectureIdで削除
      await model.deleteLectureFs(groupName, _lectureId);
      //配列を削除するのは無理だから再びFsをフェッチ
      await model.fetchLecture(groupName, _workshop.workshopId);
      //頭から順にlectureNoを振る
      int _count = 0;
      for (Lecture _data in model.lectures) {
        _data.lectureNo = _count.toString().padLeft(4, "0");
        //Fsにアップデート
        await model.setLectureFs(false, groupName, _data, DateTime.now());
        _count += 1;
      }
      //一通り終わったらFsから読み込んで再描画させる
      await model.fetchLecture(groupName, _workshop.workshopId);
    } catch (e) {
      okShowDialog(context, e.toString());
    }
    model.stopLoading();
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

  Widget _title(LectureModel model, _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "講義名:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "講義名 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _titleTextController,
      onChanged: (text) {
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
      decoration: const InputDecoration(
          labelText: "subTitle:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "subTitle を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _subTitleTextController,
      onChanged: (text) {
        model.changeValue("subTitle", text);
        model.setUpdate();
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
                if (model.isVideoUrl(model.lecture.videoUrl)) {
                  await _checkVideo(context, model.lecture.videoUrl);
                } else {
                  okShowDialog(context, "URL が変です！");
                }
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
  //
  // Future<Widget> _checkWeb(BuildContext context) async {
  //   // ボトムシートを表示して次の動作を選択してもらう
  //   return await showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     useRootNavigator: true,
  //     elevation: 15,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Container(
  //             width: double.infinity,
  //             height: 30,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
  //               color: Colors.green,
  //             ),
  //           ),
  //           // SizedBox(height: 10),
  //           Container(
  //             padding: EdgeInsets.all(5),
  //             width: MediaQuery.of(context).size.width,
  //             height: (MediaQuery.of(context).size.height - 180),
  //             child: LectureWeb(),
  //           ),
  //           // SizedBox(height: 10),
  //           Container(
  //             padding: EdgeInsets.only(right: 10, bottom: 10),
  //             alignment: Alignment.topRight,
  //             child: RaisedButton(
  //               child: Text("閉じる"),
  //               color: Colors.white,
  //               shape: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //               ),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
      child: Container(
        color: Colors.orange,
        child: _slide.slideImage != null
            ? Image.file(_slide.slideImage, fit: BoxFit.cover)
            : _slide.slideUrl.isNotEmpty
                ? Image.network(_slide.slideUrl, fit: BoxFit.cover)
                : Icon(FontAwesomeIcons.plus, color: Colors.white),
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

  Widget _description(LectureModel model, _descTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          labelText: "説明:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "説明 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _descTextController,
      onChanged: (text) {
        model.changeValue("description", text);
        model.setUpdate();
      },
    );
  }
}
