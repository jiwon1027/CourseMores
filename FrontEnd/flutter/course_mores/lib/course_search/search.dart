import 'package:flutter/material.dart';
import 'course_list.dart' as course;
import 'course_detail.dart' as detail;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var courseList = course.courseList;
  var sidoList = course.sidoList;

  var isSearchResults = false;
  bool isVisited = false;
  bool isLatestSelected = true;
  bool isPopularSelected = false;
  TextEditingController searchTextEditingController = TextEditingController();

  var allSelectedThemeList = [];
  var selectedAddress = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: isSearchResults == false
          ? displayNoSearchResultScreen()
          : SearchResult(courseList: courseList),
      // body: SearchResult(courseList: courseList),
    );
  }

  saveFilter(newSelectedThemeList) {
    setState(() {
      allSelectedThemeList = newSelectedThemeList;
    });
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  controlSearching(str) {}

  isVisitedCheckBoxClick() {
    setState(() {
      isVisited = !isVisited;
      Fluttertoast.showToast(
        msg:
            "방문여부 : $isVisited, 최신순 : $isLatestSelected, 인기순 : $isPopularSelected, 필터 테마 : $allSelectedThemeList, 필터 지역 : $selectedAddress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  isLatestSelectedClick() {
    setState(() {
      isLatestSelected = true;
      isPopularSelected = false;
      Fluttertoast.showToast(
        msg:
            "방문여부 : $isVisited, 최신순 : $isLatestSelected, 인기순 : $isPopularSelected, 필터 테마 : $allSelectedThemeList, 필터 지역 : $selectedAddress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  isPopularSelectedClick() {
    setState(() {
      isLatestSelected = false;
      isPopularSelected = true;
      Fluttertoast.showToast(
        msg:
            "방문여부 : $isVisited, 최신순 : $isLatestSelected, 인기순 : $isPopularSelected, 필터 테마 : $allSelectedThemeList, 필터 지역 : $selectedAddress",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  searchPageHeader() {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 110,
        title: Column(
          children: [
            SizedBox(
              height: 45,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: searchTextEditingController,
                decoration: InputDecoration(
                  hintText: "코스를 검색해보세요",
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  prefixIcon: FilterButton(
                      context: context,
                      allSelectedThemeList: allSelectedThemeList,
                      selectedAddress: selectedAddress,
                      saveFilter: saveFilter),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.grey,
                    iconSize: 25,
                    onPressed: () {
                      // print("${searchTextEditingController.text} 검색하기");
                      setState(() {
                        isSearchResults = true;
                        Fluttertoast.showToast(
                          msg:
                              "방문여부 : $isVisited, 최신순 : $isLatestSelected, 인기순 : $isPopularSelected, 필터 테마 : $allSelectedThemeList, 필터 지역 : $selectedAddress",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                        // isVisited
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                onFieldSubmitted: controlSearching,
              ),
            ),
            SizedBox(
              height: 45,
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IsVisitedCheckBox(
                    isVisited: isVisited,
                    isVisitedCheckBoxClick: isVisitedCheckBoxClick,
                  ),
                  SortButtonBar(
                      isLatestSelected: isLatestSelected,
                      isPopularSelected: isPopularSelected,
                      isLatestSelectedClick: isLatestSelectedClick,
                      isPopularSelectedClick: isPopularSelectedClick),
                ],
              ),
            )
          ],
        ));
  }

  displayNoSearchResultScreen() {}

  // displayUsersFoundScreen() {}
}

class SortButtonBar extends StatefulWidget {
  const SortButtonBar({
    Key? key,
    required this.isLatestSelected,
    required this.isPopularSelected,
    required this.isLatestSelectedClick,
    required this.isPopularSelectedClick,
  }) : super(key: key);

  final isLatestSelected;
  final isPopularSelected;
  final isLatestSelectedClick;
  final isPopularSelectedClick;

  @override
  State<SortButtonBar> createState() => _SortButtonBarState();
}

class _SortButtonBarState extends State<SortButtonBar> {
  late var isLatestSelected = widget.isLatestSelected;
  late var isPopularSelected = widget.isPopularSelected;
  late var isLatestSelectedClick = widget.isLatestSelectedClick;
  late var isPopularSelectedClick = widget.isPopularSelectedClick;

  @override
  void initState() {
    super.initState();
    isLatestSelected = widget.isLatestSelected;
    isPopularSelected = widget.isPopularSelected;
    isLatestSelectedClick = widget.isLatestSelectedClick;
    isPopularSelectedClick = widget.isPopularSelectedClick;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.amber,
      height: 45,
      width: 250,
      child: ButtonBar(
        buttonPadding: EdgeInsets.symmetric(horizontal: 10),
        alignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              isLatestSelectedClick();
              isLatestSelected = true;
              isPopularSelected = false;
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(90, 35)),
              padding: MaterialStateProperty.all(
                  EdgeInsetsDirectional.symmetric(horizontal: 10)),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(
                  isLatestSelected ? Colors.blue : Colors.grey),
            ),
            child: const Text(
              '최신순',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              isPopularSelectedClick();
              isLatestSelected = false;
              isPopularSelected = true;
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(90, 35)),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(
                  isPopularSelected ? Colors.blue : Colors.grey),
            ),
            child: const Text(
              '인기순',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.context,
    required this.allSelectedThemeList,
    required this.selectedAddress,
    required this.saveFilter,
  });

  final BuildContext context;
  final allSelectedThemeList;
  final selectedAddress;
  final saveFilter;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.tune),
        color: Colors.grey,
        iconSize: 25,
        onPressed: () {
          // print("필터 열기");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchFilter(
                    allSelectedThemeList: allSelectedThemeList,
                    selectedAddress: selectedAddress,
                    saveFilter: saveFilter)),
          );
        });
  }
}

class IsVisitedCheckBox extends StatefulWidget {
  IsVisitedCheckBox({
    super.key,
    required this.isVisitedCheckBoxClick,
    required this.isVisited,
  });

  final isVisited;
  final Function isVisitedCheckBoxClick;
  @override
  State<IsVisitedCheckBox> createState() => _IsVisitedCheckBoxState();
}

class _IsVisitedCheckBoxState extends State<IsVisitedCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      alignment: Alignment.center,
      child: SizedBox(
        width: 110,
        height: 45,
        child: CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.all(0),
          controlAffinity: ListTileControlAffinity.leading,
          title:
              Text('방문여부', style: TextStyle(color: Colors.black, fontSize: 16)),
          value: widget.isVisited,
          onChanged: (value) {
            widget.isVisitedCheckBoxClick();
          },
          // dense: true,
          // 체크박스와 텍스트 사이의 거리를 조절하기 위한 패딩
        ),
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  const SearchResult({
    super.key,
    required this.courseList,
  });

  final List<Map<String, Object>> courseList;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(221, 244, 244, 244),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8),
        itemCount: widget.courseList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => detail.CourseDetail(index: index)),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 5),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        // color: Colors.white24,
                        color: Color.fromARGB(255, 211, 211, 211),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(3, 3)),
                  ],
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      // 알림 유형별로 다른 문구 출력을 위해 따로 빼둠
                      // 더 효율적인 방식 있으면 바꿔도 됨
                      child: SizedBox(
                          width: 300,
                          child: Row(
                            children: [
                              const ThumbnailImage(),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CourseSearchList(
                                    // courseList: courseList,
                                    index: index),
                              ),
                            ],
                          ))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ThumbnailImage extends StatefulWidget {
  const ThumbnailImage({
    super.key,
  });

  @override
  State<ThumbnailImage> createState() => _ThumbnailImageState();
}

