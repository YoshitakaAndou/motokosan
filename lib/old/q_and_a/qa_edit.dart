import 'package:flutter/material.dart';
import 'package:motokosan/widgets/show_dialog.dart';
import 'package:provider/provider.dart';
import '../../data/constants.dart';
import 'qa_database_model.dart';
import 'qa_model.dart';

enum ImageUpType {
  CHANGE,
  DELETE,
  NON,
}

class QaEdit extends StatelessWidget {
  final QuesAns _question;
  final String qasId;
  QaEdit(this._question, this.qasId);

  @override
  Widget build(BuildContext context) {
    final qsTextController = TextEditingController();
    final ansTextController = TextEditingController();
    final descTextController = TextEditingController();
    qsTextController.text = _question.question;
    ansTextController.text = _question.answer;
    descTextController.text = _question.description;

    var _selectedValue = _question.category;
    var _selectData = [
      CATEGORY01,
      CATEGORY02,
      CATEGORY03,
      CATEGORY04,
      CATEGORY05
    ];
    final _database = QaDatabaseModel();
    return Consumer<QaModel>(builder: (context, model, child) {
      //todo edit_question
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Q & A の編集",
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
                    model.data.question = qsTextController.text;
                    model.data.answer = ansTextController.text;
                    model.data.description = descTextController.text;
                    try {
                      model.startLoading();
                      await model.updateQaAtFsCloud(qasId, _question.qaId);
                      await model.fetchQasFsCloud(qasId);
                      await _database.updateQaAtQId(model.datesFb);
                      model.setDatesDb(await _database.getQas());
                      model.stopLoading();
                      await MyDialog.instance.okShowDialog(context, "更新しました");
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
                    children: [
                      Row(
                        children: [
                          Text(
                            "項目名「${model.data.category}」",
                            style: cTextListM,
                            textScaleFactor: 1,
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.expand_more),
                            initialValue: _selectedValue,
                            onSelected: (String _category) {
                              model.setUpdate();
                              model.setCategory(_category);
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
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            labelText: "Question:",
                            labelStyle: TextStyle(fontSize: 10),
                            hintText: "Question を入力してください",
                            hintStyle: TextStyle(fontSize: 10)),
                        controller: qsTextController,
                        onChanged: (text) {
                          model.changeValue("question", text);
                          model.setUpdate();
                        },
                      ),
                      TextField(
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            labelText: "Answer:",
                            labelStyle: TextStyle(fontSize: 10),
                            hintText: "Answer を入力してください",
                            hintStyle: TextStyle(fontSize: 12)),
                        controller: ansTextController,
                        onChanged: (text) {
                          model.changeValue("answer", text);
                          model.setUpdate();
                        },
                      ),
                      TextField(
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            labelText: "Description:",
                            labelStyle: TextStyle(fontSize: 10),
                            hintText: "Description を入力してください",
                            hintStyle: TextStyle(fontSize: 12)),
                        controller: descTextController,
                        onChanged: (text) {
                          model.changeValue("description", text);
                          model.setUpdate();
                        },
                      ),
                      SizedBox(height: 10),

                      //todo 画像
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 60,
                        height: MediaQuery.of(context).size.height / 3,
                        child: InkWell(
                          onTap: () async {
                            //todo カメラロールを開く
                            await model.showImagePicker();
                            //todo イメージの取得状況でupdateフラグを設定
                            if (_question.imageUrl.isNotEmpty) {
                              if (model.imageFile == null) {
                                if (model.imageUpType == ImageUpType.CHANGE) {
                                  print(model.imageUpType);
                                  print("②");
                                  model.setUpdate();
                                  model.setImageUpType(ImageUpType.DELETE);
                                }
                              } else {
                                //todo imageFile.not.null
                                if (model.imageUpType == ImageUpType.CHANGE) {
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
                            // if (_question.imageUrl.isNotEmpty) {
                            //   if (model.imageFile == null) {
                            //     if(model.imageUpType==ImageUpType.CHANGE){
                            //
                            //     }
                            //     print(model.imageUpType);
                            //     print("②");
                            //     model.setUpdate();
                            //     model.setImageUpType(ImageUpType.DELETE);
                            //   } else {
                            //     //todo imageFile.not.null
                            //     if (model.imageUpType == ImageUpType.CHANGE) {
                            //       print("③");
                            //       model.setUpdate();
                            //     } else {
                            //       //todo model.imageUpType == ImageUpType.NON
                            //       print("①");
                            //       model.resetUpdate();
                            //     }
                            //   }
                            // } else {
                            //   //todo _question.imageUrl.isEmpty
                            //   if (model.imageFile == null) {
                            //     print("⑤");
                            //     model.resetUpdate();
                            //   } else {
                            //     print("④");
                            //     model.setUpdate();
                            //   }
                            //   //todo ImagePicker canceled
                            //
                            // }
                          },
                          child: model.imageFile != null
                              ? Image.file(model.imageFile)
                              : (model.data.imageUrl.isNotEmpty &&
                                      model.imageUpType != ImageUpType.DELETE)
                                  ? Image.network(model.data.imageUrl)
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
                      ),
                      Text(
                        "${model.data.imageUrl.isEmpty ? "なし" : model.data.imageUrl}",
                        style: cTextListSS,
                        textScaleFactor: 1,
                      ),
                      Divider(
                        height: 5,
                        color: Colors.grey,
                        thickness: 1,
                      ),

                      //todo ゴミ箱
                      if (model.imageFile != null ||
                          model.data.imageUrl.isNotEmpty &&
                              model.imageUpType != ImageUpType.DELETE)
                        Container(
                          width: double.infinity,
                          child: IconButton(
                            icon: Icon(Icons.delete,
                                size: 30, color: Colors.black54),
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              model.setImageFileNull();
                              if (_question.imageUrl.isNotEmpty) {
                                print("delete:②");
                                model.setImageUpType(ImageUpType.DELETE);
                                model.setUpdate();
                              } else {
                                print("delete:⑤");
                                model.setImageUpType(ImageUpType.NON);
                                model.resetUpdate();
                              }
                            },
                          ),
                        ),
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
}
