import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/constants.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_model.dart';
import 'package:motokosan/take_a_lecture/lecture/play/drawer/drawer_item.dart';
import 'package:provider/provider.dart';

class LecturePlayDrawer extends StatefulWidget {
  final Size size;
  final Function pauseVideo;
  final Function playVideo;
  final Function saveLectureResult;
  final Function backLectureList;
  final Function backHome;
  final Function showInfo;

  LecturePlayDrawer({
    this.size,
    this.pauseVideo,
    this.playVideo,
    this.saveLectureResult,
    this.backLectureList,
    this.backHome,
    this.showInfo,
  });

  @override
  _LecturePlayDrawerState createState() => _LecturePlayDrawerState();
}

class _LecturePlayDrawerState extends State<LecturePlayDrawer> {
  // bool _isToolsShow = false;
  String _menuTitle = "メニュー";
  bool _isShowSubTitle = false;

  @override
  void initState() {
    widget.pauseVideo();
    widget.saveLectureResult();
    super.initState();
  }

  @override
  void dispose() {
    widget.playVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LectureModel>(builder: (context, model, child) {
      return SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
          child: SizedBox(
            width: widget.size.width >= 800
                ? widget.size.width * 0.5
                : widget.size.width * 0.8,
            child: Drawer(
              child: Column(
                children: [
                  _title(context),
                  SizedBox(
                    height: widget.size.height - 150,
                    child: ListView(
                      children: [
                        DrawerItem(
                          context: context,
                          textItem: _textItem01(),
                          imageItem: _imageItem01(),
                          child: Container(),
                          onTap: widget.backLectureList,
                        ),
                        DrawerItem(
                          context: context,
                          textItem: _textItem02(),
                          imageItem: _imageItem02(),
                          child: Container(),
                          onTap: widget.backHome,
                        ),
                        DrawerItem(
                          context: context,
                          textItem: _textItem03(),
                          imageItem: _imageItem03(),
                          child: Container(),
                          onTap: widget.showInfo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _title(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.green[600],
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Icon(
                FontAwesomeIcons.solidWindowClose,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(_menuTitle, style: cTextUpBarLL, textScaleFactor: 1),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Icon(
                _isShowSubTitle
                    ? FontAwesomeIcons.solidQuestionCircle
                    : FontAwesomeIcons.questionCircle,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                setState(() {
                  _isShowSubTitle = !_isShowSubTitle;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _textItem01() {
    return Text(
      "講義一覧に戻る",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      textScaleFactor: 1,
    );
  }

  Widget _imageItem01() {
    return Icon(
      FontAwesomeIcons.chalkboardTeacher,
      color: Colors.green[800],
    );
  }

  Widget _textItem02() {
    return Text(
      "ホームに戻る",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      textScaleFactor: 1,
    );
  }

  Widget _imageItem02() {
    return Icon(
      FontAwesomeIcons.home,
      color: Colors.green[800],
    );
  }

  Widget _textItem03() {
    return Text(
      "講義の情報を見る",
      style: TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      textScaleFactor: 1,
    );
  }

  Widget _imageItem03() {
    return Image.asset(
      "assets/images/nurse_quiz.png",
      fit: BoxFit.fitHeight,
    );
  }
}
