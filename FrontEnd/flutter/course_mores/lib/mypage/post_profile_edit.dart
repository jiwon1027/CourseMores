import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as g;
import '../main.dart' as main;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

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

String baseURL = dotenv.get('BASE_URL');

final options = BaseOptions(baseUrl: baseURL);
final dio = Dio(options);

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

void postProfileEdit(nickname, age, gender, image, aToken) async {
  FormData formData;
  if (image != null) {
    formData = FormData.fromMap({
      'userInfoUpdateReqDto': MultipartFile.fromString(
          jsonEncode({'nickname': nickname, 'age': age, 'gender': gender}),
          contentType: MediaType.parse('application/json')),
      'profileImage': await MultipartFile.fromFile(image.path,
          contentType: MediaType("image", "jpg")),
    });
  } else {
    formData = FormData.fromMap({
      'userInfoUpdateReqDto': MultipartFile.fromString(
          jsonEncode({'nickname': nickname, 'age': age, 'gender': gender}),
          contentType: MediaType.parse('application/json')),
      'profileImage': null,
    });
  }
  try {
    final response = await dio.put('profile/5',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $aToken',
            'Content-Type': 'multipart/form-data',
          },
        ));
    if (response.statusCode == 200) {
      g.Get.to(main.MyApp());
      print('수정!!!');
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
