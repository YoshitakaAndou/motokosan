import 'package:flutter/material.dart';
import 'package:motokosan/widgets/bar_title.dart';
import 'package:motokosan/widgets/bubble/bubble.dart';
import 'package:motokosan/widgets/go_back.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'qa_database_model.dart';
import 'qa_model.dart';
import 'qa_play.dart';

class QaList extends StatelessWidget {
  final String qasId;
  QaList({this.qasId});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QaModel>(context, listen: false);
    final _database = QaDatabaseModel();
    String dropdownValue = 'すべてを表示';
    Future(() async {
      model.setDatesSg(await _database.getQas());
    });
    return Consumer<QaModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: barTitle(context),
          centerTitle: true,
          leading: GoBack.instance
              .goBack(context: context, icon: Icon(Icons.home), num: 1),
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
                      "assets/images/nurse_anz.png",
                      width: 60,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fitWidth,
                    )
                  : Icon(Icons.close),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Column(
          children: [
            _infoArea(model, _database, dropdownValue),
            if (model.isHelp) _helpTile(),
            model.datesSg.length < 1
                ? Container()
                : _listTile(context, model, _database, dropdownValue)
          ],
        ),
      );
    });
  }

  Widget _infoArea(QaModel model, QaDatabaseModel _database, dropdownValue) {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child:
                    Text("放射線安全 Q & A", style: cTextUpBarL, textScaleFactor: 1),
              )),
          Expanded(
            flex: 5,
            child: _dropDownList(
              dropdownValue: dropdownValue,
              onChanged: (String newValue) async {
                dropdownValue = newValue;
                _dropdownCheck(model, _database, dropdownValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpTile() {
    return Container(
      height: 50,
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
                " 右上のリストから表示する項目を選んでください。"
                "\n下のリストをTapすると Q&A を表示します。",
                style: TextStyle(fontSize: 10),
                textScaleFactor: 1,
              ),
            ),
          ),
          SizedBox(width: 10),
          Image.asset(
            "assets/images/nurse02.png",
            width: 45,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _dropDownList({dropdownValue, Function onChanged}) {
    return Container(
      width: double.infinity,
      color: cContBg,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 10),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 20,
                elevation: 20,
                style: cTextUpBarM,
                dropdownColor: Colors.green[700],
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                onChanged: (String newValue) => onChanged(newValue),
                items: <String>[
                  "すべてを表示",
                  CATEGORY01,
                  CATEGORY02,
                  CATEGORY03,
                  CATEGORY04,
                  CATEGORY05,
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listTile(BuildContext context, QaModel model,
      QaDatabaseModel _database, dropdownValue) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        height: model.isHelp
            ? MediaQuery.of(context).size.height - 200
            : MediaQuery.of(context).size.height - 170,
        child: ListView.builder(
            itemCount: model.datesSg.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 15,
                child: ListTile(
                  dense: true,
                  title: Text(
                    "${model.datesSg[index].question}？",
                    textScaleFactor: 1,
                    style: cTextListL,
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      "Q",
                      textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () async {
                    model.resetUpdate();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QaPlay(
                                  datesQa: model.datesSg,
                                  index: index,
                                )));
                    _dropdownCheck(model, _database, dropdownValue);
                  },
                ),
              );
            }),
      ),
    );
  }

  Future<void> _dropdownCheck(
      QaModel model, QaDatabaseModel _database, String _dropdownValue) async {
    if (_dropdownValue == "すべてを表示") {
      model.setDatesSg(await _database.getSortedQa());
    }
    if (_dropdownValue == CATEGORY01) {
      model.setDatesSg(await _database.getWhereQasCategory(CATEGORY01));
    }
    if (_dropdownValue == CATEGORY02) {
      model.setDatesSg(await _database.getWhereQasCategory(CATEGORY02));
    }
    if (_dropdownValue == CATEGORY03) {
      model.setDatesSg(await _database.getWhereQasCategory(CATEGORY03));
    }
    if (_dropdownValue == CATEGORY04) {
      model.setDatesSg(await _database.getWhereQasCategory(CATEGORY04));
    }
    if (_dropdownValue == CATEGORY05) {
      model.setDatesSg(await _database.getWhereQasCategory(CATEGORY05));
    }
  }
}
