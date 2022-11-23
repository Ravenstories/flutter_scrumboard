class BoardListObject {
  late String title;
  late List<BoardItemObject> items;

  BoardListObject({required this.title, required this.items});
}

// Create boardItemObject
class BoardItemObject {
  String id;
  String title;
  String to;
  String from;
  String description;

  BoardItemObject({
    this.id = "",
    this.title = "",
    this.to = "",
    this.from = "",
    this.description = "",
  });
}
