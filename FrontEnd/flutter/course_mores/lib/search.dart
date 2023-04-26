import 'package:flutter/material.dart';
import 'course_list.dart' as course;
import 'course_detail.dart' as detail;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
// import 'package:awesome_dropdown/awesome_dropdown.dart';
// import 'package:skeletons/skeletons.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var courseList = course.courseList;
  var sidoList = course.sidoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      // body: futureSearchResults == null
      // ? displayNoSearchResultScreen()
      // : displayUsersFoundScreen(),
      body: Container(
        color: Color.fromARGB(221, 244, 244, 244),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: courseList.length,
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
                                ThumbnailImage(),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CourseSearchList(
                                      courseList: courseList, index: index),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TextEditingController searchTextEditingController = TextEditingController();

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  controlSearching(str) {}

  searchPageHeader() {
    return AppBar(
        backgroundColor: Colors.black,
        title: TextFormField(
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "코스를 검색해보세요",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            prefixIcon: IconButton(
                icon: Icon(Icons.tune),
                color: Colors.grey,
                iconSize: 30,
                onPressed: () {
                  // print("필터 열기");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchFilter()),
                  );
                }),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              color: Colors.grey,
              iconSize: 30,
              onPressed: () {
                print("${searchTextEditingController.text} 검색하기");
              },
            ),
          ),
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          onFieldSubmitted: controlSearching,
        ));
  }

  displayNoSearchResultScreen() {}

  displayUsersFoundScreen() {}
}

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image(
        image: AssetImage('assets/img1.jpg'),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CourseSearchList extends StatelessWidget {
  const CourseSearchList({
    super.key,
    required this.courseList,
    required this.index,
  });

  final List<Map<String, Object>> courseList;
  final index;

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
                "${courseList[index]['course']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            if (courseList[index]["bookmark"] == true)
              Icon(Icons.bookmark, size: 24),
            if (courseList[index]["bookmark"] == false)
              Icon(Icons.bookmark_outline_rounded, size: 24),
          ],
        ),
        SizedBox(height: 3),
        Text(
          "${courseList[index]['address']} / 추천 인원수 ${courseList[index]['people'].toString()}",
          style: TextStyle(
            fontSize: 12,
            color: Colors.black38,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        SizedBox(height: 3),
        Text(
          "${courseList[index]['text']}",
          style: TextStyle(
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${courseList[index]['summary']}",
              style: TextStyle(
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: 14),
                    SizedBox(width: 3),
                    Text(courseList[index]["likes"].toString()),
                  ],
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.comment, size: 14),
                    SizedBox(width: 3),
                    Text(courseList[index]["comments"].toString()),
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
  const SearchFilter({Key? key}) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  var allSelectedTheme = [];
  var selectedAddress = [];

  selectAddress(address) {
    setState(() {
      selectedAddress = address;
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
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          // 선택된 테마 스타일
          selectedDecoration: BoxDecoration(
            color: Color.fromARGB(255, 115, 81, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
        ),
      );
      cards.add(card);
    }
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
              print("저장 아이템 리스트 : ");
              print(allSelectedTheme);
              print("선택 지역 : ");
              print(selectedAddress);
            },
          ),
          // 알림 아이콘과 텍스트 같이 넣으려고 RichText 사용
          title: RichText(
              text: const TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.tune,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: SizedBox(
                  width: 5,
                ),
              ),
              TextSpan(
                text: '검색 필터 설정',
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
        // 알림 리스트
        body: Container(
            color: Color.fromARGB(221, 244, 244, 244),
            child: Column(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("이런 테마는 어때요? 😊", style: TextStyle(fontSize: 20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: MultiSelectContainer(
                  items: cards,
                  onChange: (allSelectedItems, selectedItem) {
                    print("선택된 아이템 리스트 : ");
                    print(allSelectedItems);
                    allSelectedTheme = allSelectedItems;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("지역을 선택해보세요 🗺", style: TextStyle(fontSize: 20)),
              ),
              MyDropdown(selectAddress: selectAddress)
            ])));
  }
}

class MyDropdown extends StatefulWidget {
  MyDropdown({Key? key, this.selectAddress}) : super(key: key);
  final selectAddress;

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
            print("$_selectedFirstDropdownItem $_selectedSecondDropdownItem");
          },
        ),
        SizedBox(width: 16),
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
            print("$_selectedFirstDropdownItem $_selectedSecondDropdownItem");
          },
        ),
      ],
    );
  }
}
