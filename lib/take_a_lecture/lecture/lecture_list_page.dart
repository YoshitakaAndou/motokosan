import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../organizer/organizer_model.dart';
import '../workshop/workshop_model.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/go_back.dart';
import '../../constants.dart';
import 'lecture_model.dart';
import 'lecture_play.dart';

class LectureListPage extends StatelessWidget {
  final String groupName;
  final Organizer _organizer;
  final WorkshopList _workshopList;
  LectureListPage(this.groupName, this._organizer, this._workshopList);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LectureModel>(context, listen: false);
    Future(() async {
      model.startLoading();
      await model.fetchLecture(groupName, _workshopList.workshopId);
      model.stopLoading();
    });
    return Consumer<LectureModel>(builder: (context, model, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: barTitle(context),
          leading: goBack(
              context: context,
              icon: Icon(FontAwesomeIcons.chevronLeft),
              num: 1),
          actions: [
            goBack(context: context, icon: Icon(FontAwesomeIcons.home), num: 3),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _infoArea(),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height - 175,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: model.lectures.length,
                      itemBuilder: (context, index) {
                        return Card(
                          key: Key(model.lectures[index].workshopId),
                          elevation: 15,
                          child: ListTile(
                            dense: true,
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${model.lectures[index].title}",
                                    style: cTextListL,
                                    textScaleFactor: 1,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Text(
                                "${model.lectures[index].subTitle}",
                                style: cTextListS,
                                textAlign: TextAlign.left,
                                textScaleFactor: 1,
                              ),
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 20,
                            ),
                            onTap: () async {
                              final _slides1 = await _preparationOfSlide(
                                model,
                                model.lectures[index].slideLength,
                                model.lectures[index].lectureId,
                              );
                              if (model.lectures[index].videoUrl.isNotEmpty) {
                                //スマホの向きを一時的に上固定から横も可能にする
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.portraitUp,
                                ]);
                                print("スマホの向きを横向きも可能にする");
                              }
                              // Trainingへ 終わったら値を受け取る
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LecturePlay(
                                    groupName,
                                    _organizer,
                                    _workshopList,
                                    model.lectures[index],
                                    _slides1,
                                  ),
                                ),
                              );
                              if (model.lectures[index].videoUrl.isNotEmpty) {
                                //スマホの向きを上のみに戻す
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                                print("スマホの向きを上むきのみに戻す");
                              }
                              int _index = index + 1;
                              // リストの最後まで来たら終わり
                              if (_index >= model.lectures.length) {
                                result = false;
                              }
                              while (result) {
                                final _slides = await _preparationOfSlide(
                                  model,
                                  model.lectures[_index].slideLength,
                                  model.lectures[_index].lectureId,
                                );
                                if (model.lectures[index].videoUrl.isNotEmpty) {
                                  //スマホの向きを一時的に上固定から横も可能にする
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.landscapeRight,
                                    DeviceOrientation.landscapeLeft,
                                    DeviceOrientation.portraitUp,
                                  ]);
                                  print("スマホの向きを横向きも可能にする");
                                }
                                result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LecturePlay(
                                      groupName,
                                      _organizer,
                                      _workshopList,
                                      model.lectures[_index],
                                      _slides,
                                    ),
                                  ),
                                );
                                if (model.lectures[index].videoUrl.isNotEmpty) {
                                  //スマホの向きを上のみに戻す
                                  SystemChrome.setPreferredOrientations([
                                    DeviceOrientation.portraitUp,
                                  ]);
                                  print("スマホの向きを上むきのみに戻す");
                                }
                                _index += 1;
                                // リストの最後まで来たら終わり
                                if (_index >= model.lectures.length) {
                                  result = false;
                                }
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height - 175,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black87.withOpacity(0.8),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          notchMargin: 6.0,
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Container(
            height: 45,
            padding: EdgeInsets.all(10),
            child: Text(
              "",
              style: cTextUpBarL,
              textScaleFactor: 1,
            ),
          ),
        ),
      );
    });
  }

  Widget _infoArea() {
    return Container(
      width: double.infinity,
      height: 50,
      color: cContBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" 講義一覧", style: cTextUpBarLL, textScaleFactor: 1),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("主催：", style: cTextUpBarM, textScaleFactor: 1),
                    Text(_workshopList.organizerName,
                        style: cTextUpBarM, textScaleFactor: 1),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("研修会：", style: cTextUpBarM, textScaleFactor: 1),
                    Text(_workshopList.title,
                        style: cTextUpBarM, textScaleFactor: 1),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<List<Slide>> _preparationOfSlide(
      model, _slideLength, _lectureId) async {
    List<Slide> _results = List();
    // スライドが登録されていたら準備をする
    if (_slideLength > 0) {
      _results = await model.fetchSlide(groupName, _lectureId);
    }
    return _results;
  }
}
