import 'package:flutter/material.dart';
import '../controller/detail_controller.dart';
import '../controller/search_controller.dart';
import '../main.dart';
import 'course_detail.dart' as detail;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'elastic_search.dart';

SearchController searchController = SearchController();
DetailController detailController = DetailController();
TextEditingController searchTextEditingController = TextEditingController();
MultiSelectController multiSelectController = MultiSelectController();

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    searchController.getThemeList();
    searchController.getSidoList();
    Get.put(SearchController());
    return Obx(() => Scaffold(
          appBar: searchPageHeader(),
          body: searchController.courseList.isEmpty ? displayNoSearchResultScreen() : SearchResult(),
        ));
  }
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
                        searchController.searchCourse();
                      },
                    ),
                  ],
                ),
              ),
              style: TextStyle(fontSize: 18, color: Colors.black),
              onFieldSubmitted: controlSearching,
            ),
          ),
          SizedBox(
            height: 45,
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [isVisitedCheckBox(), sortButtonBar()],
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
        width: 110,
        height: 45,
        child: Obx(
          () => CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.all(0),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('방문여부', style: TextStyle(color: Colors.black, fontSize: 16)),
            value: searchController.isVisited.value,
            onChanged: (value) {
              searchController.changeIsVisited();
            },
          ),
        )),
  );
}

sortButtonBar() {
  return SizedBox(
    child: ButtonBar(
      alignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
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
          child: Text('최신순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
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
          child: Text('인기순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      ],
    ),
  );
}

filterButton() {
  return IconButton(
      icon: Icon(Icons.tune),
      color: Colors.grey,
      iconSize: 25,
      onPressed: () {
        Get.to(() => SearchFilter());
      });
}

displayNoSearchResultScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("🔍", style: TextStyle(fontSize: 70)),
        SizedBox(height: 20),
        Text("검색결과가 없어요."),
        SizedBox(height: 10),
        Text("다른 조건으로 검색해볼까요?"),
      ],
    ),
  );
}

class SearchResult extends StatelessWidget {
  SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: Color.fromARGB(221, 244, 244, 244),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(8),
            itemCount: searchController.courseList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await searchController.changeNowCourseId(courseId: searchController.courseList[index]['courseId']);

                  await detailController.getCourseInfo('코스 소개');

                  Get.to(() => detail.Detail());
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  padding: EdgeInsets.all(10),
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 211, 211, 211),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(3, 3)),
                  ], color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
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

  late final people;

  @override
  Widget build(BuildContext context) {
    if (searchController.courseList[index]['people'] <= 0) {
      people = "상관 없음";
    } else if (searchController.courseList[index]['people'] >= 5) {
      people = "5명 이상";
    } else {
      people = "${searchController.courseList[index]['people']}명";
    }

    return Column(
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
                      "${searchController.courseList[index]['title']}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            child: Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                          Text("방문", style: TextStyle(color: Colors.white, fontSize: 12)),
                          SizedBox(width: 7),
                        ],
                      ),
                    )
                ],
              ),
            ),
            if (searchController.courseList[index]["interest"]) Icon(Icons.bookmark, size: 24),
            if (!searchController.courseList[index]["interest"]) Icon(Icons.bookmark_outline_rounded, size: 24),
          ],
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.map, size: 12, color: Colors.black54),
            SizedBox(width: 3),
            Text(
              "${searchController.courseList[index]["sido"].toString()} ${searchController.courseList[index]["gugun"].toString()}",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Icon(Icons.people, size: 12, color: Colors.black54),
            SizedBox(width: 3),
            Text(
              people,
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          "${searchController.courseList[index]['content']}",
          style: TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${searchController.courseList[index]['locationName']}",
              style: TextStyle(fontSize: 12, color: Colors.black45),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(width: 8),
            Row(
              children: [
                Row(
                  children: [
                    if (searchController.courseList[index]["like"]) Icon(Icons.favorite, size: 14),
                    if (!searchController.courseList[index]["like"]) Icon(Icons.favorite_border_outlined, size: 14),
                    SizedBox(width: 3),
                    Text(searchController.courseList[index]["likeCount"].toString()),
                  ],
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.comment, size: 14),
                    SizedBox(width: 3),
                    Text(searchController.courseList[index]["commentCount"].toString()),
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

class SearchFilter extends StatelessWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // searchController.settingCard();

    searchController.getThemeList();
    searchController.getSidoList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: RichText(
            text: TextSpan(
          children: const [
            WidgetSpan(child: Icon(Icons.tune, color: Colors.black)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: '검색 필터 설정', style: TextStyle(fontSize: 22, color: Colors.black)),
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close, color: Colors.black)),
        ],
      ),
      body: Container(
        color: Color.fromARGB(221, 244, 244, 244),
        child: Column(children: [
          SizedBox(height: 20),
          Text("이런 테마는 어때요? 😊", style: TextStyle(fontSize: 20)),
          SearchFilterTheme(),
          SizedBox(height: 20),
          Text("지역을 선택해보세요 🗺", style: TextStyle(fontSize: 20)),
          SearchFilterRegion(),
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

class SearchFilterTheme extends StatelessWidget {
  const SearchFilterTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: MultiSelectContainer(
        items: searchController.cards,
        controller: multiSelectController,
        onChange: (allSelectedItems, selectedItem) {
          searchController.selectedThemeList.value = allSelectedItems;
        },
      ),
    );
  }
}

class SearchFilterRegion extends StatelessWidget {
  SearchFilterRegion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: searchController.selectedAddress['sido'],
              items: searchController.sidoList.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) async {
                searchController.changeSido(sido: value);
              },
            ),
            SizedBox(width: 15),
            DropdownButton(
              value: searchController.selectedAddress['gugun'],
              items: searchController.gugunList.map((value) {
                return DropdownMenuItem(
                  value: value['gugun'],
                  child: Text(value['gugun'] as String),
                );
              }).toList(),
              onChanged: (newValue) {
                searchController.changeGugun(gugun: newValue as String);
              },
            ),
          ],
        ));
  }
}
