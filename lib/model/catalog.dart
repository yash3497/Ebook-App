import 'dart:ffi';

class CatalogModel {
  static List<Item> items = [];
  late final num max;

  //get Item
  static Item getByPosition(int pos) => items[pos];

  //set max
  set maxValue(num value) {
    assert(value >= 0);
    max = value;
  }

  //get max
  num get maxValue => max;
}

class Item {
  final String image;
  final String title;
  final String auth;
  final String rating;
  final String bookId;
  final num progress;

  Item(this.image, this.title, this.auth, this.rating, this.bookId,
      this.progress);
}
