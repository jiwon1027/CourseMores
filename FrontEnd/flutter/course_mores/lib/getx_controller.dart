import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseURL = dotenv.get('BASE_URL');

final options = BaseOptions(baseUrl: baseURL);
final dio = Dio(options);

class AuthController extends GetxController {
  final loginStatus = Get.put(LoginStatus());
  final pageNum = Get.put(PageNum());
  final tokenStorage = Get.put(TokenStorage());
  final userInfo = Get.put(UserInfo());

  void logout() {
    loginStatus.changeLoginStatus();
    pageNum.changePageNum(0);
    tokenStorage.clearTokens();
    userInfo.clearUserInfo();
  }
}

class LoginStatus extends GetxController {
  final isLoggedIn = false.obs;

  void changeLoginStatus() {
    isLoggedIn.value = !isLoggedIn.value;
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
  final refreshToken = ''.obs;
  void saveToken(aToken, rToken) {
    accessToken.value = aToken;
    refreshToken.value = rToken;
    print('토큰정보!!');
    print({accessToken, refreshToken});
  }

  void clearTokens() {
    accessToken.value = '';
    refreshToken.value = '';
  }
}

class UserInfo extends GetxController {
  final nickname = 'default'.obs;
  final gender = 'default'.obs;
  final age = 0.obs;
  // final image = ''.obs;
  XFile? profileImage;
  void saveNickname(newNickname) {
    nickname.value = newNickname;
    print(nickname.value);
  }

  void saveGender(newGender) {
    gender.value = newGender;
    print(gender.value);
  }

  void saveAge(newAge) {
    age.value = newAge;
    print(age.value);
  }

  void saveImage(XFile? image) {
    if (image != null) {
      profileImage = image;
      print(profileImage);
    }
  }

  void clearUserInfo() {
    nickname.value = '';
    gender.value = '';
    age.value = 0;
    profileImage = null;
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
