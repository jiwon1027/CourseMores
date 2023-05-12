import 'package:coursemores/auth/auth_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';

import '../course_search/search.dart';

class SearchController extends GetxController {
  RxString userId = "4".obs;
  // courseList: 코스 정보를 담을 상태 변수
  final RxList<Map<String, dynamic>> courseList = <Map<String, dynamic>>[].obs;

  // sidoList : 시도 리스트, gugunList : 구군 리스트 -> 드롭박스와 형식이 안 맞아서 지역번호와 이름 둘 다 저장함
  final RxList<String> sidoList = <String>[].obs;
  final RxList<Map<String, dynamic>> gugunList = <Map<String, dynamic>>[
    {"regionId": 0, "gugun": "전체"}
  ].obs;

  // selectedThemeList : 바뀌고 있는 테마 임시 리스트 (저장 안 됨)
  // savedSelectedThemeList : 저장버튼을 누를 때만 바뀌는 테마 저장 리스트
  RxList<dynamic> selectedThemeList = <dynamic>[].obs;
  RxList<dynamic> savedSelectedThemeList = <dynamic>[].obs;

  // themeList: 불러온 테마 리스트를 저장
  RxList<Map<String, dynamic>> themeList = <Map<String, dynamic>>[].obs;

  // selectedAddress : 바뀌고 있는 주소 임시 리스트 (저장 안 됨)
  // savedSelectedAddress : 저장버튼을 누를 때만 바뀌는 주소 저장 리스트
  RxMap<String, dynamic> selectedAddress = {'sido': "전체", 'gugun': "전체", 'regionId': 0}.obs;
  RxMap<String, dynamic> savedSelectedAddress = {'sido': "전체", 'gugun': "전체", 'regionId': 0}.obs;

  // isVisited : 검색 설정 중 방문여부 체크 (true이면 체크되도록 쓰는 용도)
  // isSearchResults : 검색 전이거나 검색 결과가 없을 때의 화면을 보여줄지 체크
  // isLatestSelected : 검색 설정 중 최신순 정렬이 눌렸는지 체크 (true이면 색이 바뀌도록 쓰는 용도)
  // isPopularSelected : 검색 설정 중 인기순 정렬이 눌렸는지 체크 (true이면 색이 바뀌도록 쓰는 용도)
  final RxBool isVisited = false.obs;
  RxBool isSearchResults = false.obs;
  RxBool isLatestSelected = true.obs;
  RxBool isPopularSelected = false.obs;

  // nowCourseId : 상세 페이지로 갈 때 어떤 코스인지 저장하는 요소
  RxInt nowCourseId = 0.obs;

  // 필터 화면에서 보여줄 테마 리스트 요소들
  RxList<MultiSelectCard> cards = <MultiSelectCard>[].obs;

  // queryParameters : searchCourse 시 사용하는 쿼리 파라미터
  final RxMap<String, dynamic> queryParameters = <String, dynamic>{
    'word': "",
    'regionId': 0,
    'themeIds': [0],
    'isVisited': 0,
    'page': 0,
    'sortby': 'latest',
  }.obs;

