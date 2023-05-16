import 'dart:convert';
import 'dart:io';

import 'package:coursemores/course_search/search.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide MultipartFile hide FormData;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import '../auth/auth_dio.dart';
import '../course_search/course_new_comment.dart';

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
    "write": false,
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
  RxList<Map<String, dynamic>> nowCourseCommentList =
      <Map<String, dynamic>>[].obs;
  RxBool isLikeCourse = false.obs;
  RxBool isInterestCourse = false.obs;

  RxInt placeIndex = 0.obs;

  // 불러올 페이지 넘버, 무한 스크롤 구현 시 ++하면서 불러오고, 새 코스 상세 페이지로 들어왔을 땐 0으로 초기화 필요
  RxInt commentPage = 0.obs;
  RxString commentSortBy = "Latest".obs;
  RxBool isCommentLatestSelected = true.obs;
  RxBool isCommentPopularSelected = false.obs;
  RxInt commentImageIndex = 0.obs;
  RxString directory = "/data/user/0/com.moham.coursemores/cache".obs;

  RxBool isCommentLoading = false.obs;

  RxList<File> imageList = <File>[].obs;
  RxList<File> addImageList = <File>[].obs;
  RxInt commentPeople = 0.obs;
  RxDouble sliderValue = 1.0.obs;
  final Map<double, String> peopleMapping = {
    0: '상관없음',
    1.0: '혼자',
    2.0: '2인',
    3.0: '3인',
    4.0: '4인',
    5.0: '5인 이상'
  };

  RxList<int> deleteImageList = <int>[].obs;

  final selectedSegment = ValueNotifier('코스 소개');
  final segments = {'코스 소개': '코스 소개', '코스 상세': '코스 상세', '코멘트': '코멘트'};

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  RxList<LatLng> markerPositions = [
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

  Future changeCommentImageIndex(int index) async {
    try {
      commentImageIndex.value = index;
    } catch (e) {
      print(e);
    }
  }

  Future changeCommentPage(int index) async {
    try {
      commentPage.value = index;
    } catch (e) {
      print(e);
    }
  }

  Future getCourseInfo(tap) async {
    try {
      final dio = await authDio();
      print(nowIndex);
      final response = await dio.get("course/info/${nowIndex.value}");

      // 응답 처리
      if (response.statusCode == 200) {
        dynamic data = response.data;
        nowCourseInfo.value = RxMap<String, dynamic>.from(data['courseInfo']);

        selectedSegment.value = tap ?? '코스 소개';

        await getIsLikeCourse();
        await getIsInterestCourse();
        await getCourseDetailList();
        changeCommentPage(0);
        await getCommentList();
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

  Future getCommentList() async {
    try {
      final dio = await authDio();
      final response = await dio.get(
          "comment/course/${nowIndex.value}?page=$commentPage&sortby=$commentSortBy");

      // 응답 처리
      if (response.statusCode == 200) {
        dynamic data = response.data;

        nowCourseCommentList.value =
            RxList<Map<String, dynamic>>.from(data['commentList']);

        detailController.commentPage++;
      } else {
        // 요청이 실패한 경우
        // 에러 처리
      }
    } catch (e) {
      print(e);
    }
  }

  // Future getIsLikeComment(index) async {
  //   try {
  //     final commentId = nowCourseCommentList[index]['commentId'];
  //     final dio = await authDio();
  //     final response = await dio.get("like/comment/$commentId");
  //     // 응답 처리
  //     if (response.statusCode == 200) {
  //       dynamic data = response.data;
  //       return data;
  //     } else {
  //       // 요청이 실패한 경우
  //       // 에러 처리
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future addIsLikeComment(index) async {
    try {
      final commentId = nowCourseCommentList[index]['commentId'];

      final dio = await authDio();
      await dio.post("like/comment/$commentId");

      nowCourseCommentList[index]['likeCount']++;
      nowCourseCommentList[index]['like'] = true;
    } catch (e) {
      print(e);
    }
  }

  Future deleteIsLikeComment(index) async {
    try {
      final commentId = nowCourseCommentList[index]['commentId'];

      final dio = await authDio();
      await dio.delete("like/comment/$commentId");

      nowCourseCommentList[index]['likeCount']--;
      nowCourseCommentList[index]['like'] = false;
    } catch (e) {
      print(e);
    }
  }

  Future isCommentLatestSelectedClick() async {
    isCommentLatestSelected.value = true;
    isCommentPopularSelected.value = false;
    commentSortBy.value = "Latest";
    await getCommentList();
  }

  Future isCommentPopularSelectedClick() async {
    isCommentLatestSelected.value = false;
    isCommentPopularSelected.value = true;
    commentSortBy.value = "Like";
    await getCommentList();
  }

  Future getImage() async {
    final picker = ImagePicker();
    const int maxImageCount = 5; // 최대 업로드 가능한 이미지 수

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (imageList.length < maxImageCount) {
        imageList.add(File(pickedFile.path));
        addImageList.add(File(pickedFile.path));
      } else {
        Fluttertoast.showToast(
          msg: "사진은 최대 5개까지만 업로드 가능해요.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
  }

  Future takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    imageList.add(File(imageFile.path));
    addImageList.add(File(imageFile.path));
  }

  Future removeImage(index) async {
    int deleteIndex =
        addImageList.indexWhere((item) => item.path == imageList[index].path);

    try {
      if (deleteIndex == -1) {
        deleteImageList.add(int.parse(imageList[index].path.substring(
              imageList[index].path.indexOf('/cache/') + 7,
              imageList[index].path.indexOf('.jpg'),
            )));
        imageList.remove(imageList[index]);
      } else {
        addImageList.removeAt(deleteIndex);
        imageList.remove(imageList[index]);
      }
    } catch (e) {
      print("오류발생!");
      print(e);
    }
  }

  Future showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('이미지 선택'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Get.back();
                takePicture();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(Icons.camera_alt, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('카메라'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Get.back();
                getImage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(Icons.image, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('갤러리'),
                ],
              ),
            ),
          ],
        );
      },
    );

    throw Exception('Error');
  }

  Future changeCommentPeople(int index) async {
    try {
      commentPeople.value = index;
    } catch (e) {
      print(e);
    }
  }

  Future changeSliderValue(double index) async {
    try {
      sliderValue.value = index;
      changeCommentPeople(sliderValue.toInt());
    } catch (e) {
      print(e);
    }
  }

  Future resetComment() async {
    textController.text = "";
    sliderValue.value = 1.0;
    commentPeople.value = 1;
    imageList.value = [];
    addImageList.value = [];
  }

  Future setComment(index) async {
    textController.text = await nowCourseCommentList[index]['content'];
    sliderValue.value = await nowCourseCommentList[index]['people'].toDouble();
    commentPeople.value = await nowCourseCommentList[index]['people'];
    imageList.value = [];
    addImageList.value = [];
    deleteImageList.value = [];

    for (final image in nowCourseCommentList[index]['imageList']) {
      final file = await downloadImage(image);
      imageList.add(file);
    }
  }

  Future addComment() async {
    FormData formData;

    if (imageList.isEmpty) {
      // 이미지가 없는 경우
      formData = FormData.fromMap({
        'commentCreateReqDTO': MultipartFile.fromString(
          jsonEncode(
              {'content': textController.text, 'people': commentPeople.value}),
          contentType: MediaType.parse('application/json'),
        ),
        'imageList': null,
      });
    } else {
      // 이미지가 있는 경우
      formData = FormData.fromMap({
        'commentCreateReqDTO': MultipartFile.fromString(
          jsonEncode(
              {'content': textController.text, 'people': commentPeople.value}),
          contentType: MediaType.parse('application/json'),
        ),
        'imageList': [
          for (final image in addImageList)
            await MultipartFile.fromFile(image.path,
                contentType: MediaType("image", "jpg")),
        ],
      });
    }

    print(formData);

    try {
      final dio = await authDio();
      final response = await dio.post('comment/course/$nowIndex',
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      if (response.statusCode == 200) {
        print('POST 요청 성공');
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
        print('Dio Error Status Code: ${e.response?.statusCode}');
        print('Dio Error Message: ${e.response?.statusMessage}');
        print('Dio Server Error Message: ${e.response?.data}');
      } else {
        // DioError가 아닌 다른 예외 처리
      }
    }
    await getCourseInfo("코멘트");

    await getCommentList();
    selectedSegment.value = "코멘트";
  }

  Future changeComment(index) async {
    final commentId = nowCourseCommentList[index]['commentId'];
    FormData formData;

    if (imageList.isEmpty) {
      // 이미지가 없는 경우
      formData = FormData.fromMap({
        'commentUpdateReqDTO': MultipartFile.fromString(
          jsonEncode({
            'content': textController.text,
            'people': commentPeople.value,
            'deleteImageList': deleteImageList
          }),
          contentType: MediaType.parse('application/json'),
        ),
        'imageList': null,
      });
    } else {
      // 이미지가 있는 경우
      formData = FormData.fromMap({
        'commentUpdateReqDTO': MultipartFile.fromString(
          jsonEncode({
            'content': textController.text,
            'people': commentPeople.value,
            'deleteImageList': deleteImageList
          }),
          contentType: MediaType.parse('application/json'),
        ),
        'imageList': [
          for (final image in addImageList)
            await MultipartFile.fromFile(image.path,
                contentType: MediaType("image", "jpg")),
        ],
      });
    }

    try {
      final dio = await authDio();
      final response = await dio.put('comment/$commentId',
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      if (response.statusCode == 200) {
        print('POST 요청 성공');
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
        print('Dio Error Status Code: ${e.response?.statusCode}');
        print('Dio Error Message: ${e.response?.statusMessage}');
        print('Dio Server Error Message: ${e.response?.data}');
      } else {
        // DioError가 아닌 다른 예외 처리
      }
    }
    await getCourseInfo("코멘트");
  }

  Future<File> downloadImage(image) async {
    final file = File('$directory/${image["commentImageId"]}.jpg');
    try {
      if (await file.exists()) {
        return file;
      } else {
        // 다운 안 된 사진만 다운로드
        final dio = Dio();
        final response = await dio.get(image['image'],
            options: Options(responseType: ResponseType.bytes));
        await file.writeAsBytes(response.data);

        return file;
      }
    } catch (e) {
      // 다운로드 실패 시 예외 처리
      print(e);
      return file;
    }
  }

  Future getDirectory() async {
    try {
      final directoryPath = await getTemporaryDirectory(); // 캐시 디렉토리 가져오기
      directory.value = directoryPath.path;
    } catch (e) {
      // 다운로드 실패 시 예외 처리
      rethrow;
    }
  }

  Future deleteComment(index) async {
    final commentId = nowCourseCommentList[index]['commentId'];

    final dio = await authDio();
    await dio.delete("comment/$commentId");

    getCourseInfo("코멘트");
    selectedSegment.value = "코멘트";
    throw Exception('Error');
  }

  void getNextCommentResults() async {
    if (isCommentLoading.value) return; // 이미 로딩 중이면 중복 호출 방지

    final RxList<Map<String, dynamic>> newCourseCommentList =
        RxList.from(nowCourseCommentList);

    // 로딩 상태 설정
    isCommentLoading.value = true;

    await detailController.getCommentList().then((_) {
      isCommentLoading.value = false;
    });

    newCourseCommentList
        .addAll([...nowCourseCommentList]); // 기존 검색 결과와 새로운 결과를 병합
    nowCourseCommentList.value = newCourseCommentList;
  }
}
