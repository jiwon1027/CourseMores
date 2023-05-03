import 'package:get/get.dart';

class LoginStatus extends GetxController {
  var isLoggedIn = false.obs;

  void changeLoginStatus() {
    isLoggedIn.value = !isLoggedIn.value;
  }
}
