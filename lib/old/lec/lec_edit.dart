import 'package:flutter/material.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../constants.dart';
import 'lec_database_model.dart';
import 'lec_model.dart';

enum SlideUpType {
  CHANGE,
  DELETE,
  NON,
}

class LecEdit extends StatelessWidget {
  final Lec _lecture;
  final String lecsId;
  LecEdit(this._lecture, this.lecsId);

  @override
  Widget build(BuildContext context) {
    final subcategoryTextController = TextEditingController();
    final titleTextController = TextEditingController();
    final videoUrlTextController = TextEditingController();
    final descTextController = TextEditingController();
    final correctQuesTextController = TextEditingController();
    final correctAnsTextController = TextEditingController();
    final incorrectQuesTextController = TextEditingController();
    final incorrectAnsTextController = TextEditingController();
    subcategoryTextController.text = _lecture.subcategory;
    titleTextController.text = _lecture.lecTitle;
    videoUrlTextController.text = _lecture.videoUrl;
    descTextController.text = _lecture.description;
    correctQuesTextController.text = _lecture.correctQuestion;
    correctAnsTextController.text = _lecture.correctAnswer;
    incorrectQuesTextController.text = _lecture.incorrectQuestion;
    incorrectAnsTextController.text = _lecture.incorrectAnswer;
    List<Lec> _datesCategory;
    var _selectedValue = _lecture.category;
    var _selectData = [
      CATEGORY01,
      CATEGORY02,
      CATEGORY03,
      CATEGORY04,
      CATEGORY05
    ];
    final _database = LecDatabaseModel();
    return Consumer<LecModel>(builder: (context, model, child) {
      //todo edit_question
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "講義の編集",
            style: cTextTitleL,
            textScaleFactor: 1,
          ),
          actions: [
            if (model.isUpdate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.green),
                  ),
                  onPressed: () async {
                    //todo 更新処理
                    model.data.subcategory = subcategoryTextController.text;
                    model.data.lecTitle = titleTextController.text;
                    model.data.videoUrl = videoUrlTextController.text;
                    model.data.description = descTextController.text;
                    model.data.correctQuestion = correctQuesTextController.text;
                    model.data.correctAnswer = correctAnsTextController.text;
                    model.data.incorrectQuestion =
                        incorrectQuesTextController.text;
                    model.data.incorrectAnswer =
                        incorrectAnsTextController.text;
                    try {
                      model.startLoading();
                      await model.updateLecAtFsCloud(lecsId, _lecture.lecId);
                      await model.fetchLecsFsCloud(lecsId);
                      await _database.updateLecAtLecId(model.datesFb);
                      model.setDatesDb(await _database.getLecs());
                      model.stopLoading();
                      await MyDialog.instance.okShowDialog(
                        context,
                        "更新しました",
                        Colors.black,
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                    }
                    model.resetUpdate();
                  },
                  child: Text(
                    "更新する",
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
                          _categoryNameSelection(
                            model: model,
                            database: _database,
                            datesCategory: _datesCategory,
                            selectedValue: _selectedValue,
                            selectData: _selectData,
                          ),
                        ],
                      ),
                      _subCategory(model, subcategoryTextController),
                      _title(model, titleTextController),
                      _video(model, videoUrlTextController),
                      _videoButton(model),
                      if (model.showVideo) _videoPlay(model),
                      SizedBox(height: 10),
                      _slide(context, model),
                      _slideUrl(model),
                      if (model.imageFile != null ||
                          model.data.slideUrl.isNotEmpty &&
                              model.slideUpType != SlideUpType.DELETE)
                        _slideTrash(model),
                      Divider(height: 5, color: Colors.grey, thickness: 1),
                      _description(model, descTextController),
                      Divider(height: 5, color: Colors.grey, thickness: 1),
                      _correctQuestion(model, correctQuesTextController),
                      _correctAnswer(model, correctAnsTextController),
                      Divider(height: 5, color: Colors.grey, thickness: 1),
                      _incorrectQuestion(model, incorrectQuesTextController),
                      _incorrectAnswer(model, incorrectAnsTextController),
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
    });
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

