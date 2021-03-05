import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/home/home.dart';
import 'package:motokosan/take_a_lecture/lecture/list/lecture_list_info.dart';
import 'package:motokosan/take_a_lecture/lecture/play/bottomsheet_play_items.dart';
import 'package:motokosan/take_a_lecture/lecture/play/drawer/lecture_play_drawer.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_play_info.dart';
import 'package:motokosan/take_a_lecture/lecture/play/lecture_play_slides.dart';
import 'package:motokosan/widgets/return_argument.dart';
import 'package:motokosan/take_a_lecture/workshop/workshop_class.dart';
import 'package:motokosan/data/user_data/userdata_class.dart';
import 'package:motokosan/widgets/convert_datetime.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';
import '../../../constants.dart';
import '../lecture_class.dart';
import '../../../widgets/bar_title.dart';
import '../../../widgets/go_back.dart';
import '../lecture_database.dart';

class LecturePlay extends StatefulWidget {
  final UserData userData;
  final WorkshopList workshopList;
  final LectureList lectureList;
  final List<Slide> slides;
  final bool isLast;
  final String routeName;

  LecturePlay(
    this.userData,
    this.workshopList,
    this.lectureList,
    this.slides,
    this.isLast,
    this.routeName,
  );

  @override
  _LecturePlayState createState() => _LecturePlayState();
}

class _LecturePlayState extends State<LecturePlay> {
  final ScrollController _homeController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // LectureResultの初期化
  LectureResult _lectureResult = LectureResult();

  // 状態設定
  bool isHelp = false;
  bool isSlideButton = true;
  bool isSlide = false;
  bool isVideoStop = false;
  bool isStopTaped = false;
  String _videoDuration = "";
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.lectureList.lecture.videoUrl.isNotEmpty) {
      startVideo(widget.lectureList.lecture.videoUrl, true);
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
        startAt: ConvertDateTime.instance
            .stringTimeToInt(widget.lectureList.lectureResult.playBackTime),
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
    final _movieHeight = _size.width / 1.42; //1.42
    final _bottomHeight = _size.height - _movieHeight - cInfoAreaH - 40;

    pauseVideo() {
      if (_controller.value.isPlaying) {
        isVideoStop = true;
        _controller.pause();
      }
    }

    playVideo() {
      if (!isStopTaped) {
        isVideoStop = false;
        _controller.play();
      }
    }

    backLectureList() {
      Navigator.of(context).pop();
      Navigator.of(context).pop(ReturnArgument(isNextQuestion: false));
    }

    backHome() {
      Navigator.popUntil(context, ModalRoute.withName("/home"));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(userData: widget.userData),
        ),
      );
    }

    showInfo() {
      //タップすると研修会の情報をダイアログに表示
      LectureListInfo.instance.lectureListInfo(context, widget.workshopList);
    }

    void _openEndDrawer() {
      _scaffoldKey.currentState.openEndDrawer();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: cToolBarH,
        centerTitle: true,
        title: BarTitle.instance.barTitle(context),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.bars,
            size: 20,
            color: Colors.black54,
          ),
          onPressed: _openEndDrawer,
        ),
        actions: [
          widget.isLast
              ? Container()
              : GoBack.instance.goBackWithReturnArg(
                  context: context,
                  icon: Icon(FontAwesomeIcons.chevronRight),
                  returnArgument: ReturnArgument(isNextQuestion: true),
                  num: 1,
                ),
        ],
      ),

      // ドローワーだぞ！
      endDrawer: LecturePlayDrawer(
        size: _size,
        pauseVideo: pauseVideo,
        playVideo: playVideo,
        saveLectureResult: _saveLectureResult,
        backLectureList: backLectureList,
        backHome: backHome,
        showInfo: showInfo,
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
                    if (widget.lectureList.lecture.videoUrl.isNotEmpty)
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
                        slides: widget.slides,
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
                    if (widget.lectureList.lecture.videoUrl.isNotEmpty)
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
              context, widget.workshopList, widget.lectureList);
          _controller.play();
          isVideoStop = false;
          setState(() {});
        } else {
          await LecturePlayInfo.instance.lecturePlayInfo(
              context, widget.workshopList, widget.lectureList);
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
                // flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.lectureList.lecture.title,
                      style: cTextUpBarM,
                      textScaleFactor: 1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "再生時間（${widget.lectureList.lecture.videoDuration}）",
                          style: cTextUpBarM,
                          textScaleFactor: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.3),
                          child: Text(
                            widget.lectureList.lectureResult.isTaken == "受講済"
                                ? "受講済"
                                : widget.lectureList.lecture.allAnswers ==
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
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Image.asset(
              //         "assets/images/nurse_quiz.png",
              //         fit: BoxFit.fitHeight,
              //       ),
              //     ],
              //   ),
              // ),
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
              _videoDuration =
                  _controller.value.position.toString().substring(0, 7);
              // 画面の向き固定を元に戻す
              SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp],
              );
              // 講義を見た証をDBに登録
              _lectureResult.lectureId = widget.lectureList.lecture.lectureId;
              _lectureResult.isTaken = "終了";
              _lectureResult.isTakenAt =
                  ConvertDateTime.instance.dateToInt(DateTime.now());
              _lectureResult.isBrowsing = "閲覧済";
              _lectureResult.playBackTime = _videoDuration;
              // ボトムシートを表示して次の動作を選択してもらう
              await _showModalBottomSheetPlay(context);
            },
          ),
          // 縦
          if (_isPortrait)
            GestureDetector(
              onTap: () {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  isVideoStop = true;
                  isStopTaped = true;
                } else {
                  _controller.play();
                  isVideoStop = false;
                  isStopTaped = false;
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
          // 横
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
    _lectureResult.playBackTime =
        _controller.value.position.toString().substring(0, 7);
    _saveLectureResult();
    return Container(
      color: Colors.black87.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.playCircle, color: Colors.white, size: 50),
          SizedBox(height: 20),
          Text(
            "${_lectureResult.playBackTime}",
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
          Text("${widget.lectureList.lecture.description}",
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
        return BottomSheetPlayItems(
            widget.userData, widget.lectureList, widget.isLast, _lectureResult);
      },
    );
  }

  _saveLectureResult() async {
    final _playBackTime = _controller.value.position.toString().substring(0, 7);
    print("-------------- saveLectureResultPlaybackTime:$_playBackTime");
    widget.lectureList.lectureResult.lectureId =
        widget.lectureList.lecture.lectureId;
    widget.lectureList.lectureResult.isBrowsing = _lectureResult.isBrowsing;
    widget.lectureList.lectureResult.playBackTime = _playBackTime;
    await LectureDatabase.instance.saveValue(
      data: widget.lectureList.lectureResult,
      isUpDate: true,
    );
  }
}
