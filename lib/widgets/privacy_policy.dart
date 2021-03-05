import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/widgets/custom_button.dart';

class PrivacyPolicy extends StatefulWidget {
  final double radius;
  final String mdFileName;
  final Function buttonTap;

  PrivacyPolicy({
    this.radius = 8,
    @required this.mdFileName,
    this.buttonTap,
  });

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  ScrollController _scrollController;
  bool _isBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double positionRate =
        _scrollController.offset / _scrollController.position.maxScrollExtent;
    // 最後までスクロールさせたら「閉じる」ボタンを表示させる！
    if (positionRate >= 1.0) {
      setState(() {
        _isBottom = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.radius),
                topRight: Radius.circular(widget.radius),
              ),
              color: Colors.green,
            ),
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "アプリケーション・プライバシーポリシー",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textScaleFactor: 1,
                ),
                Text(
                  '〜上にスクロールさせて最後までお読みください〜',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textScaleFactor: 1,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                return rootBundle.loadString('assets/md/${widget.mdFileName}');
              }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Scrollbar(
                    child: Markdown(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      data: snapshot.data,
                      controller: _scrollController,
                      styleSheet: MarkdownStyleSheet(
                        h6: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                        h6Align: WrapAlignment.end,
                        p: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                        tableHead: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700),
                        tableBody: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          if (_isBottom || _size.height > 1000)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.radius),
                  bottomRight: Radius.circular(widget.radius),
                ),
                color: Colors.green,
              ),
              alignment: Alignment.center,
              height: 40,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    context: context,
                    title: '同意する',
                    icon: FontAwesomeIcons.circle,
                    iconSize: 15,
                    onPress: () => widget.buttonTap(true),
                  ),
                  CustomButton(
                    context: context,
                    title: '同意しない',
                    icon: FontAwesomeIcons.times,
                    iconSize: 15,
                    onPress: () => widget.buttonTap(false),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
