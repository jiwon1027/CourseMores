import 'package:get/get.dart';

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
}

class UserInfo extends GetxController {
  final nickname = ''.obs;
  final gender = ''.obs;
  final age = 0.obs;
  final image = ''.obs;
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

  void saveImage(newImage) {
    image.value = newImage;
    print(image.value);
  }
}
