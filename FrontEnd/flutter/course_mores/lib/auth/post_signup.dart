// import 'package:coursemores/mypage/post_profile_edit.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as g;
// import '../main.dart' as main;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../controller/getx_controller.dart';
import 'auth_dio.dart';
// void postSignUp(nickname, age, gender, image, aToken) async {
//   dynamic userInfoCreateReqDto = {
//     'nickname': nickname,
//     'age': age,
//     'gender': gender,
//   };
//   // FormData formData =
//   dynamic bodyData = json.encode({
//     'UserInfoCreateReqDto': userInfoCreateReqDto,
//     'profileImage': image,
//   });
//   final response = await dio.post('user/signup',
//       data: bodyData,
//       options: Options(headers: {'Authorization': 'Bearer $aToken'}));
//   if (response.statusCode == 200) {
//     Get.to(main.MyApp());
//     print('가입성공!!!');
//   }
// }

final loginController = g.Get.put(LoginStatus());

// class UserInfoCreateReqDto {
//   final String nickname;
//   final int age;
//   final String gender;

//   UserInfoCreateReqDto(this.nickname, this.age, this.gender);
//   Map<String, dynamic> toJson() => {
//         'nickname': nickname,
//         'age': age,
//         'gender': gender,
//       };
// }

void postSignUp(nickname, int age, gender, image, aToken) async {
  FormData formData;
  if (image != null) {
    formData = FormData.fromMap({
      'userInfoCreateReqDto': MultipartFile.fromString(jsonEncode({'nickname': nickname, 'age': age, 'gender': gender}),
          contentType: MediaType.parse('application/json')),
      'profileImage': await MultipartFile.fromFile(image.path, contentType: MediaType("image", "jpg")),
    });
  } else {
    formData = FormData.fromMap({
      'userInfoCreateReqDto': MultipartFile.fromString(jsonEncode({'nickname': nickname, 'age': age, 'gender': gender}),
          contentType: MediaType.parse('application/json')),
      'profileImage': null,
    });
  }

  try {
    final dio = await authDio();
    final response = await dio.post('user/signup',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ));

    if (response.statusCode == 200) {
      print('가입성공!!!');
      loginController.changeLoginStatus(true);
      g.Get.back();
      // g.Get.replace(main.MyApp());
    }
  } catch (e) {
    // DioError 처리
    if (e is DioError) {
      print('Dio Error Status Code: ${e.response?.statusCode}');
      print('Dio Error Message: ${e.response?.statusMessage}');
      print('Dio Server Error Message: ${e.response?.data}');
      // 추가적인 예외 처리 로직 구현
    } else {
      // DioError가 아닌 다른 예외 처리
    }
  }
}
