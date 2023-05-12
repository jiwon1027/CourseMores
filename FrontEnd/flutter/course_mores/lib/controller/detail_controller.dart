import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../auth/auth_dio.dart';

class DetailController extends GetxController {
  RxInt nowIndex = 0.obs;
  RxMap<String, dynamic> nowCourseInfo = <String, dynamic>{
    "title": "",
    "content": "",
    "people": 0,
    "time": 0,
    "visited": false,
    "viewCount": 0,
    "likeCount": 0,
    "interestCount": 0,
    "commentCount": 0,
    "sido": "",
    "gugun": "",
    "createTime": "",
    "hashtagList": [],
    "themeList": [],
    "simpleInfoOfWriter": {"nickname": "", "profileImage": "default"}
  }.obs;
  RxList<Map<String, dynamic>> nowCourseDetail = [
    {
      "name": "",
      "title": "",
      "content": "",
      "latitude": 0,
      "longitude": 0,
      "sido": "",
      "gugun": "",
      "roadViewImage": "",
      "locationImageList": [{}]
    }
  ].obs;
  RxBool isLikeCourse = false.obs;
  RxBool isInterestCourse = false.obs;

  RxInt placeIndex = 0.obs;

  final selectedSegment = ValueNotifier('코스 소개');
  final segments = {'코스 소개': '코스 소개', '코스 상세': '코스 상세', '코멘트': '코멘트'};

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  RxList<LatLng> markerPositions = [
    // LatLng(37.5665, 126.9780), // 서울역
    // LatLng(37.5547, 126.9707), // 광화문
    // LatLng(37.5719, 126.9768), // 종로3가
    // LatLng(37.5659, 126.9774), // 시청
    // LatLng(37.5702, 126.9832), // 청계천
    LatLng(37.5033214, 127.0384099), // 이도곰탕
    LatLng(37.5032488, 127.0387016), // 역삼 상도
    LatLng(37.5025164, 127.0372225), // 조선부뚜막 역삼점
    LatLng(37.501945, 127.0360264), // 한앤둘치킨 역삼점
    LatLng(37.4996299, 127.0358136), // 바스버거 역삼점
  ].obs;

  Future changeNowIndex(int index) async {
    try {
      nowIndex.value = index;
    } catch (e) {
      print(e);
    }
  }

  Future changePlaceIndex(int index) async {
    try {
      placeIndex.value = index;
    } catch (e) {
      print(e);
    }
  }

  Future getCourseInfo() async {
    try {
      final dio = await authDio();
      final response = await dio.get("course/info/${nowIndex.value}");

      // 응답 처리
      if (response.statusCode == 200) {
        dynamic data = response.data;
        nowCourseInfo.value = RxMap<String, dynamic>.from(data['courseInfo']);
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCourseDetailList() async {
    try {
      final dio = await authDio();
      final response = await dio.get("course/detail/${nowIndex.value}");

      // 응답 처리
      if (response.statusCode == 200) {
        dynamic data = response.data;
        nowCourseDetail = RxList.from(data['courseDetailList']);
        List<LatLng> latlng = nowCourseDetail.map((item) {
          double latitude = item['latitude'] as double;
          double longitude = item['longitude'] as double;

          return LatLng(latitude, longitude);
        }).toList();

        markerPositions = latlng.obs;
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  Future getIsLikeCourse() async {
    try {
      final dio = await authDio();
      final response = await dio.get("like/course/${nowIndex.value}");

      // 응답 처리
      if (response.statusCode == 200) {
        dynamic data = response.data;
        isLikeCourse.value = data['isLikeCourse'];
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  Future addIsLikeCourse() async {
    try {
      final dio = await authDio();
      await dio.post("like/course/${nowIndex.value}");

      isLikeCourse.value = true;
      nowCourseInfo['likeCount']++;
    } catch (e) {
      print(e);
    }
  }

  Future deleteIsLikeCourse() async {
    try {
      final dio = await authDio();
      await dio.delete("like/course/${nowIndex.value}");

      isLikeCourse.value = false;
      nowCourseInfo['likeCount']--;
    } catch (e) {
      print(e);
    }
  }

  Future getIsInterestCourse() async {
    try {
      final dio = await authDio();
      final response = await dio.get("interest/course/${nowIndex.value}");

      // 응답 처리
      if (response.statusCode == 200) {
        dynamic data = response.data;
        isInterestCourse.value = data['isInterestCourse'];
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  Future addIsInterestCourse() async {
    try {
      final dio = await authDio();
      await dio.post("interest/course/${nowIndex.value}");

      isInterestCourse.value = true;
      nowCourseInfo['interestCount']++;
    } catch (e) {
      print(e);
    }
  }

  Future deleteIsInterestCourse() async {
    try {
      final dio = await authDio();
      await dio.delete("interest/course/${nowIndex.value}");

      isInterestCourse.value = false;
      nowCourseInfo['interestCount']--;
    } catch (e) {
      print(e);
    }
  }
}
