class Category {
  int id;
  String categoryId;
  String categoryName;
  int categoryLength;
  int clearCount;
  bool isFinish;

  Category({
    this.id,
    this.categoryId,
    this.categoryName,
    this.categoryLength,
    this.clearCount,
    this.isFinish,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "categoryId": categoryId,
      "categoryName": categoryName,
      "categoryLength": categoryLength,
      "clearCount": clearCount,
      "isFinish": isFinish,
    };
  }
}
