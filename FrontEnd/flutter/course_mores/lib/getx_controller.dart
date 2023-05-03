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

// class UserInfo extends GetxController{
//   final 
// }

