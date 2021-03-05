import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motokosan/data/data_save_body.dart';
import 'package:motokosan/widgets/custom_button.dart';
import 'package:motokosan/widgets/show_dialog.dart';

class HomePolicy extends StatefulWidget {
  final double radius;
  final String mdFileName;

  HomePolicy({
    this.radius = 8,
    @required this.mdFileName,
  });

  @override
  _HomePolicyState createState() => _HomePolicyState();
}

class _HomePolicyState extends State<HomePolicy> {
  ScrollController _scrollController;
  bool _isBottom = false;
  bool _policy;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    checkPolicy();
  }

  checkPolicy() async {
    DataSave.getBool("_policy").then((value) {
      setState(() {
        _policy = value ?? false;
      });
    });
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
                ),
                Text(
                  '〜最後までスクロールさせてお読みください〜',
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
          if (_isBottom)
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
                  if (_policy)
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.tools,
                        color: Colors.white,
                        size: 15,
                      ),
                      onPressed: () async {
                        await MyDialog.instance.okShowDialogFunc(
                          context: context,
                          mainTitle: 'ポリシー同意済みをリセットします',
                          subTitle: '実行しますか？',
                          onPressed: () async {
                            await DataSaveBody.instance.savePolicy(false);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  Spacer(),
                  CustomButton(
                    context: context,
                    title: '閉じる',
                    icon: FontAwesomeIcons.times,
                    iconSize: 15,
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    boderColor: Colors.white,
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
