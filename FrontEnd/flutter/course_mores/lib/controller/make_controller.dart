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
    // 아래 코드를 추가하여 locationList에서 해당 location을 제거합니다.
    update(); // GetX의 갱신 메서드를 호출하여 화면을 업데이트합니다.
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
      combinedImages.addAll(location.temporaryImageList);
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
    print('2222222222');
    print(imageFileList);

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

  void modifyCourse(String? courseId) async {
    // final url = 'https://coursemores.site/api/course/1';
    // final url = 'https://coursemores.site/api/course/';
    final List<Map<String, dynamic>> locationDataList = [];
    FormData formData;

    final List<XFile> combinedImages = getCombinedImages();

    // locationList의 데이터를 LocationCreateReqDto로 변환
    for (final locationData in locationList) {
      locationDataList.add({
        'courseLocationId': locationData.courseLocationId,
        'name': locationData.name,
        'title': locationData.title,
        'content': locationData.content,
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
    print('2222222222');
    print(imageFileList);

    // 이미지가 없는 경우
    if (imageFileList.isEmpty) {
      formData = FormData.fromMap({
        'courseUpdateReqDto': MultipartFile.fromString(
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
        'courseUpdateReqDto': MultipartFile.fromString(
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
      final response = await dio.put('course/$courseId',
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ));
      if (response.statusCode == 200) {
        print('PUT 요청 성공');
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

/////////////////////////

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
  // final List<XFile> _temporaryImageList; // 추가된 부분
  final List<XFile> temporaryImageList;
  final List<XFile> savedImageList = [];
  int? courseLocationId; // courseLocationId를 nullable로 변경

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
    required this.temporaryImageList,
    this.courseLocationId, // nullable로 변경
  });

  // List<XFile> get temporaryImageList => _temporaryImageList; // 추가된 부분

  // temporaryImageList의 이미지들을 저장합니다.
  // void saveImageList() {
  void saveImageList(List<XFile> imageList) {
    savedImageList.clear();
    savedImageList.addAll(temporaryImageList);
  }

  // savedImageList에서 이미지를 가져옵니다.
  List<XFile> getSavedImageList() {
    return savedImageList;
  }

  void addTemporaryImage(XFile image) {
    temporaryImageList.add(image);
  }

  void removeTemporaryImage(XFile image) {
    temporaryImageList.remove(image);
  }

  void clearTemporaryImages() {
    temporaryImageList.clear();
  }
}
