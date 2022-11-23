import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_scrumboard/models/boardModel.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../shared/shared.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => BoardPageView();
}

class BoardPageView extends State<BoardPage> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerAssignedTo = TextEditingController();
  final controllerAssignedBy = TextEditingController();

  final List<BoardListObject> _listData = [
    BoardListObject(
      title: 'To Do',
      items: [
        BoardItemObject(
          id: '1',
          title: 'Create a new Flutter project',
          assignedTo: 'To Do',
          assignedBy: 'In Progress',
          description: 'Create a new Flutter project',
        ),
        BoardItemObject(
          id: '2',
          title: 'Create a new Flutter project',
          assignedTo: 'To Do',
          assignedBy: 'In Progress',
          description: 'Create a new Flutter project',
        ),
      ],
    ),
    BoardListObject(title: 'In Progress', items: [
      BoardItemObject(
        id: '9',
        title: 'Create a new Flutter project',
        assignedTo: 'In Progress',
        assignedBy: 'To Do',
        description: 'Create a new Flutter project',
      ),
      BoardItemObject(
        id: '10',
        title: 'Create a new Flutter project',
        assignedBy: 'In Progress',
        assignedTo: 'To Do',
        description: 'Create a new Flutter project',
      )
    ])
  ];
  final BoardViewController boardViewController = BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> list = <BoardList>[];

    for (int i = 0; i < _listData.length; i++) {
      list.add(createBoardList(_listData[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("BoardView Example"),
      ),
      drawer: const NavigationDrawer(),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: BoardView(
                lists: list, boardViewController: boardViewController)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createItem(context),
        tooltip: 'Add Item to Board',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  createBoardList(BoardListObject listObject) {
    List<BoardItem> items = [];

    for (int i = 0; i < listObject.items.length; i++) {
      items.insert(i, buildBoardItem(listObject.items[i]));
    }

    return BoardList(
      onStartDragList: (index) {},
      onTapList: (listIndex) async {},
      onDropList: (oldListIndex, listIndex) {
        var list = _listData[oldListIndex!];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex!, list);
      },
      headerBackgroundColor: Colors.transparent,
      backgroundColor: const Color(0xFFE5E5E5),
      header: <Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              listObject.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
      items: items,
    );
  }

  buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
      onStartDragItem: (listIndex, itemIndex, state) => {},
      onDropItem: (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
        var item = _listData[oldListIndex!].items[oldItemIndex!];
        _listData[oldListIndex].items.removeAt(oldItemIndex);
        _listData[listIndex!].items.insert(itemIndex!, item);
      },
      onTapItem: (listIndex, itemIndex, state) async {},
      item: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  itemObject.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  itemObject.description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createItem(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Create Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: controllerTitle,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  )),
              TextField(
                  controller: controllerAssignedTo,
                  decoration: const InputDecoration(
                    hintText: 'Assigned To',
                  )),
              TextField(
                  controller: controllerAssignedBy,
                  decoration: const InputDecoration(
                    hintText: 'Assigned By',
                  )),
              TextField(
                  controller: controllerDescription,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => submit(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

  void submit(context) {
    var item = BoardItemObject(
      title: controllerTitle.text,
      assignedTo: controllerAssignedTo.text,
      assignedBy: controllerAssignedBy.text,
      description: controllerDescription.text,
    );
    submitItemToDatabase(context, item);
  }

  Future submitItemToDatabase(context, BoardItemObject item) async {
    final docItem =
        FirebaseFirestore.instance.collection('BoardItemObject').doc();
    item.id = docItem.id;
    final json = item.toJson();
    await docItem.set(json);
    Navigator.pop(context);
  }
}
