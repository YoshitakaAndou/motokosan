import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../widgets/bar_title.dart';
import '../widgets/go_back_one.dart';
import '../widgets/bubble/bubble.dart';
import 'lec_play.dart';
import 'lec_database_model.dart';
import 'lec_model.dart';
import '../constants.dart';

class LecPage extends StatefulWidget {
  final String lecsId;
  final String categoryName;
  final int clearCount;
  LecPage({this.lecsId, this.categoryName, this.clearCount});

  @override
  _LecPageState createState() => _LecPageState();
}

class _LecPageState extends State<LecPage> {
  bool _isText;
  int _clearCount;
  @override
  void initState() {
    _isText = false;
    _clearCount = widget.clearCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _database = LecDatabaseModel();
    return Consumer<LecModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: barTitle(context),
          leading:
              goBackOne(context: context, icon: Icon(Icons.arrow_back_ios)),
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
                      width: 65,
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
            _infoArea(context, model),
            if (model.isHelp) _helpTile(),
            model.datesSg.length < 1
                ? Container()
                : _listCard(context, model, _database, widget.categoryName),
          ],
        ),
      );
    });
  }

  Widget _infoArea(BuildContext context, LecModel model) {
    final double _percent =
        model.datesSg.length == 0 ? 0 : _clearCount / model.datesSg.length;
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("コース名：", style: cTextUpBarSS, textScaleFactor: 1),
                Text(widget.categoryName,
                    style: cTextUpBarL, textScaleFactor: 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5),
            child: Column(
              children: [
                Text("$_clearCount／${model.datesSg.length} クリア",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isText ? Colors.white : Colors.green,
                    ),
                    textScaleFactor: 1),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width / 3,
                    lineHeight: 10,
                    animation: true,
                    animationDuration: 500,
                    percent: _percent,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.red[700],
                    onAnimationEnd: () => _startPaint(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _startPaint() {
    _isText = true;
    setState(() {});
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
                " 「済」になっていないリストをTapしてみてください。"
                "\n受講し確認テストに合格するとで次の講義に進めます。",
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

  Widget _listCard(
      BuildContext context, LecModel model, _database, _categoryName) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        height: model.isHelp
            ? MediaQuery.of(context).size.height - 230
            : MediaQuery.of(context).size.height - 170,
        child: ListView.builder(
            itemCount: model.datesSg.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 15,
                child: ListTile(
                  dense: true,
                  title: Text(
                    "${model.datesSg[index].lecNo}/${model.datesSg[index].subcategory}",
                    textScaleFactor: 1,
                    style: cTextListS,
                  ),
                  subtitle: Text(
                    "${model.datesSg[index].lecTitle}",
                    textScaleFactor: 1,
                    style: cTextListL,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: model.datesSg[index].viewed == "済み"
                        ? Colors.red[700]
                        : Colors.green[700],
                    child: Text(
                      model.datesSg[index].viewed == "済み" ? "済" : "講",
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: Icon(Icons.play_circle_outline, size: 25),
                  onTap: () async {
                    model.resetUpdate();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LecPlay(
                                datesLec: model.datesSg, index: index)));
                    _clearCount = model.setLecAnswerCount(
                        _categoryName,
                        await model.getLecAnsweredCount(
                            _database, _categoryName, "○"));
                    await _getCategoryDates(model, _database, _categoryName);
                  },
                ),
              );
            }),
      ),
    );
  }

  Future<void> _getCategoryDates(
      LecModel model, LecDatabaseModel _database, String _categoryName) async {
    if (_categoryName == CATEGORY01) {
      model.setDatesSg(await _database.getWhereLecsCategory(CATEGORY01));
    }
    if (_categoryName == CATEGORY02) {
      model.setDatesSg(await _database.getWhereLecsCategory(CATEGORY02));
    }
    if (_categoryName == CATEGORY03) {
      model.setDatesSg(await _database.getWhereLecsCategory(CATEGORY03));
    }
    if (_categoryName == CATEGORY04) {
      model.setDatesSg(await _database.getWhereLecsCategory(CATEGORY04));
    }
    if (_categoryName == CATEGORY05) {
      model.setDatesSg(await _database.getWhereLecsCategory(CATEGORY05));
    }
  }
}
