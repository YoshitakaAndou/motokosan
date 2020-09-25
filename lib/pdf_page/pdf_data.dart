
class PageList {
  String title;
  int page;
  bool chapter;

  PageList({this.title, this.page, this.chapter = false});
}

class PdfData {
  List<PageList> _pageLists = [
    PageList(title: "放射線検査の概略", page: 6, chapter: true),
    PageList(title: "放射線検査が必要とされる場面", page: 6),
    PageList(title: "放射線科で行う検査の種類", page: 6),
    PageList(title: "単純エックス線検査", page: 7),
    PageList(title: "透視検査", page: 7),
    PageList(title: "X線検査を行う前に配慮すべき事項", page: 8),
    PageList(title: "CT検査", page: 9),
    PageList(title: "CT検査前に配慮すべき事項", page: 10),
    PageList(title: "MR検査", page: 11),
    PageList(title: "MR検査前に配慮すべき事項", page: 11),
    PageList(title: "ガドリニウム造影検査", page: 11),
    PageList(title: "放射線を利用した治療", page: 16, chapter: true),
    PageList(title: "放射線を用いた治療・検査が必要とされる場面", page: 16),
    PageList(title: "IVRの具体的な手順", page: 17),
    PageList(title: "IVRを行う前に配慮すべき事項", page: 17),
    PageList(title: "IVRの治療中と治療後の対応", page: 18),
    PageList(title: "放射線診療における医療安全", page: 23, chapter: true),
    PageList(title: "医療安全", page: 23),
    PageList(title: "代表的な放射線の医療事故", page: 23),
    PageList(title: "医療安全のための看護師の役割", page: 24),
    PageList(title: "具体的な安全管理の手法", page: 25),
    PageList(title: "植え込み型ペースメーカーとICD", page: 26),
    PageList(title: "ヨード造影剤の安全な使用", page: 27),
    PageList(title: "CT検査の今後の課題（看護師も参加した被ばく管理）", page: 28),
    PageList(title: "MR検査の安全対策", page: 30),
    PageList(title: "①電磁石対策", page: 31),
    PageList(title: "②ガドリニウム造影剤によるNSFの防止", page: 32),
    PageList(title: "皮膚障害", page: 35),
    PageList(title: "IVRの皮膚障害を回避するために", page: 36),
    PageList(title: "放射線の生物的な影響", page: 37, chapter: true),
    PageList(title: "放射線に関する基礎知識", page: 37),
    PageList(title: "放射線の領域で特別に用いる単位", page: 37),
    PageList(title: "放射線の種類", page: 38),
    PageList(title: "身の回りにある放射線", page: 38),
    PageList(title: "放射性物質の半減期", page: 39),
    PageList(title: "放射線の生体への影響", page: 40),
    PageList(title: "遺伝的影響", page: 41),
    PageList(title: "遺伝と発がんへの影響", page: 41),
    PageList(title: "妊婦の被ばくによる胎児への影響", page: 42),
    PageList(title: "細胞への影響", page: 42),
    PageList(title: "放射線診療従事者の放射線安全管理", page: 43, chapter: true),
    PageList(title: "①教育訓練", page: 43),
    PageList(title: "②特殊健康診断", page: 43),
    PageList(title: "③個人被ばく線量測定", page: 43),
    PageList(title: "④作業管理", page: 43),
    PageList(title: "⑤作業環境管理", page: 43),
    PageList(title: "患者さんとのコミュニケーション", page: 50, chapter: true),
    PageList(title: "放射線診療に対する不安の特徴", page: 50),
    PageList(title: "内部被ばく", page: 51),
    PageList(title: "放射線不安を持った患者さんへの対応", page: 51),
    PageList(title: "不安を作らないための日常必要な事柄", page: 53),
    PageList(title: "付録：原発事故災害", page: 56, chapter: true),
    PageList(title: "原発事故災害への対応", page: 56),
    PageList(title: "原発災害時の対応＝核医学診療の安全管理", page: 56),
    PageList(title: "大量被ばくした可能性がある患者さんへの対応", page: 56),
  ];
  List<PageList> get pageLists {
    return [..._pageLists];
  }
}
