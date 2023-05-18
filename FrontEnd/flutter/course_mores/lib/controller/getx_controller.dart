import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseURL = dotenv.get('BASE_URL');

final options = BaseOptions(baseUrl: baseURL);
final dio = Dio(options);

class AuthController extends GetxController {
  final loginStatus = Get.put(LoginStatus());
  final pageNum = Get.put(PageNum());
  final tokenStorage = Get.put(TokenStorage());
  final userInfo = Get.put(UserInfo());
  final loginCheck = Get.put(LoginCheck());

  void logout() {
    loginStatus.changeLoginStatus(false);
    pageNum.changePageNum(0);
    tokenStorage.clearTokens();
    userInfo.clearUserInfo();
    loginCheck.clearFirstLogin();
  }
}

class LoginStatus extends GetxController {
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }

  void changeLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    this.isLoggedIn.value = isLoggedIn;
    print(this.isLoggedIn);
  }
}

class PageNum extends GetxController {
  final pageNum = 0.obs;

  void changePageNum(int newPageNum) {
    pageNum.value = newPageNum;
  }
}

class TokenStorage extends GetxController {
  final accessToken = ''.obs;
  // final refreshToken = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    accessToken.value = prefs.getString('accessToken') ?? '';
    // refreshToken.value = prefs.getString('refreshToken') ?? '';
  }

  Future<void> saveToken(String aToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', aToken);
    // await prefs.setString('refreshToken', rToken);
    accessToken.value = aToken;
    // refreshToken.value = rToken;
  }

  void clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    // await prefs.remove('refreshToken');
    accessToken.value = '';
    // refreshToken.value = '';
  }
}

class UserInfo extends GetxController {
  final nickname = 'default'.obs;
  final gender = 'default'.obs;
  final age = 0.obs;
  XFile? profileImage;
  final imageUrl = 'default'.obs;
  final isDeleteImage = false.obs;
  final editCheck = false.obs;
  final currentNickname = 'default'.obs;
  final signupCheck = false.obs;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    nickname.value = prefs.getString('nickname') ?? 'default';
    gender.value = prefs.getString('gender') ?? 'default';
    age.value = prefs.getInt('age') ?? 0;
    imageUrl.value = prefs.getString('imageUrl') ?? 'default';
    final imagePath = prefs.getString('profileImage');
    if (imagePath != null) {
      profileImage = XFile(imagePath);
    }
  }

  void saveCurrentNickname(value) async {
    currentNickname.value = value;
  }

  void changeSignupCheck(bool checked) async {
    signupCheck.value = checked;
  }

  void changeEditCheck(bool checked) async {
    editCheck.value = checked;
  }

  void imageIsDelete(bool isDelete) async {
    isDeleteImage.value = isDelete;
  }

  void saveNickname(newNickname) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nickname', newNickname);
    nickname.value = newNickname;
  }

  void saveGender(newGender) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', newGender);
    gender.value = newGender;
  }

  void saveAge(newAge) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('age', newAge);
    age.value = newAge;
  }

  void saveImage(XFile? image) async {
    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImage', image.path);
      profileImage = image;
    }
  }

  void saveImageUrl(newImageUrl) async {
    if (newImageUrl != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('imageUrl', newImageUrl);
      imageUrl.value = newImageUrl;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('imageUrl', 'default');
    }
  }

  void clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('nickname');
    prefs.remove('gender');
    prefs.remove('age');
    prefs.remove('profileImage');
    prefs.remove('imageUrl');
    nickname.value = 'default';
    gender.value = 'default';
    age.value = 0;
    profileImage = null;
    imageUrl.value = 'default';
  }
}

class MyPageInfo extends GetxController {
  var status = 'course';
  List<Map<String, Object>> myCourse = [];
  List<Map<String, Object>> myReview = [];

  void saveMyCourse(courseList) {
    myCourse = courseList;
  }

  void saveMyReview(reviewList) {
    myReview = reviewList;
  }

  void statusToReview() {
    status = 'review';
  }

  void statusToCourse() {
    status = 'course';
  }
}

class InterestedCourseInfo extends GetxController {
  List<Map<String, Object>> interestedCourse = [];

  void saveInterestedCourse(courseList) {
    interestedCourse = courseList;
  }
}

class HomeScreenInfo extends GetxController {
  List<Map<String, Object>> hotCourse = [];
  List<Map<String, Object>> nearCourse = [];

  void saveHotCourse(courseList) {
    hotCourse = courseList;
    // print('hotCourse불러오기');
    // print(hotCourse);
    update();
  }

  void saveNearCourse(courseList) {
    nearCourse = courseList;
    // print('nearCourse불러오기');
    // print(nearCourse);
    update();
  }
}

class LocationInfo extends GetxController {
  double latitude = 0.0;
  double longitude = 0.0;

  void saveLatitude(newLatitude) {
    latitude = newLatitude;
    print('컨트롤러에서 위도 갱신 => $latitude');
    update();
  }

  void saveLongitude(newLongitude) {
    longitude = newLongitude;
    print('컨트롤러에서 경도 갱신 => $longitude');
    update();
  }
}

class LoginCheck extends GetxController {
  var isFirstLogin = true;

  @override
  void onInit() async {
    super.onInit();
    final prefs = await SharedPreferences.getInstance();
    isFirstLogin = prefs.getBool('isFirstLogin') ?? true;
    // print('firstLogin?? $isFirstLogin');
  }

  void changeFirstLogin(bool changeTo) async {
    isFirstLogin = changeTo;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstLogin', changeTo);
    // print('firstLogin == $isFirstLogin');
  }

  void clearFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isFirstLogin');
    isFirstLogin = true;
    // print('firstLogin == $isFirstLogin');
  }
}
