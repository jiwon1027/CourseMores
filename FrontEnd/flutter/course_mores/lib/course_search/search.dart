import 'package:flutter/material.dart';
import 'course_list.dart' as course;
import 'course_detail.dart' as detail;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'elastic_search.dart';
import 'search_filter.dart';

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
  var selectedAddress = ["전체", "전체"];

  @override
  Widget build(BuildContext context) {
    searchController.getThemeList();
    searchController.getSidoList();
    Get.put(SearchController());
    return Obx(() => Scaffold(
          appBar: searchPageHeader(),
          body: searchController.courseList.isEmpty
              ? displayNoSearchResultScreen()
              : SearchResult(),
        ),
      ),
    );
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

controlSearching(str) {}

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
              onTap: () => Get.to(SearchScreen()),
              onChanged: (value) {
                searchController.changeWord(word: searchTextEditingController.text);
              },
              decoration: InputDecoration(
                hintText: "코스를 검색해보세요",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                filled: true,
                // prefixIcon: FilterButton(context: context),
                prefixIcon: filterButton(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.grey,
                      onPressed: () {
                        searchTextEditingController.clear();
                        searchController.changeWord(word: '');
                        searchController.getElasticList();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.grey,
                      iconSize: 25,
                      onPressed: () {
                        Get.back();
                        pageController.changePageNum(2);
                        searchController.isSearchResults.value = true;
                        searchController.changePage(page: 0);
                        searchController.searchCourse();
                      },
                    ),
                  ],
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

isVisitedCheckBox() {
  return Container(
    // color: Colors.amber,
    alignment: Alignment.center,
    child: SizedBox(
        width: 150,
        height: 40,
        child: Obx(() => Row(
              children: [
                InkWell(
                  child: Row(children: [
                    CheckboxMenuButton(
                      value: searchController.isVisited.value,
                      onChanged: (value) {
                        searchController.changePage(page: 0);
                        searchController.changeIsVisited();
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                        child: Text('방문여부',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                      ),
                    ),
                  ]),
                )
              ],
            ))),
  );
}

sortButtonBar() {
  return SizedBox(
    child: ButtonBar(
      alignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            searchController.changePage(page: 0);
            searchController.changeSortby(sortby: 'latest');
            searchController.isLatestSelected.value = true;
            searchController.isPopularSelected.value = false;
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
            padding: MaterialStateProperty.all(EdgeInsetsDirectional.symmetric(horizontal: 0)),
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor:
                MaterialStateProperty.all<Color>(searchController.isLatestSelected.value ? Colors.blue : Colors.grey),
          ),
          child: Text('최신순',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ),
        ElevatedButton(
          onPressed: () {
            searchController.changePage(page: 0);
            searchController.changeSortby(sortby: 'popular');
            searchController.isLatestSelected.value = false;
            searchController.isPopularSelected.value = true;
          },
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
            padding: MaterialStateProperty.all(EdgeInsetsDirectional.symmetric(horizontal: 0)),
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor:
                MaterialStateProperty.all<Color>(searchController.isPopularSelected.value ? Colors.blue : Colors.grey),
          ),
          child: Text('인기순',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ),
      ],
    ),
  );
}

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
                    saveFilter: saveFilter,
                    saveAddress: saveAddress)),
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
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // 스크롤이 리스트의 끝까지 도달하면 다음 검색 결과 호출
        searchController.getNextSearchResults();
      }
    });
    return Obx(() => Container(
          color: Color.fromARGB(221, 244, 244, 244),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController, // ScrollController 설정
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  itemCount: searchController.courseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        await searchController.changeNowCourseId(
                            courseId: searchController.courseList[index]['courseId']);

                        await detailController.getCourseInfo('코스 소개');

                        Get.to(() => detail.Detail());
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(33, 0, 0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 3,
                                  offset: Offset(0, 3)),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: SizedBox(
                                    width: 300,
                                    child: Row(children: [
                                      ThumbnailImage(index: index),
                                      SizedBox(width: 10),
                                      Expanded(child: CourseSearchList(index: index)),
                                    ]))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (searchController.isCourseLoading.value) CircularProgressIndicator(), // 로딩 중인 경우 표시할 위젯
            ],
          ),
        ));
  }
}

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({super.key, required this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: searchController.courseList[index]['image'],
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
      // child: Image(
      //   image: AssetImage(courseList[widget.index]['image']),
      //   // image: AssetImage('assets/img1.jpg'),
      //   height: 80,
      //   width: 80,
      //   fit: BoxFit.cover,
      // ),
    );
  }
}

class CourseSearchList extends StatelessWidget {
  CourseSearchList({super.key, required this.index});
  final int index;

  @override
  State<CourseSearchList> createState() => _CourseSearchListState();
}

class _CourseSearchListState extends State<CourseSearchList> {
  var courseList = course.courseList;

