import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/data/constants.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/make/lecture/lecture_youtube_api.dart';
import 'package:motokosan/widgets/guriguri.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../take_a_lecture/lecture/lecture_model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LectureWeb extends StatefulWidget {
  @override
  _LectureWebState createState() => _LectureWebState();
}

class _LectureWebState extends State<LectureWeb> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;
  // saveString()のmodel.webBookmarkUrlへの読み込みは親Widgetで行う
  @override
  Widget build(BuildContext context) {
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.times),
            color: Colors.black,
            onPressed: () async {
              //最後に開いていたページのURLを保存
              model.webLastUrl = await _controller.currentUrl();
              Navigator.pop(context, false);
            },
          ),
          title: Text('YouTube画面を表示中', style: cTextTitleL, textScaleFactor: 1),
          actions: [
            _bookmark(model),
            SizedBox(width: 10),
            // _addFavorite(model),
            // _goFavorite(model),
          ],
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: model.lecture.videoUrl.isNotEmpty
                  ? model.lecture.videoUrl
                  : model.webBookmarkUrl.isNotEmpty
                      ? model.webBookmarkUrl
                      : model.webLastUrl.isNotEmpty
                          ? model.webLastUrl
                          : 'https://youtube.com',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) async {
                _controller = controller;
              },
            ),
            if (model.isLoading) GuriGuri.instance.guriguri2(context),
          ],
        ),
        floatingActionButton: floatingButton(model),
      );
    });
  }

  Widget floatingButton(LectureModel model) {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      child: FloatingActionButton(
        elevation: 15,
        child: Icon(FontAwesomeIcons.fileDownload),
        onPressed: () async {
          model.startLoading();
          // APIを使って表示動画の情報を取得
          final _url = await _controller.currentUrl();
          final videoId = YoutubePlayer.convertUrlToId(_url);
          if (videoId == null) {
            MyDialog.instance.okShowDialog(context, "動画ページではありません");
          } else {
            final _videoSnippet =
                await APIService.instance.fetchVideoSnippet(videoId: videoId);
            final _videoContentDetails = await APIService.instance
                .fetchVideoContentDetails(videoId: videoId);
            model.video = _videoSnippet;
            model.video.duration =
                VideoDuration().toHMS(_videoContentDetails.duration);
            model.video.url = _url;
            // ModalBottomSheetに表示
            _getDataBottomSheet(model);
          }
          model.stopLoading();
        },
      ),
    );
  }

  Future<Widget> _getDataBottomSheet(LectureModel model) async {
    model.initFlag(true);
    return await showModalBottomSheet(
      context: context,
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return Consumer<LectureModel>(builder: (context, model, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetTitle(),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    _youtubeId(model),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _title(model),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _description(model),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    SizedBox(height: 10),
                    _getButton(model),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _sheetTitle() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
        color: Colors.green,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.youtube, color: Colors.white),
          SizedBox(width: 20),
          Text("動画の情報です", style: cTextUpBarL, textScaleFactor: 1),
        ],
      ),
    );
  }

  Widget _youtubeId(LectureModel model) {
    return CheckboxListTile(
      activeColor: Colors.green,
      title: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.network(model.video.thumbnailUrl),
          ),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 5),
                      child: Icon(FontAwesomeIcons.youtube, size: 15),
                    ),
                    Text(' ${model.video.id}',
                        style: cTextListM, textScaleFactor: 1),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 5),
                      child: Icon(FontAwesomeIcons.solidClock, size: 15),
                    ),
                    Text(' ${model.video.duration}',
                        style: cTextListM, textScaleFactor: 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: model.isFlag0,
      onChanged: (bool value) {
        model.setFlag0(value);
      },
    );
  }

  Widget _title(LectureModel model) {
    return CheckboxListTile(
      activeColor: Colors.green,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("講義：", style: cTextListSS, textScaleFactor: 1),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('${model.video.title}',
                style: cTextListM, textScaleFactor: 1, maxLines: 2),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: model.isFlag1,
      onChanged: (bool value) {
        model.setFlag1(value);
      },
    );
  }

  Widget _description(LectureModel model) {
    return CheckboxListTile(
      activeColor: Colors.green,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("説明：", style: cTextListSS, textScaleFactor: 1),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('${model.video.description}',
                style: cTextListM, textScaleFactor: 1, maxLines: 3),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: model.isFlag2,
      onChanged: (bool value) {
        model.setFlag2(value);
      },
    );
  }

  Widget _getButton(LectureModel model) {
    return Container(
      padding: EdgeInsets.only(right: 10, bottom: 10),
      alignment: Alignment.topRight,
      child: RaisedButton.icon(
        icon: Icon(FontAwesomeIcons.clipboardCheck, color: Colors.green),
        label: Text("取り込む", style: cTextListM, textScaleFactor: 1),
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onPressed: () async {
          //最後に開いていたページのURLを保存
          model.setWebLastUrl(await _controller.currentUrl());
          Navigator.pop(context);
          // 保存のチェックを確認して閉じる
          Navigator.pop(context, model.videoSetLecture());
        },
      ),
    );
  }

  Widget _bookmark(LectureModel model) {
    return InkWell(
      onTap: () async {
        final _currentUrl = await _controller.currentUrl();
        if (model.webBookmarkUrl.isEmpty ||
            model.webBookmarkUrl != _currentUrl) {
          model.webBookmarkUrl = _currentUrl;
          // todo bookMarkを本体に保存
          DataSave.saveString("_bookmark", model.webBookmarkUrl);
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("このページをブックマーク️に登録しました！", textScaleFactor: 1),
              duration: Duration(milliseconds: 1500),
            ),
          );
        } else {
          model.webBookmarkUrl = "";
          // todo 本体に保存したbookmarkを削除
          DataSave.saveString("_bookmark", model.webBookmarkUrl);
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("ブックマークを削除しました",
                  textScaleFactor: 1, textAlign: TextAlign.center),
              duration: Duration(milliseconds: 1500),
            ),
          );
        }
        setState(() {});
      },
      // onTap: () {
      //   if (model.webBookmarkUrl.isNotEmpty) {
      //     _controller.loadUrl(model.webBookmarkUrl);
      //   }
      // },
      child: model.webBookmarkUrl.isNotEmpty
          ? Icon(
              FontAwesomeIcons.solidBookmark,
              color: Colors.red,
              size: 25,
            )
          : Icon(
              FontAwesomeIcons.bookmark,
              color: Colors.grey[200],
              size: 25,
            ),
    );
  }
}
