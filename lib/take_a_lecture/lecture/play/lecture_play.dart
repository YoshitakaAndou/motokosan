import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/play/bottomsheet_play_items.dart';
import 'package:motokosan/take_a_lecture/organizer/organizer_class.dart';
import 'package:motokosan/take_a_lecture/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import '../../../constants.dart';
import '../lecture_class.dart';
import '../../../widgets/bar_title.dart';
import '../../../widgets/go_back.dart';

class LecturePlay extends StatefulWidget {
  final UserData _userData;
  final Organizer _organizer;
  final WorkshopList _workshopList;
  final LectureList _lectureList;
  final List<Slide> _slides;
  final bool _isLast;

  LecturePlay(
    this._userData,
    this._organizer,
    this._workshopList,
    this._lectureList,
    this._slides,
    this._isLast,
  );

  @override
  _LecturePlayState createState() => _LecturePlayState();
}

class _LecturePlayState extends State<LecturePlay> {
  final ScrollController _homeController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  LectureResult _lectureResult = LectureResult();
  // 状態設定
  bool isHelp = false;
  bool isSlideButton = true;
  bool isSlide = false;
  bool isVideoStop = false;
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    print(widget._organizer.title);
    if (widget._lectureList.lecture.videoUrl.isNotEmpty) {
      startVideo(widget._lectureList.lecture.videoUrl, true);
    }
  }

  void startVideo(String _videoUrl, bool _autoPlay) {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(_videoUrl),
      flags: YoutubePlayerFlags(
        autoPlay: _autoPlay,
        startAt: 0,
        endAt: videoEndAt,
        hideControls: true,
        hideThumbnail: true,
        mute: false,
        loop: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<LectureModel>(context, listen: false);
    //サイズ
    final Size _size = MediaQuery.of(context).size;
    final _upHeight = _size.width / 1.42; //1.42
    final _bottomHeight = _size.height - _upHeight - 100;
    //向き
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    //スマホの向きを一時的に上固定から横も可能にする
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      key: _scaffoldState,
      appBar: isPortrait
          // 縦向きの時
          ? AppBar(
              toolbarHeight: cToolBarH,
              centerTitle: true,
              title: barTitle(context),
              leading: GoBack.instance.goBackWithReturArg(
                context: context,
                icon: Icon(FontAwesomeIcons.undo),
                returnArgument: ReturnArgument(isNextQuestion: false),
                num: 1,
              ),
              actions: [
                widget._isLast
                    ? Container()
                    : GoBack.instance.goBackWithReturArg(
                        context: context,
                        icon: Icon(FontAwesomeIcons.chevronRight),
                        returnArgument: ReturnArgument(isNextQuestion: true),
                        num: 1,
                      ),
              ],
            )
          // 横向きの時
          : PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colors.white.withOpacity(0.0),
                elevation: 0.0,
              ),
            ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 縦向きの時の動画画面
              if (isPortrait)
                Container(
                  width: _size.width,
                  height: _size.width * 0.7,
                  color: Colors.grey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _infoArea(),
                      SizedBox(height: 2),
                      if (widget._lectureList.lecture.videoUrl.isNotEmpty)
                        _videoTile(isPortrait),
                    ],
                  ),
                ),
              // 横向きの時の動画画面
              if (!isPortrait)
                Container(
                  width: _size.width,
                  height: _size.height,
                  color: Colors.black,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget._lectureList.lecture.videoUrl.isNotEmpty)
                        _videoTile(isPortrait),
                    ],
                  ),
                ),
              // 縦向きの時の残り画面
              if (isPortrait)
                Container(
                  width: _size.width,
                  height: _bottomHeight,
                  child: SingleChildScrollView(
                    controller: _homeController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget._slides.length > 0 && isSlideButton)
                          _slideButton(),
                        if (widget._slides.length > 0 && isSlide)
                          _gridView(context, _size),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        _descriptionTile(),
                        Divider(height: 5, color: Colors.grey, thickness: 1),
                        // _nextButton(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: cInfoAreaH,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget._workshopList.workshop.title,
                    style: cTextUpBarS, textScaleFactor: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("主催者：", style: cTextUpBarSS, textScaleFactor: 1),
                    Text(widget._workshopList.organizerName,
                        style: cTextUpBarSS, textScaleFactor: 1),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "${widget._lectureList.lecture.title}（${widget._lectureList.lecture.videoDuration}）",
                    style: cTextUpBarM,
                    textScaleFactor: 1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.3),
                  child: Text(
                    widget._lectureList.lectureResult.isTaken == "受講済"
                        ? "受講済"
                        : widget._lectureList.lecture.allAnswers == "全問解答が必要"
                            ? "テスト解答必須"
                            : "",
                    style: cTextUpBarS,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoTile(bool _isPortrait) {
    final Size _size = MediaQuery.of(context).size;
    return Expanded(
      child: Stack(
        children: [
          YoutubePlayer(
            width: _size.width,
            controller: _controller,
            // 動画の最後まで再生したら
            onEnded: (data) async {
              _controller.pause();
              // 画面の向き固定を元に戻す
              SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp],
              );
              // 講義を見た証をDBに登録
              _lectureResult.lectureId = widget._lectureList.lecture.lectureId;
              _lectureResult.isTaken = "終了";
              _lectureResult.isTakenAt =
                  ConvertItems.instance.dateToInt(DateTime.now());
              // ボトムシートを表示して次の動作を選択してもらう
              await _showModalBottomSheetPlay(context);
            },
          ),
          if (_isPortrait)
            GestureDetector(
              onTap: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  isVideoStop = true;
                } else {
                  _controller.play();
                  isVideoStop = false;
                }
                setState(() {});
              },
              child: Container(
                width: _size.width,
                height: _size.width / 1.42,
                color: Colors.transparent,
                // FullScreenボタンを隠してみる
                // alignment: Alignment.bottomRight,
                // child: Container(
                //   width: _size.width / 8,
                //   height: _size.height / 15,
                //   color: Colors.red.withOpacity(0),
                // ),
                child: isVideoStop ? _videoStop() : Container(),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  isVideoStop = true;
                } else {
                  _controller.play();
                  isVideoStop = false;
                }
                setState(() {});
              },
              child: Container(
                width: _size.width,
                height: _size.height,
                color: Colors.transparent,
                // FullScreenボタンを隠してみる
                // alignment: Alignment.bottomRight,
                // child: Container(
                //   width: 50,
                //   height: 100,
                //   color: Colors.red.withOpacity(0),
                // ),
                child: isVideoStop ? _videoStop() : Container(),
              ),
            )
        ],
      ),
    );
  }

  Widget _videoStop() {
    final _videoDuration =
        _controller.value.position.toString().substring(0, 7);
    return Container(
      color: Colors.black87.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.playCircle, color: Colors.white, size: 50),
          SizedBox(height: 20),
          Text(
            "$_videoDuration",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ],
      ),
    );
  }

  // int _stringToSeconds(String _data) {
  //   // h:mm:ssを秒に変換
  //   int _h = int.parse(_data.substring(0, 1));
  //   int _m = int.parse(_data.substring(2, 4));
  //   int _s = int.parse(_data.substring(5, 7));
  //   return _h * 60 * 60 + _m * 60 + _s;
  // }

  Widget _slideButton() {
    return RaisedButton(
      child: Text("スライドを表示"),
      color: Colors.white,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      onPressed: () {
        setState(() {
          isSlide = true;
          isSlideButton = false;
        });
      },
    );
  }

  Widget _gridView(context, Size _size) {
    return Container(
      width: _size.width,
      height: _size.width / 1.4,
      // color: Colors.grey,
      // padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 5),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 1,
          childAspectRatio: 0.7,
        ),
        itemCount: widget._slides.length,
        itemBuilder: (context, index) {
          return _gridTile(widget._slides[index], index);
        },
      ),
    );
  }

  Widget _gridTile(Slide _slide, int _index) {
    return GestureDetector(
      // onLongPress: onLongPress,
      onTap: () {
        setState(() {
          isSlide = false;
          isSlideButton = true;
        });
      },
      child: Container(
        // color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        child: Image.network(_slide.slideUrl),
      ),
    );
  }

  Widget _descriptionTile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("【解説】", textScaleFactor: 1, style: cTextListL),
          Text("${widget._lectureList.lecture.description}",
              textScaleFactor: 1, style: cTextListL),
        ],
      ),
    );
  }

  Future<Widget> _showModalBottomSheetPlay(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isDismissible: false,
      elevation: 15,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
      ),
      builder: (BuildContext context) {
        return BottomSheetPlayItems(widget._userData, widget._lectureList,
            widget._isLast, _lectureResult);
      },
    );
  }
}