class _ThumbnailImageState extends State<ThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: const Image(
        image: AssetImage('assets/img1.jpg'),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CourseSearchList extends StatefulWidget {
  const CourseSearchList({
    super.key,
    required this.index,
    // required addLike,
  });

  final int index;

  @override
  State<CourseSearchList> createState() => _CourseSearchListState();
}

class _CourseSearchListState extends State<CourseSearchList> {
  var courseList = course.courseList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${courseList[widget.index]['course']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            if (courseList[widget.index]["bookmark"] == true)
              const Icon(Icons.bookmark, size: 24),
            if (courseList[widget.index]["bookmark"] == false)
              const Icon(Icons.bookmark_outline_rounded, size: 24),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.map, size: 12, color: Colors.black54),
            const SizedBox(width: 3),
            Text(
              courseList[widget.index]["address"].toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.people, size: 12, color: Colors.black54),
            const SizedBox(width: 3),
            Text(
              "${courseList[widget.index]['people'].toString()}명",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "${courseList[widget.index]['text']}",
          style: const TextStyle(
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${courseList[widget.index]['summary']}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 14),
                    const SizedBox(width: 3),
                    Text(courseList[widget.index]["likes_cnt"].toString()),
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.comment, size: 14),
                    const SizedBox(width: 3),
                    Text(courseList[widget.index]["comments"].toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SearchFilter extends StatefulWidget {
  const SearchFilter(
      {Key? key,
      required this.allSelectedThemeList,
      required this.selectedAddress,
      required this.saveFilter})
      : super(key: key);

  final allSelectedThemeList;
  final selectedAddress;
  final saveFilter;

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  late var allSelectedThemeList = widget.allSelectedThemeList;
  late var selectedAddress = widget.selectedAddress;

  late var newAllSelectedThemeList = widget.allSelectedThemeList;
  late var newSelectedAddress = widget.selectedAddress;
  late var saveFilter = widget.saveFilter;

  final multiSelectController = MultiSelectController();

  selectAddress(address) {
    setState(() {
      newSelectedAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeList = course.themeList;

    List<MultiSelectCard> cards = [];
    for (var theme in themeList) {
      var card = MultiSelectCard(
        value: theme['text'],
        label: theme['text'],
        selected: allSelectedThemeList.contains(theme['text']),
        decorations: MultiSelectItemDecorations(
          // 선택 전 테마 스타일
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          // 선택된 테마 스타일
          selectedDecoration: BoxDecoration(
            color: const Color.fromARGB(255, 115, 81, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
        ),
      );
      cards.add(card);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () {
            Fluttertoast.showToast(
              msg:
                  "allSelectedTheme : $allSelectedThemeList, selectedAddress : $selectedAddress",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
            Navigator.pop(context);
            // print("저장 아이템 리스트 : ");
            // print(allSelectedTheme);
            // print("선택 지역 : ");
            // print(selectedAddress);
          },
        ),
        title: RichText(
            text: const TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.tune, color: Colors.black)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(
                text: '검색 필터 설정',
                style: TextStyle(fontSize: 22, color: Colors.black)),
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg:
                      "allSelectedTheme : $allSelectedThemeList, selectedAddress : $selectedAddress",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: Colors.black)),
        ],
      ),
      // 알림 리스트
      body: Container(
        color: const Color.fromARGB(221, 244, 244, 244),
        child: Column(children: [
          SizedBox(height: 20),
          Text("이런 테마는 어때요? 😊", style: TextStyle(fontSize: 20)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: MultiSelectContainer(
              items: cards,
              controller: multiSelectController,
              onChange: (allSelectedItems, selectedItem) {
                // print("선택된 아이템 리스트 : ");
                // print(allSelectedItems);
                newAllSelectedThemeList = allSelectedItems;
                // allSelectedTheme = allSelectedItems;
              },
            ),
          ),
          SizedBox(height: 20),
          Text("지역을 선택해보세요 🗺", style: TextStyle(fontSize: 20)),
          MyDropdown(selectAddress: selectAddress),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  //TODO: 초기화 버튼이 눌렸을 때, 지역 초기화 동작 구현 필요
                  setState(() {
                    multiSelectController.deselectAll(); // 선택 취소
                    newAllSelectedThemeList = [];
                    Fluttertoast.showToast(
                      msg:
                          "allSelectedTheme : $newAllSelectedThemeList, selectedAddress : $selectedAddress",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  });
                },
                child: Text("초기화", style: TextStyle(color: Colors.black)),
              ),
              SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  //TODO: 저장 버튼이 눌렸을 때, 지역 저장 동작 구현 필요
                  saveFilter(newAllSelectedThemeList);
                  Fluttertoast.showToast(
                    msg:
                        "allSelectedTheme : $newAllSelectedThemeList, selectedAddress : $selectedAddress",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                },
                child: Text("저장", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class MyDropdown extends StatefulWidget {
  const MyDropdown({Key? key, this.selectAddress}) : super(key: key);
  final dynamic selectAddress;

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _MyDropdownState createState() => _MyDropdownState(selectAddress);
}

class _MyDropdownState extends State<MyDropdown> {
  final List<String> _firstDropdownItems = course.sidoList;
  final Map<String, List<String>> _secondDropdownItems = course.sidoAllList;

  String _selectedFirstDropdownItem = "서울특별시";
  String _selectedSecondDropdownItem = "종로구";

  _MyDropdownState(selectAddress);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton(
          value: _selectedFirstDropdownItem,
          items: _firstDropdownItems.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedFirstDropdownItem = newValue ?? "";
              _selectedSecondDropdownItem =
                  _secondDropdownItems[_selectedFirstDropdownItem]![0];
            });
            // print("$_selectedFirstDropdownItem $_selectedSecondDropdownItem");
          },
        ),
        const SizedBox(width: 16),
        DropdownButton(
          value: _selectedSecondDropdownItem,
          items: _secondDropdownItems[_selectedFirstDropdownItem]!
              .map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedSecondDropdownItem = newValue ?? "";
            });
            // selectAddress(
            //     [_selectedFirstDropdownItem, _selectedSecondDropdownItem]);
            // print("$_selectedFirstDropdownItem $_selectedSecondDropdownItem");
          },
        ),
      ],
    );
  }
}
