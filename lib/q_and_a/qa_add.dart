import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/ok_show_dialog.dart';
import 'qa_database_model.dart';
import '../constants.dart';
import 'qa_model.dart';

class QaAdd extends StatelessWidget {
  final String qasId;
  QaAdd(this.qasId);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<QaModel>(context, listen: false);
    final _database = QaDatabaseModel();
    var _selectedValue = model.data.category;
    var _selectData = [
      CATEGORY01,
      CATEGORY02,
      CATEGORY03,
      CATEGORY04,
      CATEGORY05
    ];

    return Consumer<QaModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Q&Aの新規登録",
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
                onPressed: () async {
                  DateTime _timeStamp = DateTime.now();
                  model.data.qaId = _timeStamp.toString(); //questionId
                  try {
                    model.startLoading();
                    await model.addQaToFsCloud(qasId, _timeStamp);
                    await model.fetchQasFsCloud(qasId);
                    await _database.insertQa(model.data);
                    await _database.updateQaAtQId(model.datesFb);
                    model.setDatesDb(await _database.getQas());
                    model.setDates(await _database.getQas());
                    model.stopLoading();
                    await MyDialog.instance.okShowDialog(context, "登録完了しました");
                    Navigator.pop(context);
                  } catch (e) {
                    MyDialog.instance.okShowDialog(context, e.toString());
                    model.stopLoading();
                  }
                },
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
                      TextField(
                        maxLines: null,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            labelText: "Question:",
                            labelStyle: TextStyle(fontSize: 10),
                            hintText: "Question を入力してください",
                            hintStyle: TextStyle(fontSize: 12)),
                        onChanged: (text) {
                          model.changeValue("question", text);
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
                        onChanged: (text) {
                          model.changeValue("answer", text);
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
                        onChanged: (text) {
                          model.changeValue("description", text);
                        },
                      ),
                      SizedBox(height: 10),
                      SizedBox(
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
                      ),
                      Divider(height: 5, color: Colors.grey, thickness: 1),
                      if (model.imageFile != null)
                        Container(
                          width: double.infinity,
                          child: IconButton(
                            icon: Icon(Icons.delete,
                                size: 30, color: Colors.black54),
                            alignment: Alignment.centerRight,
                            onPressed: () {
                              model.setImageFileNull();
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
