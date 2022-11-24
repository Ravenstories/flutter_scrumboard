import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_scrumboard/models/boardModel.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';

import '../shared/shared.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => BoardPageView();
}

class BoardPageView extends State<BoardPage> {
  Stream<List<BoardListObject>> boardStream() => FirebaseFirestore.instance
      .collection('BoardListObject')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BoardListObject.listFromJson(doc.data()))
          .toList());
  Stream<List<BoardListObject>> itemStream() => FirebaseFirestore.instance
      .collection('BoardItemObject')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BoardListObject.listFromJson(doc.data()))
          .toList());

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerAssignedTo = TextEditingController();
  final controllerAssignedBy = TextEditingController();

  final BoardViewController boardViewController = BoardViewController();

  late List<BoardListObject> _listData;

  @override
  Widget build(BuildContext context) {
    List<BoardList> list = <BoardList>[];

    return Scaffold(
        appBar: AppBar(
          title: const Text("BoardView Example"),
        ),
        drawer: const NavigationDrawer(),
        body: StreamBuilder<List<BoardListObject>>(
            stream: boardStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text('Something went wrong');
              } else if (snapshot.hasData) {
                _listData = snapshot.data!;
                return StreamBuilder(
                    stream: itemStream(),
                    builder: (context, snapshot2) {
                      //Create function that combines the two streams
                      if (snapshot2.hasError) {
                        print(snapshot2.error);
                        return const Text('Something went wrong');
                      } else if (snapshot2.hasData) {
                        for (int i = 0; i < _listData.length; i++) {
                          list.add(createBoardList(_listData[i]));
                        }
                        return BoardView(
                            lists: list,
                            boardViewController: boardViewController);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () => createItem(context),
                  tooltip: 'Add Item to Board',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () => createList(context),
                  tooltip: 'Create new list',
                  child: const Icon(Icons.list_alt_outlined),
                ),
              ],
            ))

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

/*
  Widget createBoardList(BoardListObject listObject) => ListTile(
        title: Text(listObject.title),
      );
*/
  createBoardList(BoardListObject listObject) {
    List<BoardItem>? items = [];

    if (listObject.items != null) {
      for (int i = 0; i < listObject.items!.length; i++) {
        items.add(buildBoardItem(listObject.items![i]));
      }
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
        var item = _listData[oldListIndex!].items?[oldItemIndex!];
        _listData[oldListIndex].items?.removeAt(oldItemIndex!);
        _listData[listIndex!].items?.insert(itemIndex!, item!);
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
    final json = item.itemToJson();
    await docItem.set(json);
    Navigator.pop(context);
  }

  createList(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Create List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: controllerTitle,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => submitList(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

  void submitList(context) {
    var list = BoardListObject(title: controllerTitle.text, items: []);
    submitListToDatabase(context, list);
  }

  Future submitListToDatabase(context, BoardListObject list) async {
    final docItem =
        FirebaseFirestore.instance.collection('BoardListObject').doc();
    list.id = docItem.id;
    final json = list.listToJson();
    await docItem.set(json);
    Navigator.pop(context);
  }
}
