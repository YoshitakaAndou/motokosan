import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/datasave_widget.dart';
import 'package:provider/provider.dart';
import 'lecture_video.dart';
import '../../organizer/organizer_model.dart';
import '../../workshop/workshop_model.dart';
import '../../../widgets/ok_show_dialog.dart';
import '../../../constants.dart';
import '../lecture_model.dart';
import 'lecture_web.dart';

class LectureAdd extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  final Workshop _workshop;
  LectureAdd(this.groupName, this._organizer, this._workshop);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    final titleTextController = TextEditingController();
    final subTitleTextController = TextEditingController();
    final videoUrlTextController = TextEditingController();
    final descriptionTextController = TextEditingController();
    titleTextController.text = model.lecture.title;
    subTitleTextController.text = model.lecture.subTitle;
    videoUrlTextController.text = model.lecture.videoUrl;
    descriptionTextController.text = model.lecture.description;
    model.lecture.lectureNo =
        (model.lectures.length + 1).toString().padLeft(4, "0");
    return Consumer<LectureModel>(builder: (context, model, child) {
      model.isEditing = _checkValue(model);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: cToolBarH,
          centerTitle: true,
          title: Text("講義の新規登録", style: cTextTitleL, textScaleFactor: 1),
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.times),
            color: Colors.black87,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            _webButton(
              model,
              context,
              titleTextController,
              videoUrlTextController,
              descriptionTextController,
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                _infoArea(model),
                Container(
                  height: MediaQuery.of(context).size.height - cEditOffsetH,
                  width: MediaQuery.of(context).size.width - cEditOffsetW,
                  // padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(model, titleTextController),
                        _subTitle(model, subTitleTextController),
                        _videoUrl(model, videoUrlTextController, context),
                        if (model.lecture.videoUrl.isNotEmpty &&
                            model.isVideoPlay)
                          _videoButton(
                            model,
                            context,
                            titleTextController,
                            videoUrlTextController,
                            descriptionTextController,
                          ),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        SizedBox(height: 5),
                        _gridSlide(model, context),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        _description(model, descriptionTextController),
                        _testTile(context, model),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
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
          child: model.isEditing
              ? _saveButton(context, model)
              : _closeButton(context, model),
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
              child: Text("　番号：${model.lecture.lectureNo}",
                  style: cTextUpBarL, textScaleFactor: 1),
            ),
            Expanded(
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

  Widget _title(
    LectureModel model,
    _titleTextController,
  ) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _titleTextController,
      decoration: InputDecoration(
        labelText: "講義名:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "講義名 を入力してください（必須）",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _titleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("title", text);
      },
      onSubmitted: (text) {
        model.changeValue("title", text);
      },
    );
  }

  Widget _subTitle(
    LectureModel model,
    _subTitleTextController,
  ) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      controller: _subTitleTextController,
      decoration: InputDecoration(
        labelText: "subTitle:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "subTitle を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _subTitleTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      onChanged: (text) {
        model.changeValue("subTitle", text);
      },
      onSubmitted: (text) {
        model.changeValue("subTitle", text);
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
        labelText: "YouTubeURL:",
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
      onChanged: (text) {
        model.changeValue("videoUrl", text);
      },
      onSubmitted: (text) {
        if (model.isVideoUrl(text)) {
          model.changeValue("videoUrl", text);
        } else {
          okShowDialog(context, "YouTubeのURLを\n入力してください！");
          // _videoUrlTextController.text = "";
          // model.changeValue("videoUrl", "");
        }
      },
    );
  }

  Widget _webButton(
    LectureModel model,
    context,
    titleTextController,
    videoUrlTextController,
    descriptionTextController,
  ) {
    // webBookmarkUrlの読み込み
    Future(() async {
      await DataSave.getString("_bookmark").then((value) {
        model.webBookmarkUrl = value ?? "";
      });
    });
    return Container(
      height: 20,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.youtube, color: Colors.red, size: 20),
        label: Text("Webを表示", style: cTextListM, textScaleFactor: 1),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
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
            descriptionTextController.text = model.lecture.description;
            model.setVideoPlay(true);
          }
        },
      ),
    );
  }

  Widget _videoButton(
    LectureModel model,
    context,
    titleTextController,
    videoUrlTextController,
    descriptionTextController,
  ) {
    final _imageUrl = model.lecture.thumbnailUrl ?? "";
    return Container(
      width: double.infinity,
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
                      child: Text(
                        "${model.lecture.videoDuration}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                width: 60,
                height: 50,
                child:
                    Image.asset("assets/images/noImage.png", fit: BoxFit.cover),
              ),
        label: Text("動画を確認", style: cTextListM, textScaleFactor: 1),
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onPressed: () async {
          await _checkVideo(context, model.lecture.videoUrl);
        },
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
    if (model.slides.length == 0) {
      model.slides.add(Slide(slideImage: null));
    }
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
      },
      onLongPress: () {
        model.slideRemoveAt(_index);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.orange,
          child: _slide.slideImage == null
              ? Icon(FontAwesomeIcons.plus, color: Colors.white)
              : Image.file(_slide.slideImage, fit: BoxFit.cover),
        ),
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

  Widget _description(LectureModel model, _descriptionTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: "説明:",
        labelStyle: TextStyle(fontSize: 10),
        hintText: "説明 を入力してください",
        hintStyle: TextStyle(fontSize: 12),
        suffixIcon: IconButton(
          onPressed: () {
            _descriptionTextController.text = "";
          },
          icon: Icon(Icons.clear, size: 15),
        ),
      ),
      controller: _descriptionTextController,
      onChanged: (text) {
        model.changeValue("description", text);
      },
      onSubmitted: (text) {
        model.changeValue("description", text);
      },
    );
  }

  bool _checkValue(LectureModel model) {
    bool _result = false;
    _result = model.lecture.title.isNotEmpty ? true : _result;
    _result = model.lecture.subTitle.isNotEmpty ? true : _result;
    _result = model.lecture.description.isNotEmpty ? true : _result;
    _result = model.lecture.videoUrl.isNotEmpty ? true : _result;
    _result = model.lecture.thumbnailUrl.isNotEmpty ? true : _result;
    _result = model.slides.length > 1 ? true : _result;
    return _result;
  }

  Widget _saveButton(BuildContext context, LectureModel model) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: RaisedButton.icon(
              icon: Icon(FontAwesomeIcons.solidSave, color: Colors.green),
              label: Text("登録する", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () => _addProcess(context, model),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context, LectureModel model) {
    return Container(
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
              label: Text("やめる", style: cTextListM, textScaleFactor: 1),
              color: Colors.white,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _testTile(BuildContext context, LectureModel model) {
    return Column(
      children: [
        Divider(height: 5, color: Colors.grey, thickness: 1),
        _testTitle(context, model),
        _testAllAnswers(context, model),
        SizedBox(height: 10),
        _testPassingScore(context, model),
      ],
    );
  }

  Widget _testTitle(BuildContext context, LectureModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "■　確認テスト",
            style: cTextListM,
            textScaleFactor: 1,
          ),
          Text(
            "${model.lecture.questionLength}問",
            style: cTextListM,
            textScaleFactor: 1,
          ),
        ],
      ),
    );
  }

  Widget _testAllAnswers(BuildContext context, LectureModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cPopWindow),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(5),
              ),
              color: cPopWindow,
            ),
            child: Center(
                child:
                    Text("  受講完了の条件は？", style: cTextPopM, textScaleFactor: 1)),
          ),
          RadioListTile(
            title: Text('全問解答が必要', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: "true",
            groupValue: model.lecture.allAnswers,
            onChanged: (value) {
              model.setAllAnswers(value);
              model.setIsEditing();
            },
          ),
          RadioListTile(
            title: Text('全問解答は不要', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: "false",
            groupValue: model.lecture.allAnswers,
            onChanged: (value) {
              model.setAllAnswers(value);
              model.setIsEditing();
            },
          ),
        ],
      ),
    );
  }

  Widget _testPassingScore(BuildContext context, LectureModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: cPopWindow),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
                color: cPopWindow,
              ),
              child: Center(
                child: Text("  確認テストの合格条件は？",
                    style: cTextPopM, textScaleFactor: 1),
              )),
          RadioListTile(
            title: Text('全問正解で合格', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 100,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setIsEditing();
            },
          ),
          RadioListTile(
            title: Text('60点以上が合格', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 60,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setIsEditing();
            },
          ),
          RadioListTile(
            title: Text('特に合格点数は設けない', style: cTextListM, textScaleFactor: 1),
            activeColor: Colors.black45,
            value: 0,
            groupValue: model.lecture.passingScore,
            onChanged: (value) {
              model.setPassingScore(value);
              model.setIsEditing();
            },
          ),
        ],
      ),
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
