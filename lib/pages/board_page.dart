import 'package:boardview/board_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';

import '../models/board_item_object.dart';
import '../models/board_list_object.dart';
import '../shared/shared.dart';

///Board page
///This is a big one. If I had more time I would have split this up into smaller widgets.
///This is the page where you can administer your board.
///It is also where you can add and remove lists and items.
class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => BoardPageView();
}

class BoardPageView extends State<BoardPage> {
  ErrorLog saveToErrorlog = ErrorLog();

  Stream<List<BoardListObject>> listStream() => FirebaseFirestore.instance
      .collection('BoardListObject')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BoardListObject.listFromJson(doc.data()))
          .toList());
  Stream<List<BoardItemObject>> itemStream() => FirebaseFirestore.instance
      .collection('BoardItemObject')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BoardItemObject.itemFromJson(doc.data()))
          .toList());

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerInBoard = TextEditingController();
  final controllerAssignedTo = TextEditingController();
  final controllerAssignedBy = TextEditingController();

  final BoardViewController boardViewController = BoardViewController();

  late List<BoardListObject> _listData;
  late List<BoardItemObject> _itemData;

  @override
  Widget build(BuildContext context) {
    List<BoardList> list = <BoardList>[];

    return Scaffold(
        appBar: AppBar(
          title: const Text("BoardView Example"),
        ),
        drawer: const NavigationDrawer(),
        body: StreamBuilder<List<BoardListObject>>(
            stream: listStream(),
            builder: (context, listSnapshot) {
              if (listSnapshot.hasError) {
                // ignore: avoid_print
                print(listSnapshot.error);
                saveToErrorlog.saveToErrorlog(listSnapshot.error.toString());
                return const Text(
                    'Something went wrong with getting the lists, see errorlog for more info');
              } else if (listSnapshot.hasData) {
                _listData = listSnapshot.data!;
                _listData
                    .sort((a, b) => a.indexNumber.compareTo(b.indexNumber));
                return StreamBuilder<List<BoardItemObject>>(
                    stream: itemStream(),
                    builder: (context, itemSnapshot) {
                      if (itemSnapshot.hasError) {
                        // ignore: avoid_print
                        print(itemSnapshot.error);
                        saveToErrorlog
                            .saveToErrorlog(listSnapshot.error.toString());
                        return const Text(
                            'Something went wrong with getting the items, see errorlog for more info');
                      } else if (itemSnapshot.hasData) {
                        _itemData = itemSnapshot.data!;
                        combineStreams();
                        list = [];
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
                  onPressed: () => createNewItemDialog(context),
                  tooltip: 'Add Item to Board',
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () => createNewListDialog(context),
                  tooltip: 'Create new list',
                  child: const Icon(Icons.list_alt_outlined),
                ),
              ],
            )));
  }

  ///Set the controllers so the text won't pass over the next time you open a dialog.
  controllersSetToNull() {
    controllerTitle.text = '';
    controllerAssignedTo.text = '';
    controllerInBoard.text = '';
    controllerAssignedBy.text = '';
    controllerDescription.text = '';
  }

  ///Combines the streams from the lists and the items so they display correctly.
  combineStreams() {
    //combine _listData and _itemData
    for (var listElement in _listData) {
      listElement.items = [];
      //add item to list
      //ignore: avoid_print
      print(listElement.title);
      for (var itemElement in _itemData) {
        if (listElement.title == itemElement.inBoard) {
          //ignore: avoid_print
          print(itemElement.title);
          listElement.items?.add(itemElement);
        }
      }
    }
  }

  ///Functions for getting, creating etc and displaying on the board page.
  ///Given more time they would have been split up into their own classes.
  createBoardList(BoardListObject listObject) {
    List<BoardItem>? items = [];

    if (listObject.items != null) {
      for (int i = 0; i < listObject.items!.length; i++) {
        items.add(buildBoardItem(listObject.items![i]));
      }
    }
    return BoardList(
      onStartDragList: (index) {},
      onTapList: (listIndex) async {
        updateListDialog(context, listObject);
      },
      onDropList: (oldListIndex, listIndex) {
        final docRefOld = FirebaseFirestore.instance
            .collection('BoardListObject')
            .doc(_listData[listIndex!].id);

        final docRef = FirebaseFirestore.instance
            .collection('BoardListObject')
            .doc(_listData[oldListIndex!].id);

        docRefOld.update({'indexNumber': oldListIndex});
        docRef.update({'indexNumber': listIndex});
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

        final docRef = FirebaseFirestore.instance
            .collection('BoardItemObject')
            .doc(item?.id);
        docRef.update({'inBoard': _listData[listIndex].title});
      },
      onTapItem: (listIndex, itemIndex, state) async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(itemObject.title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Assigned To: ${itemObject.assignedTo}"),
                    const SizedBox(height: 10),
                    Text("Assigned by: ${itemObject.assignedBy}"),
                    const SizedBox(height: 10),
                    Text("Description: ${itemObject.description}"),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: ((() => updateItemDialog(context, itemObject))),
                    child: const Text('Update'),
                  ),
                  TextButton(
                    onPressed: (() => deleteItem(context, itemObject)),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            });
      },
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
                  "Title: ${itemObject.title}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Assigned To: ${itemObject.assignedTo}",
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

  void submitItem(context) {
    var item = BoardItemObject(
      title: controllerTitle.text,
      inBoard: 'To-Do',
      assignedTo: controllerAssignedTo.text,
      assignedBy: controllerAssignedBy.text,
      description: controllerDescription.text,
    );
    submitToDatabase(context, 'BoardItemObject', item);
    controllersSetToNull();
  }

  void submitList(context) {
    var list = BoardListObject(
        title: controllerTitle.text, indexNumber: _listData.length, items: []);
    submitToDatabase(context, 'BoardListObject', list);
  }

  createNewItemDialog(BuildContext context) => showDialog(
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
              onPressed: () => submitItem(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      );

  createNewListDialog(BuildContext context) => showDialog(
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

  updateItemDialog(BuildContext context, BoardItemObject itemObject) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(itemObject.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                    controller: controllerTitle,
                    decoration: InputDecoration(
                      hintText: itemObject.title,
                    )),
                TextField(
                    controller: controllerAssignedTo,
                    decoration: InputDecoration(
                      hintText: itemObject.assignedTo,
                    )),
                TextField(
                    controller: controllerAssignedBy,
                    decoration: InputDecoration(
                      hintText: itemObject.assignedBy,
                    )),
                TextField(
                    controller: controllerDescription,
                    decoration: InputDecoration(
                      hintText: itemObject.description,
                    )),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => updateItemToDatabase(context, itemObject)
                    .then((value) => Navigator.pop(context)),
                child: const Text('Submit'),
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  updateListDialog(BuildContext context, BoardListObject listObject) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(listObject.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                    controller: controllerTitle,
                    decoration: InputDecoration(
                      hintText: listObject.title,
                    )),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => updateListToDatabase(context, listObject),
                child: const Text('Submit'),
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () =>
                    {deleteList(context, listObject), Navigator.pop(context)},
              ),
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future submitToDatabase(context, String collection, var item) async {
    final docItem = FirebaseFirestore.instance.collection(collection).doc();
    item.id = docItem.id;
    Map<String, dynamic> json;

    if (collection == 'BoardItemObject') {
      json = item.itemToJson();
      await docItem.set(json);
    } else if (collection == 'BoardListObject') {
      json = item.listToJson();
      await docItem.set(json);
    }
    Navigator.pop(context);
  }

  Future deleteItem(context, BoardItemObject item) async {
    final docRef =
        FirebaseFirestore.instance.collection('BoardItemObject').doc(item.id);
    await docRef.delete();

    Navigator.pop(context);
  }

  Future updateItemToDatabase(context, BoardItemObject itemObject) async {
    var item = BoardItemObject(
      id: itemObject.id,
      title: controllerTitle.text.isEmpty
          ? itemObject.title
          : controllerTitle.text,
      inBoard: itemObject.inBoard ?? 'To-Do',
      assignedTo: controllerAssignedTo.text.isEmpty
          ? itemObject.assignedTo
          : controllerAssignedTo.text,
      assignedBy: controllerAssignedBy.text.isEmpty
          ? itemObject.assignedBy
          : controllerAssignedBy.text,
      description: controllerDescription.text.isEmpty
          ? itemObject.description
          : controllerDescription.text,
    );

    final docRef =
        FirebaseFirestore.instance.collection('BoardItemObject').doc(item.id);
    await docRef.update(item.itemToJson());
    controllersSetToNull();
    Navigator.pop(context);
  }

  Future updateListToDatabase(context, BoardListObject listObject) async {
    var list = BoardListObject(
      id: listObject.id,
      title: controllerTitle.text.isEmpty
          ? listObject.title
          : controllerTitle.text,
      indexNumber: listObject.indexNumber,
    );

    final docRef =
        FirebaseFirestore.instance.collection('BoardListObject').doc(list.id);
    await docRef.update(list.listToJson());
    controllersSetToNull();
    Navigator.pop(context);
  }

  Future deleteList(BuildContext context, BoardListObject listObject) async {
    final docRef = FirebaseFirestore.instance
        .collection('BoardListObject')
        .doc(listObject.id);
    await docRef.delete();
  }
}
