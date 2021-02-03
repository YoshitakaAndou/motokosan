import 'package:flutter/material.dart';
import 'package:motokosan/widgets/bar_title.dart';

class BoardItem {
  final String title;
  final String subtitle;
  final Widget widget;
  final String image;
  final Color color;
  final Color buttonColor;
  final Color lButtonColor;
  final Color rButtonColor;

  BoardItem({
    this.title,
    this.subtitle,
    this.widget,
    this.image,
    this.color,
    this.buttonColor,
    this.lButtonColor,
    this.rButtonColor,
  });
}

class BordItems {
  static List<BoardItem> loadBoardItem() {
    List boardItems = <BoardItem>[
      BoardItem(
        title: '研修会を開きたいのですが？',
        subtitle: '少し前までは、みんなが集まって普通に開いていた研修会でしたが...',
        widget: Container(),
        image: 'assets/images/intro0.png',
        color: Colors.white,
        lButtonColor: Colors.transparent,
        rButtonColor: Colors.grey[100],
      ),
      BoardItem(
        title: 'コロナ禍ではどうしましょう？',
        subtitle: '密になるので、研修会を中止している場合も多いのでは？',
        widget: Container(),
        image: 'assets/images/intro1.png',
        lButtonColor: Colors.grey[100],
        rButtonColor: Colors.grey[100],
      ),
      BoardItem(
        title: 'スマホで研修会を開催できたら！',
        subtitle: '動画に撮った研修会へ、スマートフォンで参加できるアプリがあったら便利ですよね!',
        widget: Container(),
        image: 'assets/images/intro2.png',
        lButtonColor: Colors.grey[100],
        rButtonColor: Colors.grey[100],
      ),
      BoardItem(
        title: '資料も閲覧できて、テストで出席も確認できたら良いよね！',
        subtitle: '動画に出てくる資料の表示や確認問題、修了試験もスマホでやっちゃおうかな？',
        widget: Container(),
        image: 'assets/images/intro3.png',
        lButtonColor: Colors.grey[100],
        rButtonColor: Colors.grey[100],
      ),
      BoardItem(
        title: 'それを実現するアプリが　　　　',
        subtitle: '',
        widget: BarTitle.instance.introTitle(),
        image: 'assets/images/intro4.png',
        buttonColor: Colors.grey[400],
        lButtonColor: Colors.grey[100],
        rButtonColor: Colors.grey[400],
      ),
    ];
    return boardItems;
  }
}