  @override
  Widget build(BuildContext context) {
    if (searchController.courseList[index]['people'] <= 0) {
      people = "상관 없음";
    } else if (searchController.courseList[index]['people'] >= 5) {
      people = "5명 이상";
    } else {
      people = "${searchController.courseList[index]['people']}명";
    }

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          searchController.courseList[index]['title'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                        ),
                      ),
                      SizedBox(width: 10),
                      if (searchController.courseList[index]["visited"] == true)
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 107, 211, 66),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.check,
                                    size: 12, color: Colors.white),
                              ),
                              Text("방문",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                              SizedBox(width: 7),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                if (searchController.courseList[index]["interest"])
                  Icon(Icons.bookmark, size: 24, color: Colors.purple),
                if (!searchController.courseList[index]["interest"])
                  Icon(Icons.bookmark_outline_rounded,
                      size: 24, color: Colors.purple),
              ],
            ),
            SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 12, color: Colors.black54),
                SizedBox(width: 3),
                Text(
                  "${searchController.courseList[index]["sido"].toString()} ${searchController.courseList[index]["gugun"].toString()}",
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
                SizedBox(width: 8),
                Icon(Icons.people, size: 12, color: Colors.black54),
                SizedBox(width: 3),
                Text(
                  people,
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ],
            ),
            SizedBox(height: 6),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${searchController.courseList[index]['locationName']}",
                    style: TextStyle(fontSize: 10, color: Colors.black45),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                ),
                SizedBox(width: 5),
                Row(
                  children: [
                    Row(
                      children: [
                        if (searchController.courseList[index]["like"])
                          Icon(Icons.favorite, size: 14),
                        if (!searchController.courseList[index]["like"])
                          Icon(Icons.favorite_border_outlined, size: 14),
                        SizedBox(width: 3),
                        Text(
                            searchController.courseList[index]["likeCount"]
                                .toString(),
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(Icons.comment, size: 14),
                        SizedBox(width: 3),
                        Text(
                            searchController.courseList[index]["commentCount"]
                                .toString(),
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
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
      required this.saveFilter,
      required this.saveAddress})
      : super(key: key);

  final allSelectedThemeList;
  final selectedAddress;
  final saveFilter;
  final saveAddress;

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  late var allSelectedThemeList = widget.allSelectedThemeList;
  late var selectedAddress = widget.selectedAddress;

  late var newAllSelectedThemeList = widget.allSelectedThemeList;
  late var newSelectedAddress = widget.selectedAddress;
  late var saveFilter = widget.saveFilter;
  late var saveAddress = widget.saveAddress;

  final multiSelectController = MultiSelectController();

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
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                newAllSelectedThemeList = allSelectedItems;
              },
            ),
          ),
          SizedBox(height: 20),
          Text("지역을 선택해보세요 🗺", style: TextStyle(fontSize: 20)),
          MyDropdown(
              selectAddress: selectAddress, selectedAddress: selectedAddress),
          SizedBox(height: 20),
          SearchFilterButtons(),
        ]),
      ),
    );
  }
}

class SearchFilterButtons extends StatelessWidget {
  const SearchFilterButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            multiSelectController.deselectAll(); // 보여지는 테마 리스트 선택 취소
            searchController.changeSelectedThemeList(list: [].obs);
            searchController.changeSido(sido: "전체");
            searchController.changeGugun(gugun: "전체");
          },
          child: Text("초기화", style: TextStyle(color: Colors.black)),
        ),
        SizedBox(width: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
          ),
          onPressed: () {
            searchController.saveFilter();
            Get.back();
          },
          child: Text("저장", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

class MyDropdown extends StatefulWidget {
  const MyDropdown(
      {Key? key, this.selectAddress, required this.selectedAddress})
      : super(key: key);
  final dynamic selectAddress;
  final List<String> selectedAddress;

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _MyDropdownState createState() => _MyDropdownState(selectAddress);
}

class _MyDropdownState extends State<MyDropdown> {
  final List<String> _firstDropdownItems = course.sidoList;
  final Map<String, List<String>> _secondDropdownItems = course.sidoAllList;

  _MyDropdownState(selectAddress);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton(
          value: widget.selectedAddress[0],
          items: _firstDropdownItems.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              widget.selectedAddress[0] = newValue ?? "전체";
              widget.selectedAddress[1] =
                  _secondDropdownItems[widget.selectedAddress[0]]![0];
              widget.selectAddress(
                  [widget.selectedAddress[0], widget.selectedAddress[1]]);
            });
          },
        ),
        const SizedBox(width: 15),
        DropdownButton(
          value: widget.selectedAddress[1],
          items: _secondDropdownItems[widget.selectedAddress[0]]!
              .map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              widget.selectedAddress[1] = newValue ?? "전체";
              widget.selectAddress(
                  [widget.selectedAddress[0], widget.selectedAddress[1]]);
            });
          },
        ),
      ],
    );
  }
}
