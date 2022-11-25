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

// Create boardItemObject
class BoardItemObject {
  String? id;
  String? inBoard;
  String title;
  String? assignedTo;
  String? assignedBy;
  String? description;

  BoardItemObject({
    this.id = "",
    this.inBoard = "",
    this.title = "",
    this.assignedTo = "",
    this.assignedBy = "",
    this.description = "",
  });

  Map<String, dynamic> itemToJson() {
    return {
      'id': id,
      'title': title,
      'inBoard': inBoard,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'description': description,
    };
  }

  static BoardItemObject itemFromJson(Map<String, dynamic> json) =>
      BoardItemObject(
        id: json['id'],
        title: json['title'],
        inBoard: json['inBoard'],
        assignedTo: json['assignedTo'],
        assignedBy: json['assignedBy'],
        description: json['description'],
      );
}