  // getThemeList : 초기 1회 실행되는 테마 불러오기
  Future getThemeList() async {
    try {
      final dio = await authDio();
      final response = await dio.get("theme");

      // 응답 처리
      if (response.statusCode == 200) {
        // 요청이 성공한 경우
        dynamic data = response.data;
        // 데이터 처리
        themeList.value = RxList<Map<String, dynamic>>.from(data['themeList']);
        settingCard();
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  // TODO: 지역 중 충북 -> 하위 단계까지 노출됨. 청주시와 서원구가 같이 보임
  // getSidoList : 초기 1회 실행되는 지역 대분류 불러오기
  Future getSidoList() async {
    try {
      final dio = await authDio();
      final response = await dio.get("region");

      // 응답 처리
      if (response.statusCode == 200) {
        // 요청이 성공한 경우
        dynamic data = response.data;
        // 데이터 처리
        sidoList.value = RxList<String>.from(data['sidoList']);
        selectedAddress['sido'] = savedSelectedAddress['sido'];
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  // getGugunList : 대분류 선택 시 실행되는 지역 소분류 불러오기
  Future getGugunList() async {
    try {
      final dio = await authDio();
      final response = await dio.get("region/${selectedAddress['sido']}");

      // 응답 처리
      if (response.statusCode == 200) {
        // 요청이 성공한 경우
        dynamic data = await response.data;
        // 데이터 처리
        gugunList.value = RxList<Map<String, dynamic>>.from(data['gugunList']);
        selectedAddress['gugun'] = await gugunList[0]['gugun'];
        selectedAddress['regionId'] = await gugunList[0]['regionId'];
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  // TODO: 검색창에 입력을 할 때는 자동완성으로 api를 보내야 하고 검색버튼을 눌렀을 때에만 searchCourse()를 보내야 함
  // searchCourse : 방문여부 수정, 정렬 수정, 검색 버튼 클릭 시 실행되는 코스 검색
  Future searchCourse() async {
    try {
      // GET 요청 보내기
      final dio = await authDio();
      final response = await dio.get("course/search/$userId", queryParameters: queryParameters);

      // 응답 처리
      if (response.statusCode == 200) {
        // 요청이 성공한 경우
        dynamic data = response.data;
        // 데이터 처리
        courseList.value = RxList<Map<String, dynamic>>.from(data['courseList']);
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      // 네트워크 오류 또는 기타 예외 발생
      // 에러 처리
      print(e);
    }
  }

  // changeWord : 쿼리 파라미터의 word 값 수정
  Future changeWord({required String word}) async {
    try {
      queryParameters['word'] = word;
    } catch (e) {
      print(e);
    }
  }

  // changeSido : 쿼리 파라미터의 sido 값 수정
  Future changeSido({required sido}) async {
    try {
      selectedAddress['sido'] = sido;

      if (selectedAddress['sido'] != "전체") {
        getGugunList();
      } else {
        gugunList.value = RxList<Map<String, dynamic>>.from([
          {"regionId": 0, "gugun": "전체"}
        ]);
        changeGugun(gugun: "전체");
      }
    } catch (e) {
      print(e);
    }
  }

  // changeGugun : 쿼리 파라미터의 gugun 값 수정
  Future changeGugun({required String gugun}) async {
    try {
      selectedAddress['gugun'] = gugun;

      // 선택된 regionId에 해당하는 gugun 값을 찾음
      for (var item in gugunList) {
        if (item['gugun'] == selectedAddress['gugun']) {
          selectedAddress['regionId'] = item['regionId'];
          break;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // changeThemeIds : 쿼리 파라미터의 themeIds 값 수정
  Future changeThemeIds({required List<dynamic> themeIds}) async {
    try {
      queryParameters['themeIds'] = themeIds;
    } catch (e) {
      print(e);
    }
  }

  // changeIsVisited : 쿼리 파라미터의 isVisited 값과 체크 표시에 쓰는 isVisited 값 수정
  Future changeIsVisited() async {
    try {
      isVisited.value = !isVisited.value;
      queryParameters['isVisited'] = isVisited.value ? 1 : 0;
      searchCourse();
    } catch (e) {
      print(e);
    }
  }

  // changePage : 쿼리 파라미터의 page 값 수정
  Future changePage({required int page}) async {
    try {
      queryParameters['page'] = page;
    } catch (e) {
      print(e);
    }
  }

  // changeSortby : 쿼리 파라미터의 sortby 값 수정
  Future changeSortby({required String sortby}) async {
    try {
      queryParameters['sortby'] = sortby;
      searchCourse();
    } catch (e) {
      print(e);
    }
  }

  // changeSelectedThemeList : selectedThemeList에 담기는 선택된 테마 수정
  Future changeSelectedThemeList({required RxList<dynamic> list}) async {
    try {
      selectedThemeList = list;
      searchCourse();
    } catch (e) {
      print(e);
    }
  }

  // changeSelectedThemeList : selectedThemeList에 담기는 선택된 테마 수정
  Future changeNowCourseId({required int courseId}) async {
    try {
      nowCourseId.value = courseId;
      detailController.changeNowIndex(nowCourseId.value);
      print("nowCourseId= $nowCourseId");
    } catch (e) {
      print(e);
    }
  }

  // saveFilter : 임시로 변경되어 있는 필터 값을 저장해서 적용 (저장 버튼)
  Future saveFilter() async {
    try {
      savedSelectedAddress = selectedAddress;
      savedSelectedThemeList = selectedThemeList;
      queryParameters['regionId'] = savedSelectedAddress['regionId'];
      queryParameters['themeIds'] = savedSelectedThemeList;
    } catch (e) {
      print(e);
    }
  }

  // resetFilter : 보여지는 필터 값을 초기화함, 아직 저장한 건 아님 (초기화 버튼)
  Future resetFilter() async {
    try {
      savedSelectedAddress = {'sido': "전체", 'gugun': "전체", 'regionId': 0}.obs;
      selectedAddress = {'sido': "전체", 'gugun': "전체", 'regionId': 0}.obs;
      savedSelectedThemeList = <dynamic>[].obs;
      queryParameters['regionId'] = savedSelectedAddress['regionId'];
      queryParameters['themeIds'] = <dynamic>[].obs;
    } catch (e) {
      print(e);
    }
  }

  // settingCard : 테마 리스트를 카드로 만들어 칩처럼 만듦
  Future settingCard() async {
    try {
      cards = <MultiSelectCard>[].obs;
      for (var theme in themeList) {
        var card = MultiSelectCard(
          value: theme['themeId'],
          label: theme['name'],
          selected: savedSelectedThemeList.contains(theme['themeId']),
          decorations: MultiSelectItemDecorations(
            // 선택 전 테마 스타일
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 3, offset: const Offset(0, 2))
              ],
            ),
            // 선택된 테마 스타일
            selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 115, 81, 255),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 3, offset: const Offset(0, 2))
              ],
            ),
          ),
        );
        cards.add(card);
      }
    } catch (e) {
      print(e);
    }
  }
}
