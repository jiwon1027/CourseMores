import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as g;
import 'main.dart' as main;
import 'dart:convert';
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

class UserInfoCreateReqDto {
  final String nickname;
  final int age;
  final String gender;

  UserInfoCreateReqDto(this.nickname, this.age, this.gender);
  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'age': age,
        'gender': gender,
      };
}

void postSignUp(nickname, age, gender, image, aToken) async {
  UserInfoCreateReqDto userInfoCreateReqDto =
      UserInfoCreateReqDto(nickname, age, gender);
  FormData formData = FormData.fromMap({
    'userInfoCreateReqDto': userInfoCreateReqDto.toJson(),
    // 'userInfoCreateReqDto': jsonEncode(userInfoCreateReqDto),
    'profileImage': await MultipartFile.fromFile(image.path),
  });
  print('이상민ㄴㄴㄴㄴㄴㄴ');
  print(formData);
  final response = await dio.post('user/signup',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $aToken',
          'Content-Type': 'multipart/form-data',
        },
        // contentType: 'multipart/form-data',
      ));
  if (response.statusCode == 200) {
    g.Get.to(main.MyApp());
    print('가입성공!!!');
  }
}
