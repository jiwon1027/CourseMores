import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

// 코스 작성하는 getX controller
class CourseController extends GetxController {
  var title = ''.obs;
  var content = ''.obs;
  var people = 0.obs;
  var time = 0.obs;
  var visited = false.obs;

  var locationList = <LocationData>[].obs;
  var hashtagList = <String>[].obs;
  var themeIdList = <int>[].obs;

  void addLocation(LocationData location) {
    locationList.add(location);
  }

  void removeLocation(LocationData location) {
    locationList.remove(location);
  }

  void clearLocations() {
    locationList.clear();
  }

  void addHashtags(List<String> hashtags) {
    hashtagList.addAll(hashtags);
  }

  // other methods for managing data
}

// 코스 작성시 장소 개별 getX controller
class LocationController extends GetxController {
  final CourseController courseController =
      Get.find(); // GetX에서 CourseController 가져오기

  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var name = ''.obs;
  var title = ''.obs;
  var content = ''.obs;
  var sido = ''.obs;
  var gugun = ''.obs;

  var roadViewImage = ''.obs;
  var numberOfImage = 0.obs;

  void updateLocation(int index, LocationData location) {
    if (index >= 0 && index < courseController.locationList.length) {
      courseController.locationList[index] = location;
    }
  }

  void updateLocationData(LocationData locationData) {
    int index = courseController.locationList
        .indexWhere((data) => data.key == locationData.key);
    if (index != -1) {
      courseController.locationList[index] = locationData;
    }
  }

  LocationData? getLocationData(Key key) {
    final data = courseController.locationList
        .firstWhereOrNull((data) => data.key == key);
    if (data == null) {
      // 요소가 없는 경우 예외 처리
      print('No data found for the given key');
    }
    return data;
  }

  // LocationData? getLocationData(String key) {
  //   LocationData? data = courseController.locationList
  //       .firstWhereOrNull((data) => data.key == key);
  //   if (data == null) {
  //     // 요소가 없는 경우 예외 처리
  //     print('No data found for the given key');
  //   }
  //   return data;
  // }

  LocationData getLocationDataByIndex(int index) {
    return courseController.locationList[index];
  }

  // other methods for managing data
}

class LocationData {
  // late String key;
  late Key key;
  late String name;
  late double latitude;
  late double longitude;
  late String sido;
  late String gugun;
  late String roadViewImage;
  late int numberOfImage;
  String? title;
  String? content;

  LocationData({
    required this.key,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.roadViewImage = '',
    this.numberOfImage = 0,
    this.title = '',
    this.content = '',
    this.sido = '',
    this.gugun = '',
  });
  // LocationData({
  //   required this.key,
  //   required this.name,
  //   required this.latitude,
  //   required this.longitude,
  //   this.image = '',
  //   this.title = '',
  //   this.content = '',
  //   this.sido = '',
  //   this.gugun = '',
  // }) : key = UniqueKey();
}
