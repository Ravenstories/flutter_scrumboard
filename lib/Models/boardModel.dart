class BoardListObject {
  late String title;
  late List<BoardItemObject> items = [];

  BoardListObject({required this.title, required this.items});
}

// Create boardItemObject
class BoardItemObject {
  String id;
  String title;
  String assignedTo;
  String assignedBy;
  String description;

  BoardItemObject({
    this.id = "",
    this.title = "",
    this.assignedTo = "",
    this.assignedBy = "",
    this.description = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'description': description,
    };
  }
}
