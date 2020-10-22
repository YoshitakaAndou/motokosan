import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureVideo extends StatefulWidget {
  final String videoUrl;
  LectureVideo(this.videoUrl);

  @override
  _LectureVideoState createState() => _LectureVideoState();
}

class _LectureVideoState extends State<LectureVideo> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // if (widget.videoUrl.isNotEmpty) {
    startVideo(widget.videoUrl, true);
    // }
  }

  void startVideo(String _videoUrl, bool _autoPlay) {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_videoUrl),
        flags: YoutubePlayerFlags(
          autoPlay: _autoPlay,
          hideThumbnail: true,
          mute: false,
          loop: false,
        ));
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YoutubePlayer(
            controller: _controller,
            // 動画の最後まで再生したら
            onEnded: (data) async {
              _controller.pause();
              Navigator.of(context).pop();
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.centerRight,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
