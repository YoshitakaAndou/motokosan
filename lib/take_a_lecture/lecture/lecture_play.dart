import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/take_a_lecture/lecture/bottomsheet_play_items.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_play_info.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_play_slides.dart';
import 'package:motokosan/widgets/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_items.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import 'lecture_class.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/go_back.dart';

class LecturePlay extends StatefulWidget {
  final UserData _userData;
  final WorkshopList _workshopList;
  final LectureList _lectureList;
  final List<Slide> _slides;
  final bool _isLast;

  LecturePlay(
    this._userData,
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

  // final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
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
    if (widget._lectureList.lecture.videoUrl.isNotEmpty) {
      startVideo(widget._lectureList.lecture.videoUrl, true);
    }
  }

  @override
  void dispose() {
    super.dispose();
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
        // enableCaption: false,
        // disableDragSeek: false,
        // mute: false,
        loop: false,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_controller.value.playerState == PlayerState.playing && !isVideoStop) {
      _controller.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    //向き
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    // スマホの向きを一時的に上固定から横も可能にする
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    return isPortrait ? _portrait(context) : _landscape(context);
  }

  Widget _portrait(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    print("height:${_size.height},width:${_size.width}");
    final _movieHeight = _size.width / 1.42; //1.42
    final _bottomHeight = _size.height - _movieHeight - cInfoAreaH - 40;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: cToolBarH,
        centerTitle: true,
        title: BarTitle.instance.barTitle(context),
        leading: GoBack.instance.goBackWithReturnArg(
          context: context,
          icon: Icon(FontAwesomeIcons.arrowLeft),
          returnArgument: ReturnArgument(isNextQuestion: false),
          num: 1,
        ),
        actions: [
          widget._isLast
              ? Container()
              : GoBack.instance.goBackWithReturnArg(
                  context: context,
                  icon: Icon(FontAwesomeIcons.chevronRight),
                  returnArgument: ReturnArgument(isNextQuestion: true),
                  num: 1,
                ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _size.width,
                height: _size.width * 0.7,
                color: Colors.grey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _infoArea(context),
                    SizedBox(height: 2),
                    if (widget._lectureList.lecture.videoUrl.isNotEmpty)
                      _videoTile(true, _size),
                  ],
                ),
              ),
              Container(
                width: _size.width,
                height: _bottomHeight,
                child: SingleChildScrollView(
                  controller: _homeController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      LecturePlaySlides(
                        slides: widget._slides,
                        size: _size,
                      ),
                      // if (widget._slides.length > 0 && isSlideButton)
                      //   _slideButton(),
                      // if (widget._slides.length > 0 && isSlide)
                      //   _gridView(context, _size),
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

  Widget _landscape(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      // key: _scaffoldState,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(0),
      //   child: AppBar(
      //     backgroundColor: Colors.white.withOpacity(0.0),
      //     elevation: 0.0,
      //   ),
      // ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _size.width,
                height: _size.height,
                color: Colors.black,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget._lectureList.lecture.videoUrl.isNotEmpty)
                      _videoTile(false, _size),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoArea(BuildContext context) {
    return GestureDetector(
      //タップすると講義の情報をダイアログに表示
      onTap: () async {
        if (_controller.value.isPlaying) {
          _controller.pause();
          isVideoStop = true;
          await LecturePlayInfo.instance.lecturePlayInfo(
              context, widget._workshopList, widget._lectureList);
          _controller.play();
          isVideoStop = false;
          setState(() {});
        } else {
          await LecturePlayInfo.instance.lecturePlayInfo(
              context, widget._workshopList, widget._lectureList);
          setState(() {});
        }
      },
      child: Container(
        width: double.infinity,
        height: cInfoAreaH,
        color: cContBg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget._lectureList.lecture.title,
                      style: cTextUpBarM,
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "再生時間（${widget._lectureList.lecture.videoDuration}）",
                          style: cTextUpBarM,
                          textScaleFactor: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.3),
                          child: Text(
                            widget._lectureList.lectureResult.isTaken == "受講済"
                                ? "受講済"
                                : widget._lectureList.lecture.allAnswers ==
                                        "全問解答が必要"
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
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/nurse_quiz.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _videoTile(bool _isPortrait, Size _size) {
    return Expanded(
      child: Stack(
        children: [
          YoutubePlayer(
            width: _size.width,
            controller: _controller,
            // 動画の最後まで再生したら
            onEnded: (data) async {
              isVideoStop = true;
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
      backgroundColor: cBSBack,
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
