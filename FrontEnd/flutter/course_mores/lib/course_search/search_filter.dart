import 'package:coursemores/course_search/search.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // searchController.settingCard();

    searchController.getThemeList();
    searchController.getSidoList();

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background-pink.jpg'),
              // image: AssetImage('assets/background.gif'),
              // image: AssetImage('assets/blue_background.gif'),
              opacity: 1,
              fit: BoxFit.cover),
        ),
        child: DraggableHome(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text('검색 필터 설정', style: TextStyle(color: Colors.white))],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.transparent)),
          ],
          headerWidget: headerWidget(context),
          headerExpandedHeight: 0.3,
          body: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        // SizedBox(height: 80),
                        Text("지역을 선택해보세요 🗺", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        SearchFilterRegion(),
                        SizedBox(height: 30),
                        Text("테마를 선택해보세요 😊", style: TextStyle(fontSize: 18)),
                        // SizedBox(height: 10),
                        SearchFilterTheme(),
                        SizedBox(height: 20),
                        SearchFilterButtons(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          fullyStretchable: false,
          expandedBody: headerWidget(context),
          backgroundColor: Colors.white,
          appBarColor: Color.fromARGB(255, 80, 170, 208),
        ));
  }
}

class SearchFilterButtons extends StatelessWidget {
  const SearchFilterButtons({super.key});

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
            backgroundColor: Color.fromARGB(255, 169, 147, 255),
          ),
          onPressed: () {
            searchController.saveFilter();
            Get.back();
          },
          child: Text("저장", style: TextStyle(color: Colors.white)),
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
        wrapSettings: WrapSettings(alignment: WrapAlignment.center, spacing: 10, runSpacing: 15),
        alignments: MultiSelectAlignments(
            crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center),
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
                return DropdownMenuItem(value: value, child: Text(value, style: TextStyle(fontSize: 14)));
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
                  child: Text(value['gugun'] as String, style: TextStyle(fontSize: 14)),
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

Widget headerWidget(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color.fromARGB(255, 0, 90, 129),
          Color.fromARGB(232, 255, 218, 218),
        ],
        stops: const [0.0, 0.9],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("검색 필터 설정", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("지역과 테마 선택을 통해", style: TextStyle(fontSize: 14, color: Colors.white)),
        SizedBox(height: 10),
        Text("원하는 코스를 편리하게 검색할 수 있어요", style: TextStyle(fontSize: 14, color: Colors.white)),
      ],
    ),
  );
}
