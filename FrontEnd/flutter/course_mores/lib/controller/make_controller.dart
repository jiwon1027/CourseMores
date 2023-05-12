import 'package:get/get.dart' as g;
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import '../auth/auth_dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

// 코스 작성하는 getX controller
class CourseController extends g.GetxController {
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

  // List<XFile> getCombinedImages() {
  //   final List<XFile> combinedImages = [];
  //   for (final locationData in locationList) {
  //     combinedImages.addAll(locationData.temporaryImageList);
  //   }
  //   return combinedImages;
  // }
  List<XFile> getCombinedImages() {
    List<XFile> combinedImages = [];
    for (var location in locationList) {
      combinedImages.addAll(location._temporaryImageList);
    }
    return combinedImages;
  }

  void postCourse() async {
    // final url = 'https://coursemores.site/api/course/1';
    // final url = 'https://coursemores.site/api/course/';
    final List<Map<String, dynamic>> locationDataList = [];
    FormData formData;

    final List<XFile> combinedImages = getCombinedImages();

    // locationList의 데이터를 LocationCreateReqDto로 변환
    for (final locationData in locationList) {
      locationDataList.add({
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
        'name': locationData.name,
        'title': locationData.title,
        'content': locationData.content,
        'sido': locationData.sido,
        'gugun': locationData.gugun,
        'roadViewImage': locationData.roadViewImage,
        'numberOfImage': locationData.numberOfImage,
      });
    }

    // FormData에서 imageList를 생성
    List<MultipartFile> imageFileList = [];
    int imageIndex = 0;
    for (var locationData in locationList) {
      for (var i = 0; i < locationData.numberOfImage; i++) {
        imageFileList.add(await MultipartFile.fromFile(
          combinedImages[imageIndex++].path,
          contentType: MediaType("image", "jpg"),
        ));
      }
    }

    // 출력확인
    print(locationDataList);
    print('11111111111111');
    print(combinedImages);

    // 이미지가 없는 경우
    if (imageFileList.isEmpty) {
      formData = FormData.fromMap({
        'courseCreateReqDto': MultipartFile.fromString(
          jsonEncode({
            'title': title.value,
            'content': content.value,
            'people': people.value,
            'time': time.value,
            'visited': visited.value,
            'locationList': locationDataList,
            'hashtagList': hashtagList,
            'themeIdList': themeIdList,
          }),
          contentType: MediaType.parse('application/json'),
        ),
        'imageList': null,
      });
    } else {
      // 이미지가 있는 경우
      formData = FormData.fromMap({
        'courseCreateReqDto': MultipartFile.fromString(
          jsonEncode({
            'title': title.value,
            'content': content.value,
            'people': people.value,
            'time': time.value,
            'visited': visited.value,
            'locationList': locationDataList,
            'hashtagList': hashtagList,
            'themeIdList': themeIdList,
          }),
          contentType: MediaType.parse('application/json'),
        ),
        'imageList': imageFileList,
      });
    }

    // 출력확인
    print(formData.fields);
    print(formData.files);

    try {
      final dio = await authDio();
      final response = await dio.post("course",
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ));
      if (response.statusCode == 200) {
        print('POST 요청 성공');
      }
    } catch (e) {
      if (e is DioError) {
        print('Dio Error Status Code: ${e.response?.statusCode}');
        print('Dio Error Message: ${e.response?.statusMessage}');
        print('Dio Server Error Message: ${e.response?.data}');
      } else {
        // DioError가 아닌 다른 예외 처리
      }
    }
  }
}
//////////

// 코스 작성시 장소 개별 getX controller
class LocationController extends g.GetxController {
  final CourseController courseController =
      g.Get.find(); // GetX에서 CourseController 가져오기

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

  LocationData getLocationDataByIndex(int index) {
    return courseController.locationList[index];
  }

  // other methods for managing data
  void incrementNumberOfImage() {
    if (numberOfImage.value < 5) {
      numberOfImage.value++;
    }
  }

  void decrementNumberOfImage() {
    if (numberOfImage.value > 0) {
      numberOfImage.value--;
    }
  }
}

class LocationData {
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
  final List<XFile> _temporaryImageList; // 추가된 부분

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
  }) : _temporaryImageList = []; // 추가된 부분

  List<XFile> get temporaryImageList => _temporaryImageList; // 추가된 부분

  void addTemporaryImage(XFile image) {
    _temporaryImageList.add(image);
  }

  void removeTemporaryImage(XFile image) {
    _temporaryImageList.remove(image);
  }

  void clearTemporaryImages() {
    _temporaryImageList.clear();
  }
}
