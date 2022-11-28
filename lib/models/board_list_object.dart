import 'board_item_object.dart';

class BoardListObject {
  String? id;
  String title;
  num indexNumber;
  List<BoardItemObject>? items;

  BoardListObject(
      {this.id, required this.title, required this.indexNumber, this.items});

  Map<String, dynamic> listToJson() {
    return {
      'id': id,
      'indexNumber': indexNumber,
      'title': title,
    };
  }

  static BoardListObject listFromJson(Map<String, dynamic> json) =>
      BoardListObject(
        id: json['id'],
        title: json['title'],
        indexNumber: json['indexNumber'],
        items: json['items'],
      );
}
