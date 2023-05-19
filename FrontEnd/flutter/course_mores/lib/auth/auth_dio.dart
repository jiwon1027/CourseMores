import '../controller/getx_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseURL = dotenv.get('BASE_URL');
final authController = Get.put(AuthController());
final tokenStorage = Get.put(TokenStorage());

Future<Dio> authDio() async {
  var dio = Dio();

  dio.options.baseUrl = baseURL;
  dio.interceptors.clear();

  if (tokenStorage.accessToken.isEmpty) {
    print("토큰이 필요없는 요청입니다.");
    return dio;
  }

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    final accessToken = tokenStorage.accessToken.value;

    // 매 요청마다 헤더에 AccessToken을 포함
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.response?.statusCode == 401) {
      authController.logout();
    }

    return handler.next(error);
  }));

  print("토큰을 헤더에 담은 요청입니다. [accessToken : ${tokenStorage.accessToken}]");

  return dio;
}