  Widget _categoryNameSelection(
      {LecModel model,
      LecDatabaseModel database,
      List<Lec> datesCategory,
      String selectedValue,
      List<String> selectData}) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.expand_more),
      initialValue: selectedValue,
      onSelected: (String _category) async {
        model.setCategory(_category);
        model.isUpdate = true;
        datesCategory = await database.getWhereLecsCategory(_category);
        model.setLecNo(
            "${selectData.indexWhere((element) => element == _category)}"
            "-${datesCategory.length.toString().padLeft(4, "0")}");
      },
      itemBuilder: (BuildContext context) {
        return selectData.map((String _category) {
          return PopupMenuItem(
            child: Text(
              _category,
              textScaleFactor: 1,
            ),
            value: _category,
          );
        }).toList();
      },
    );
  }

  Widget _subCategory(
      LecModel model, TextEditingController _subcategoryTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Subcategory:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Subcategory を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _subcategoryTextController,
      onChanged: (text) {
        model.changeValue("subcategory", text);
        model.setUpdate();
      },
    );
  }

  Widget _title(LecModel model, TextEditingController _titleTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Title:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Title を入力してください",
          hintStyle: TextStyle(fontSize: 10)),
      controller: _titleTextController,
      onChanged: (text) {
        model.changeValue("lecTitle", text);
        model.setUpdate();
      },
    );
  }

  Widget _video(LecModel model, TextEditingController _videoUrlTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "VideoURL:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "動画URL を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _videoUrlTextController,
      onChanged: (text) {
        model.changeValue("videoUrl", text);
        model.setUpdate();
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
          //todo イメージの取得状況でupdateフラグを設定
          if (_lecture.slideUrl.isNotEmpty) {
            if (model.imageFile == null) {
              if (model.slideUpType == SlideUpType.CHANGE) {
                print(model.slideUpType);
                print("②");
                model.setUpdate();
                model.setSlideUpType(SlideUpType.DELETE);
              }
            } else {
              //todo imageFile.not.null
              if (model.slideUpType == SlideUpType.CHANGE) {
                print("③");
                model.setUpdate();
              } else {
                //todo model.imageUpType == ImageUpType.NON
                print("①");
                model.resetUpdate();
              }
            }
          } else {
            //todo _question.imageUrl.isEmpty
            if (model.imageFile == null) {
              print("⑤");
              model.resetUpdate();
            } else {
              print("④");
              model.setUpdate();
            }
            //todo ImagePicker canceled

          }
        },
        child: model.imageFile != null
            ? Image.file(model.imageFile)
            : (model.data.slideUrl.isNotEmpty &&
                    model.slideUpType != SlideUpType.DELETE)
                ? Image.network(model.data.slideUrl)
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

  Widget _slideUrl(LecModel model) {
    return Text(
      "${model.data.slideUrl.isEmpty ? "なし" : model.data.slideUrl}",
      style: cTextListSS,
      textScaleFactor: 1,
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
          if (_lecture.slideUrl.isNotEmpty) {
            print("delete:②");
            model.setSlideUpType(SlideUpType.DELETE);
            model.setUpdate();
          } else {
            print("delete:⑤");
            model.setSlideUpType(SlideUpType.NON);
            model.resetUpdate();
          }
        },
      ),
    );
  }

  Widget _description(
      LecModel model, TextEditingController _descTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "Description:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "Description を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _descTextController,
      onChanged: (text) {
        model.changeValue("description", text);
        model.setUpdate();
      },
    );
  }

  Widget _correctQuestion(
      LecModel model, TextEditingController _correctQuesTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "正答問題:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "正答問題 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _correctQuesTextController,
      onChanged: (text) {
        model.changeValue("correctQuestion", text);
        model.setUpdate();
      },
    );
  }

  Widget _correctAnswer(
      LecModel model, TextEditingController _correctAnsTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "正答解答:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "正答解答 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _correctAnsTextController,
      onChanged: (text) {
        model.changeValue("correctAnswer", text);
        model.setUpdate();
      },
    );
  }

  Widget _incorrectQuestion(
      LecModel model, TextEditingController _incorrectQuesTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "誤答問題:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "誤答問題 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _incorrectQuesTextController,
      onChanged: (text) {
        model.changeValue("incorrectQuestion", text);
        model.setUpdate();
      },
    );
  }

  Widget _incorrectAnswer(
      LecModel model, TextEditingController _incorrectAnsTextController) {
    return TextField(
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
          labelText: "誤答解答:",
          labelStyle: TextStyle(fontSize: 10),
          hintText: "誤答解答 を入力してください",
          hintStyle: TextStyle(fontSize: 12)),
      controller: _incorrectAnsTextController,
      onChanged: (text) {
        model.changeValue("incorrectAnswer", text);
        model.setUpdate();
      },
    );
  }
}
