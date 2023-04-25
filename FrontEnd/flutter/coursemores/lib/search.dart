import 'package:flutter/material.dart';
import 'courseList.dart' as course;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var courseList = course.COURSE_LIST;
  var sidoList = course.SIDO_LIST;

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
            return Container(
              margin: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 5),
              padding: const EdgeInsets.all(15),
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
                      child: Text("${courseList[index]['course']}"))
                ],
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

class SearchFilter extends StatefulWidget {
  const SearchFilter({super.key});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  @override
  Widget build(BuildContext context) {
    // var courseList = course.COURSE_LIST;
    var themeList = course.THEME_LIST;
    var sidoList = course.SIDO_LIST;
    var selectedSido = "";

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
          child: Column(
            children: [
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
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text("지역을 선택해보세요 🗺", style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: AwesomeDropDown(
                  selectedItem: selectedSido,
                  dropDownList: sidoList,
                  onDropDownItemClick: (selectedItem) {
                    selectedSido = selectedItem;
                    print(selectedSido);
                  },
                ),
              )
            ],
          ),
        ));
  }
}
