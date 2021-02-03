import 'package:flutter/material.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/constants.dart';
import 'lec_database_model.dart';
import 'lec_model.dart';

class LecAdd extends StatelessWidget {
  final String lecsId;
  LecAdd(this.lecsId);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LecModel>(context);
    final _database = LecDatabaseModel();
    List<Lec> _datesCategory;
    var _selectedValue = model.data.category;
    var _selectData = [
      CATEGORY01,
      CATEGORY02,
      CATEGORY03,
      CATEGORY04,
      CATEGORY05
    ];
    Future(() async {
      _datesCategory =
          await _database.getWhereLecsCategory(model.data.category);
      model.setLecNo(
          "${_selectData.indexWhere((element) => element == model.data.category)}"
          "-${_datesCategory.length.toString().padLeft(4, "0")}");
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "講義の新規登録",
          style: cTextTitleL,
          textScaleFactor: 1,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () => _addProcess(context, model, _database),
              child: Text(
                "登録する",
                style: cTextListM,
                textScaleFactor: 1,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 50,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width - 28,
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _categoryNumber(model),
                    Row(
                      children: [
                        _categoryName(model),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.expand_more),
                          initialValue: _selectedValue,
                          onSelected: (String _category) async {
                            model.setCategory(_category);
                            _datesCategory =
                                await _database.getWhereLecsCategory(_category);
                            model.setLecNo(
                                "${_selectData.indexWhere((element) => element == _category)}"
                                "-${_datesCategory.length.toString().padLeft(4, "0")}");
                          },
                          itemBuilder: (BuildContext context) {
                            return _selectData.map((String _category) {
                              return PopupMenuItem(
                                child: Text(
                                  _category,
                                  textScaleFactor: 1,
                                ),
                                value: _category,
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                    _subCategory(model),
                    _title(model),
                    _video(model),
                    _videoButton(model),
                    if (model.showVideo) _videoPlay(model),
                    SizedBox(height: 10),
                    _slide(context, model),
                    if (model.imageFile != null) _slideTrash(model),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _description(model),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _correctQuestion(model),
                    _correctAnswer(model),
                    Divider(height: 5, color: Colors.grey, thickness: 1),
                    _incorrectQuestion(model),
                    _incorrectAnswer(model),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if (model.isLoading)
            Container(
                color: Colors.grey.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  Future<void> _addProcess(
      BuildContext context, LecModel model, LecDatabaseModel _database) async {
    DateTime _timeStamp = DateTime.now();
    model.data.lecId = _timeStamp.toString(); //questionId
    try {
      model.startLoading();
      await model.addQaToFsCloud(lecsId, _timeStamp);
      await model.fetchLecsFsCloud(lecsId);
      await _database.insertLec(model.data);
      await _database.updateLecAtLecId(model.datesFb);
      model.setDatesDb(await _database.getLecs());
      // model.setDates(await _database.getLecs());
      model.stopLoading();
      await MyDialog.instance.okShowDialog(context, "登録完了しました");
      Navigator.pop(context);
    } catch (e) {
      MyDialog.instance.okShowDialog(context, e.toString());
      model.stopLoading();
    }
  }

  Widget _categoryNumber(LecModel model) {
    return Text("${model.data.lecNo}");
  }

  Widget _categoryName(LecModel model) {
    return Text(
      "項目名「${model.data.category}」",
      style: cTextListM,
      textScaleFactor: 1,
    );
  }

  Widget _subCategory(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Subcategory:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Subcategory を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("subcategory", text);
      },
    );
  }

  Widget _title(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Title:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Title を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("lecTitle", text);
      },
    );
  }

  Widget _video(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "VideoURL:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "動画URL を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("videoUrl", text);
      },
    );
  }

  Widget _videoButton(LecModel model) {
    return RaisedButton(
      child: Text(model.videoButtonTitle),
      color: Colors.white,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      onPressed: () {
        if (model.showVideo) {
          model.videoButtonTitle = "動画を確認";
          model.isShowVideo(false);
        } else {
          model.videoButtonTitle = "隠す";
          model.isShowVideo(true);
        }
      },
    );
  }

  Widget _videoPlay(LecModel model) {
    final _videoUrl = model.data.videoUrl;
    YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(_videoUrl),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ));
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          child: SingleChildScrollView(
            child: YoutubePlayer(
              controller: _controller,
            ),
          ),
        ),
      ],
    );
  }

  Widget _slide(BuildContext context, LecModel model) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.height / 3,
      child: InkWell(
        onTap: () async {
          //todo カメラロールを開く
          await model.showImagePicker();
        },
        child: model.imageFile != null
            ? Image.file(model.imageFile)
            : Stack(
                children: [
                  Container(color: Colors.grey),
                  Center(
                    child: Icon(Icons.photo_library,
                        color: Colors.white, size: 40),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _slideTrash(LecModel model) {
    return Container(
      width: double.infinity,
      child: IconButton(
        icon: Icon(Icons.delete, size: 30, color: Colors.black54),
        alignment: Alignment.centerRight,
        onPressed: () {
          model.setImageFileNull();
        },
      ),
    );
  }

  Widget _description(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Description:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Description を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        model.changeValue("description", text);
      },
    );
  }

  Widget _correctQuestion(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "正答問題:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "正答問題 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        //todo
        model.changeValue("correctQuestion", text);
      },
    );
  }

  Widget _correctAnswer(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "正答解答:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "正答解答 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        //todo
        model.changeValue("correctAnswer", text);
      },
    );
  }

  Widget _incorrectQuestion(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "誤答問題:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "誤答問題 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        //todo
        model.changeValue("incorrectQuestion", text);
      },
    );
  }

  Widget _incorrectAnswer(LecModel model) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "誤答解答:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "誤答解答 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      onChanged: (text) {
        //todo
        model.changeValue("incorrectAnswer", text);
      },
    );
  }
}
