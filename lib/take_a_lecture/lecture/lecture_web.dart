import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/constants.dart';
import '../lecture/lecture_model.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LectureWeb extends StatefulWidget {
  @override
  _LectureWebState createState() => _LectureWebState();
}

class _LectureWebState extends State<LectureWeb> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.times),
          color: Colors.black,
          onPressed: () async {
            //最後に開いていたページのURLを保存
            model.webCurrentUrl = await _controller.currentUrl();
            Navigator.pop(context);
          },
        ),
        title: Text('YouTube画面を表示中', style: cTextTitleL, textScaleFactor: 1),
        actions: [
          _addFavorite(model),
          _goFavorite(model),
        ],
      ),
      body: WebView(
        initialUrl: model.webCurrentUrl.isEmpty
            ? 'https://youtube.com'
            : model.webCurrentUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }

  Widget _addFavorite(LectureModel model) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.folderPlus, color: Colors.green),
      tooltip: "このページを❤️に登録します",
      onPressed: () async {
        model.webFavoriteUrl = await _controller.currentUrl();
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: const Text("このページを ❤️に登録しました！"),
            duration: const Duration(milliseconds: 1500),
          ),
        );
        setState(() {});
      },
    );
  }

  Widget _goFavorite(LectureModel model) {
    return IconButton(
      icon: model.webFavoriteUrl.isNotEmpty
          ? Icon(FontAwesomeIcons.solidHeart, color: Colors.red)
          : Icon(FontAwesomeIcons.solidHeart, color: Colors.grey[200]),
      tooltip: "❤️に登録したページを表示します",
      onPressed: () {
        _controller.loadUrl(model.webFavoriteUrl);
      },
    );
  }
}
