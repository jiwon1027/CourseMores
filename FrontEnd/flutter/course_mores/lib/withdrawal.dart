import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as g;

String baseURL = dotenv.get('BASE_URL');

final options = BaseOptions(baseUrl: baseURL);
final dio = Dio(options);

void withdrawal(aToken) {
  try {
    dio.delete('profile/6',
        options: Options(
          headers: {
            'Authorization': 'Bearer $aToken',
          },
        ));
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
