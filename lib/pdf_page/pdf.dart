import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import '../constants.dart';
import '../pdf_page/pdf_data.dart';
import '../widgets/go_back.dart';

class Pdf extends StatefulWidget {
  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  int _actualPageNumber = 1, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;
  final pdfData = PdfData();

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openAsset('assets/pdfs/radiation_nursing.pdf'),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '看護師のための放射線科入門',
          textScaleFactor: 1,
          style: cTextTitleL,
        ),
        leading: goBack(context: context, icon: Icon(Icons.home), num: 1),
      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _actualPageNumber = 1;
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.green,
              ),
              label: "後ろ",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.desktop_windows),
                label: "$_actualPageNumber/$_allPagesCount"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.green,
              ),
              label: "前へ",
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              _pdfController.previousPage(
                  curve: Curves.ease, duration: Duration(milliseconds: 100));
            }
            if (index == 1) {
              _showIndexSheet(context);
            }
            if (index == 2) {
              _pdfController.nextPage(
                  curve: Curves.ease, duration: Duration(milliseconds: 100));
            }
          },
          currentIndex: 1,
        ),
      ),
    );
  }

  Future<Widget> _showIndexSheet(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Container(
              height: 30,
              width: double.infinity,
              color: cContBg,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "ページ目次",
                    textScaleFactor: 1,
                    style: cTextUpBarL,
                  ),
                  Icon(Icons.comment, size: 10),
                  Text(
                    "Tapするとそのページにジャンプします",
                    textScaleFactor: 1,
                    style: cTextUpBarM,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2 - 20,
                child: ListView.builder(
                    itemCount: pdfData.pageLists.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                            padding: EdgeInsets.only(
                                left: pdfData.pageLists[index].chapter ? 0 : 20,
                                top: 5,
                                bottom: 5),
                            child: Text(
                              "${pdfData.pageLists[index].title}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )),
                        onTap: () {
                          setState(() {
                            _actualPageNumber = pdfData.pageLists[index].page;
                            _pdfController.jumpToPage(_actualPageNumber);
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    }),
              ),
            ),
          ],
        );
//        return Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            SizedBox(
//              width: 80,
//            ),
//            NumberPicker.integer(
//                initialValue: _actualPageNumber,
//                minValue: 1,
//                maxValue: _allPagesCount,
//                onChanged: (newValue) {
//                  setState(() {
//                    _actualPageNumber = newValue;
//                    _pdfController.jumpToPage(_actualPageNumber);
//                  });
//                }),
//            Container(
//              width: 80,
//              child: RaisedButton(
//                child: Text("OK"),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            )
//          ],
//        );
//
      },
    );
  }
}
