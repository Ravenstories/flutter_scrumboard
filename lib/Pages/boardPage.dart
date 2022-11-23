import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter_scrumboard/Models/boardModel.dart';

import '../shared/shared.dart';

class BoardPage extends StatelessWidget {
  BoardPage({super.key});

  final List<BoardListObject> _listData = [
    BoardListObject(
      title: 'To Do',
      items: [
        BoardItemObject(
          id: '1',
          title: 'Create a new Flutter project',
          to: 'To Do',
          from: 'In Progress',
          description: 'Create a new Flutter project',
        ),
        BoardItemObject(
          id: '2',
          title: 'Create a new Flutter project',
          to: 'To Do',
          from: 'In Progress',
          description: 'Create a new Flutter project',
        ),
        BoardItemObject(
          id: '3',
          title: 'Create a new Flutter project',
          to: 'To Do',
          from: 'In Progress',
          description: 'Create a new Flutter project',
        ),
        BoardItemObject(
          id: '4',
          title: 'Create a new Flutter project',
          to: 'To Do',
          from: 'In Progress',
          description: 'Create a new Flutter project',
        ),
        BoardItemObject(
          id: '5',
          title: 'Create a new Flutter project',
          to: 'To Do',
          from: 'In Progress',
          description: 'Create a new Flutter project',
        ),
      ],
    ),
    BoardListObject(title: 'In Progress', items: [
      BoardItemObject(
        id: '6',
        title: 'Create a new Flutter project',
        to: 'In Progress',
        from: 'To Do',
        description: 'Create a new Flutter project',
      ),
      BoardItemObject(
        id: '7',
        title: 'Create a new Flutter project',
        to: 'In Progress',
        from: 'To Do',
        description: 'Create a new Flutter project',
      ),
      BoardItemObject(
        id: '8',
        title: 'Create a new Flutter project',
        to: 'In Progress',
        from: 'To Do',
        description: 'Create a new Flutter project',
      ),
      BoardItemObject(
        id: '9',
        title: 'Create a new Flutter project',
        to: 'In Progress',
        from: 'To Do',
        description: 'Create a new Flutter project',
      ),
      BoardItemObject(
        id: '10',
        title: 'Create a new Flutter project',
        to: 'In Progress',
        from: 'To Do',
        description: 'Create a new Flutter project',
      )
    ])
  ];
  final BoardViewController boardViewController = BoardViewController();

  @override
  Widget build(BuildContext context) {
    List<BoardList> list = [];

    for (int i = 0; i < _listData.length; i++) {
      list.add(createBoardList(_listData[i]));
    }

    return Padding(
        padding: const EdgeInsets.all(16),
        child:
            BoardView(lists: list, boardViewController: boardViewController));
  }

  Widget createBoardList(BoardListObject listObject) {
    List<BoardItem> items = [];

    for (int i = 0; i < listObject.items.length; i++) {
      items.insert(i, buildBoardItem(listObject.items[i]));
    }

    return BoardList(
      onStartDragList: (index) {
        print('onStartDragList: $index');
      },
      onTapList: (listIndex) async {
        print('onTapList: $listIndex');
      },
      onDropList: (oldListIndex, listIndex) {
        print('onDropList: $oldListIndex, $listIndex');
        var list = _listData[oldListIndex!];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex!, list);
      },
      headerBackgroundColor: Colors.transparent,
      backgroundColor: Color(0xFFE5E5E5),
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

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
      onStartDragItem: (listIndex, itemIndex, state) => {},
      onDropItem: (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
        var item = _listData[oldListIndex!].items[oldItemIndex!];
        _listData[oldListIndex].items.removeAt(oldItemIndex);
        _listData[listIndex!].items.insert(itemIndex!, item);
      },
      onTapItem: (listIndex, itemIndex, state) => {},
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
}
