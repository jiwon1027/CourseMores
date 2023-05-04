import 'package:coursemores/course_make/make3.dart';
import 'package:coursemores/course_make/make_map.dart';
import 'package:coursemores/course_make/make_search.dart';
// import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as frl;
import 'package:flutter/material.dart';
import './place_edit.dart';

class CourseMake extends StatefulWidget {
  const CourseMake({Key? key}) : super(key: key);

  @override
  State<CourseMake> createState() => _CourseMakeState();
}

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  android,
}

class _CourseMakeState extends State<CourseMake> {
  // list of tiles
  late List<ItemData> _items;
  _CourseMakeState() {
    _items = [];
    for (int i = 0; i < 30; ++i) {
      String label = "List item $i";
      if (i == 5) {
        label += ". This item has a long label and will be wrapped.";
      }
      _items.add(ItemData(label, ValueKey(i)));
    }
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  void onEdit(ItemData item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(item: item),
      ),
    );
  }

  void onDelete(ItemData item) {
    // TODO: Implement deleting logic here
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 없어도 <- 모양의 뒤로가기가 기본으로 있으나 < 모양으로 바꾸려고 추가함
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // 알림 아이콘과 텍스트 같이 넣으려고 RichText 사용
        title: RichText(
            text: const TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.edit_note,
                color: Colors.black,
              ),
            ),
            WidgetSpan(
              child: SizedBox(
                width: 5,
              ),
            ),
            TextSpan(
              text: '장소 추가하기 🏙',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
          ],
        )),
        // 피그마와 모양 맞추려고 close 아이콘 하나 넣어둠
        // <와 X 중 하나만 있어도 될 것 같아서 상의 후 삭제 필요
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              const Text(
                '장소는 최대 5개까지 추가할 수 있어요',
                style: TextStyle(
                    color: Color.fromARGB(255, 92, 67, 67), fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 380,
                height: 520,
                child: frl.ReorderableList(
                  onReorder: _reorderCallback,
                  onReorderDone: _reorderDone,
                  child: CustomScrollView(
                    // cacheExtent: 3000,
                    slivers: <Widget>[
                      // SliverAppBar(
                      //   actions: <Widget>[
                      //     PopupMenuButton<DraggingMode>(
                      //       initialValue: _draggingMode,
                      //       onSelected: (DraggingMode mode) {
                      //         setState(() {
                      //           _draggingMode = mode;
                      //         });
                      //       },
                      //       itemBuilder: (BuildContext context) =>
                      //           <PopupMenuItem<DraggingMode>>[
                      //         const PopupMenuItem<DraggingMode>(
                      //             value: DraggingMode.iOS,
                      //             child: Text('iOS-like dragging')),
                      //         const PopupMenuItem<DraggingMode>(
                      //             value: DraggingMode.android,
                      //             child: Text('Android-like dragging')),
                      //       ],
                      //     ),
                      //   ],
                      //   pinned: true,
                      //   expandedHeight: 150.0,
                      //   flexibleSpace: const FlexibleSpaceBar(
                      //     title: Text('Demo'),
                      //   ),
                      // ),
                      SliverPadding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Item(
                                  data: _items[index],
                                  // first and last attributes affect border drawn during dragging
                                  isFirst: index == 0,
                                  isLast: index == _items.length - 1,
                                  draggingMode: _draggingMode,
                                  onEdit: () => onEdit(_items[index]),
                                  onDelete: () => onDelete(_items[index]),
                                );
                              },
                              childCount: _items.length,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // const MyStatefulWidget(),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CMSearch()),
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: const Text(
                        '검색 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CMMap()),
                        );
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      label: const Text(
                        '마커 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.verified),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('정말로 작성이 완료 되었나요?'),
                        content: const Text('작성하신 내용을 저장하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // TODO: Implement saving logic here
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MakeStepper()),
                              );
                            },
                            child: const Text('저장'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('취소'),
                          ),
                        ],
                      );
                    },
                  );
                },
                label: const Text('코스 지정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  final ItemData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Widget _buildChild(BuildContext context, frl.ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == frl.ReorderableItemState.dragProxy ||
        state == frl.ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = const BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == frl.ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? frl.ReorderableListener(
            child: Container(
              padding: const EdgeInsets.only(right: 18.0, left: 18.0),
              color: const Color(0x08000000),
              child: const Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                            label: Text('추가 정보 작성'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.delete),
                            label: Text('장소 삭제'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: dragHandle,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget image = Container(
      // height: MediaQuery.of(context).size.height / 4,
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.android) {
      content = frl.DelayedReorderableListener(
        child:
            // Column(
            //   children: [
            //     image,
            //     content,
            //   ],
            // ),
            Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              image,
              content,
            ],
          ),
        ),
      );
    }

    // return Column(
    //   children: [
    //     image,
    //     content,
    //   ],
    // );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          image,
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return frl.ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
