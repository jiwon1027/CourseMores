import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'search.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 65,
        title: Column(
          children: [
            SizedBox(
              height: 65,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: searchTextEditingController,
                      onChanged: (_) {
                        searchController.changeWord(word: searchTextEditingController.text);
                        searchController.getElasticList();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 24), // TextField의 높이 조정
                        hintText: "코스를 검색해보세요",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_rounded)),
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
                                searchController.changePage(page: 0);
                                searchController.isSearchResults.value = true;
                                searchController.searchCourse();
                              },
                            ),
                          ],
                        ),
                      ),
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      onSubmitted: controlSearching,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: searchController.elasticMap.keys.toList().length,
                itemBuilder: (context, index) {
                  var keys = searchController.elasticMap.keys.toList();
                  var key = keys[index];
                  return ListTile(
                    leading: ElasticIcon(value: searchController.elasticMap[key][0]),
                    title: Text(key),
                    onTap: () {
                      searchController.changePage(page: 0);
                      FocusScope.of(context).unfocus(); // 키보드 닫기
                      searchTextEditingController.text = key;
                      searchController.changeWord(word: key);
                      searchTextEditingController.selection = TextSelection.fromPosition(
                        TextPosition(offset: key.length),
                      );
                      Get.back();
                      pageController.changePageNum(2);
                      searchController.searchCourse();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElasticIcon extends StatelessWidget {
  const ElasticIcon({super.key, required this.value});
  final value;

  @override
  Widget build(BuildContext context) {
    switch (value) {
      case 1:
        return Icon(Icons.route_outlined);
      case 2:
        return Icon(Icons.location_pin);
      case 3:
        return Icon(Icons.tag);

      default:
        return Icon(Icons.location_pin);
    }
  }
}
