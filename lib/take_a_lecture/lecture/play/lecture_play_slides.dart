import 'package:flutter/material.dart';
import 'package:motokosan/take_a_lecture/lecture/lecture_class.dart';

class LecturePlaySlides extends StatefulWidget {
  final List<Slide> slides;
  final Size size;

  LecturePlaySlides({
    this.slides,
    this.size,
  });

  @override
  _LecturePlaySlidesState createState() => _LecturePlaySlidesState();
}

class _LecturePlaySlidesState extends State<LecturePlaySlides> {
  bool isSlide = false;
  bool isSlideButton = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (widget.slides.length > 0 && isSlideButton) _slideButton(),
          if (widget.slides.length > 0 && isSlide)
            _slideView(context, widget.size),
        ],
      ),
    );
  }

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

  Widget _slideView(context, Size _size) {
    return Container(
      width: _size.width,
      height: _size.width / 1.4,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          crossAxisCount: 1,
          childAspectRatio: 0.7,
        ),
        itemCount: widget.slides.length,
        itemBuilder: (context, index) {
          return _gridTile(widget.slides[index], index);
        },
      ),
    );
  }

  Widget _gridTile(Slide _slide, int _index) {
    return GestureDetector(
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
}
