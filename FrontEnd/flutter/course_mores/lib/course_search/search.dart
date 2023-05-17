import 'package:flutter/material.dart';
import '../controller/detail_controller.dart';
import '../controller/search_controller.dart';
import '../main.dart';
import 'course_detail.dart' as detail;
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'elastic_search.dart';
import 'search_filter.dart';

SearchController searchController = SearchController();
DetailController detailController = DetailController();
TextEditingController searchTextEditingController = TextEditingController();
MultiSelectController multiSelectController = MultiSelectController();
ScrollController scrollController = ScrollController();

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    searchController.getThemeList();
    searchController.getSidoList();
    Get.put(SearchController());
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background-pink.jpg'),
              // image: AssetImage('assets/background.gif'),
              // image: AssetImage('assets/blue_background.gif'),
              opacity: 1,
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: searchPageHeader(),
          body: searchController.courseList.isEmpty ? displayNoSearchResultScreen() : SearchResult(),
        ),
      ),
    );
  }
}

controlSearching(str) {}

searchPageHeader() {
  return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
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
                fillColor: Colors.white,
                hintText: "코스를 검색해보세요",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                filled: true,
                prefixIcon: IconButton(
                    icon: Icon(Icons.tune),
                    color: Colors.blue,
                    iconSize: 25,
                    onPressed: () {
                      Get.to(() => SearchFilter());
                    }),
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
              ),
              style: TextStyle(fontSize: 14, color: Colors.black),
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
                        child: Text('방문여부', style: TextStyle(color: Colors.black, fontSize: 14)),
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
          child: Text('최신순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
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
          child: Text('인기순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ),
      ],
    ),
  );
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
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // 스크롤이 리스트의 끝까지 도달하면 다음 검색 결과 호출
        searchController.getNextSearchResults();
      }
    });
    return Obx(() => Container(
          color: Colors.transparent,
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
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(33, 0, 0, 0), blurRadius: 4, spreadRadius: 3, offset: Offset(0, 3)),
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
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                                child: Icon(Icons.check, size: 12, color: Colors.white),
                              ),
                              Text("방문", style: TextStyle(color: Colors.white, fontSize: 10)),
                              SizedBox(width: 7),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                if (searchController.courseList[index]["interest"])
                  Icon(Icons.bookmark, size: 24, color: Colors.green[800]),
                if (!searchController.courseList[index]["interest"])
                  Icon(Icons.bookmark_outline_rounded, size: 24, color: Colors.green[800]),
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
              "${searchController.courseList[index]['content']}",
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
            ),
            SizedBox(height: 5),
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
                          Icon(Icons.favorite, size: 14, color: Colors.pink[300]),
                        if (!searchController.courseList[index]["like"])
                          Icon(Icons.favorite_border_outlined, size: 14, color: Colors.pink[300]),
                        SizedBox(width: 3),
                        Text(searchController.courseList[index]["likeCount"].toString(),
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(Icons.comment, size: 14),
                        SizedBox(width: 3),
                        Text(searchController.courseList[index]["commentCount"].toString(),
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
