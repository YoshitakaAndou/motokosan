import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/bubble/bubble.dart';
import '../widgets/go_back_one.dart';
import '../constants.dart';
import 'lec_category.dart';
import 'lec_database_model.dart';
import 'lec_model.dart';
import 'lec_page.dart';

class LecList extends StatefulWidget {
  final String lecsId;
  LecList({this.lecsId});

  @override
  _LecListState createState() => _LecListState();
}

class _LecListState extends State<LecList> {
  final _database = LecDatabaseModel();
  bool _isClear;
  // bool _isText;
  List<Category> categories = [
    Category(
      id: 1,
      categoryId: "01",
      categoryName: "医療被ばくの基本的考え方",
      categoryLength: 0,
      clearCount: 0,
      isFinish: false,
    ),
    Category(
      id: 2,
      categoryId: "02",
      categoryName: "放射線診療の正当化",
      categoryLength: 0,
      clearCount: 0,
      isFinish: false,
    ),
    Category(
      id: 3,
      categoryId: "03",
      categoryName: "放射線診療の防護の最適化",
      categoryLength: 0,
      clearCount: 0,
      isFinish: false,
    ),
    Category(
      id: 4,
      categoryId: "04",
      categoryName: "放射線障害が生じた場合の対応",
      categoryLength: 0,
      clearCount: 0,
      isFinish: false,
    ),
    Category(
      id: 5,
      categoryId: "05",
      categoryName: "患者への情報提供",
      categoryLength: 0,
      clearCount: 0,
      isFinish: false,
    ),
  ];

  @override
  void initState() {
    _isClear = false;
    _resetIsText();
    _setCategoryData(_database);
    super.initState();
  }

  void _resetIsText() {
    for (Category _data in categories) {
      _data.isFinish = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<LecModel>(context, listen: false);
    return Consumer<LecModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: barTitle(context),
          leading: goBackOne(context: context, icon: Icon(Icons.home)),
          actions: [
            GestureDetector(
              onTap: () {
                if (!model.isHelp) {
                  model.setIsHelp(true);
                } else {
                  model.setIsHelp(false);
                }
              },
              child: !model.isHelp
                  ? Image.asset(
                      "assets/images/nurse03.png",
                      width: 75,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                    )
                  : Icon(Icons.close, size: 35, color: Colors.black54),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Column(
          children: [
            _infoArea(),
            if (model.isHelp) _helpTile(),
            categories.length < 1
                ? Container()
                : SingleChildScrollView(
                    child: Container(
                      height: model.isHelp
                          ? MediaQuery.of(context).size.height - 210
                          : MediaQuery.of(context).size.height - 170,
                      child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return _listItem(
                              index: index,
                              title: categories[index].categoryName,
                              totalCount: categories[index].categoryLength,
                              clearCount: categories[index].clearCount,
                              onTap: () async {
                                if (categories[index].categoryLength > 0) {
                                  model.datesSg =
                                      await _database.getWhereLecsCategory(
                                          categories[index].categoryName);
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LecPage(
                                                lecsId: widget.lecsId,
                                                categoryName: categories[index]
                                                    .categoryName,
                                                clearCount: categories[index]
                                                    .clearCount,
                                              )));
                                  //todo 戻ってきたらデータを取得しなおしてもう一度回す
                                  await _setCategoryData(_database);
                                  setState(() {});
                                }
                              },
                            );
                          }),
                    ),
                  ),
          ],
        ),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child:
                Text("講義を受ける（コース一覧）", style: cTextUpBarL, textScaleFactor: 1),
          ),
        ],
      ),
    );
  }

  Widget _helpTile() {
    return Container(
      height: 80,
      width: double.infinity,
      color: cContBg,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(Icons.comment, color: Colors.black54, size: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Bubble(
              color: Color.fromRGBO(225, 255, 199, 1.0),
              nip: BubbleNip.rightBottom,
              nipWidth: 10,
              nipHeight: 5,
              child: Text(
                "【受講の流れ】"
                "\nコース別に、講義=>確認テスト合格=>次の講義"
                "\nと進み全部クリアして修了試験となります。"
                "\nコースをすべて合格するように頑張りましょう！",
                style: TextStyle(fontSize: 10),
                textScaleFactor: 1,
              ),
            ),
          ),
          SizedBox(width: 10),
          Image.asset(
            "assets/images/nurse02.png",
            width: 60,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _listItem({index, title, totalCount, clearCount, Function onTap}) {
    final double _percent = totalCount == 0 ? 0 : clearCount / totalCount;
    final String _percentString = (_percent * 100).toStringAsFixed(0);
    return Card(
      elevation: 15,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        leading: _leading(_percent),
        title: Text(title, style: cTextListL, textScaleFactor: 1),
        subtitle: Row(
          children: [
            Text("講義数：$totalCount件", style: cTextListS, textScaleFactor: 1),
            SizedBox(width: 20),
            Text("クリア：$clearCount件", style: cTextListS, textScaleFactor: 1),
          ],
        ),
        trailing: CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 5.0,
          percent: _percent,
          progressColor: Colors.redAccent,
          center: categories[index].isFinish
              ? Text("$_percentString%", style: cTextListS, textScaleFactor: 1)
              : Text(""),
          animationDuration: 500,
          animation: true,
          onAnimationEnd: () {
            _starPaint(index, _percent);
          },
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _leading(_percent) {
    if (_isClear && _percent == 1.0) {
      return Image.asset(
        "assets/images/nurse_ok2.png",
        width: 50,
        fit: BoxFit.fitWidth,
      );
    } else {
      return Container(width: 50, child: Icon(Icons.star, size: 30));
    }
  }

  _starPaint(int _index, double _percent) {
    if (_percent == 1.0) {
      _isClear = true;
    }
    if (_percent == 0) {
      categories[_index].isFinish = false;
    } else {
      categories[_index].isFinish = true;
    }
    setState(() {});
  }

  Future<void> _setCategoryData(LecDatabaseModel _database) async {
    for (Category _category in categories) {
      final _resultDates =
          await _database.getWhereLecsCategory(_category.categoryName);
      final _resultClears =
          await _database.getWhereCategoryAnswered(_category.categoryName, "○");
      _category.categoryLength = _resultDates.length;
      _category.clearCount = _resultClears.length;
    }
  }
}
