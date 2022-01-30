class CatalogModel {
  static List<Item> items = [];

  //get Item
  Item getByPosition(int pos) => items[pos];
}

class Item {
  final String image;
  final String title;
  final String auth;
  final String rating;
  final String bookId;

  Item(this.image, this.title, this.auth, this.rating, this.bookId);
}
