import '../controller/getx_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

String baseURL = dotenv.get('BASE_URL');
final authController = Get.put(AuthController());
final tokenStorage = Get.put(TokenStorage());

Future<Dio> authDio() async {
  var dio = Dio();

  dio.options.baseUrl = baseURL;
  dio.interceptors.clear();
  print("토큰이 있니?");
  print(tokenStorage.accessToken);
  print("그렇구나");
  if (tokenStorage.accessToken.isEmpty) {
    print("accessToken is [Empty]!");
    return dio;
  }
  print("accessToken is [Extist]!");
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    final accessToken = tokenStorage.accessToken.value;

    // 매 요청마다 헤더에 AccessToken을 포함
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.response?.statusCode == 401) {
      // 기기에 저장된 AccessToken과 RefreshToken 로드
      final accessToken = tokenStorage.accessToken.value;
      final refreshToken = tokenStorage.refreshToken.value;

      // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
      var refreshDio = Dio();
      // base url 설정해놓기

      refreshDio.options.baseUrl = baseURL;
      refreshDio.interceptors.clear();
      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        // 다시 인증 오류가 발생했을 경우: RefreshToken의 만료
        if (error.response?.statusCode == 401) {
          // 기기의 자동 로그인 정보 삭제
          authController.logout();

          // 로그인 페이지로 이동
          print("RefreshToken 만료!! 로그인을 다시 해주세요!!");
        }
        return handler.next(error);
      }));

      // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
      var tokenReissueReqDto = json
          .encode({"accessToken": accessToken, "refreshToken": refreshToken});

      print("토큰 재요청!!");
      print(tokenReissueReqDto);
      // 토큰 갱신 API 요청
      final refreshResponse =
          await refreshDio.post('/user/reissue', data: tokenReissueReqDto);

      // response로부터 새로 갱신된 AccessToken과 RefreshToken 파싱
      print("재발급 accessToken!! ");
      print(refreshResponse.data);
      print(refreshResponse.data['accessToken']);
      final newAccessToken = refreshResponse.data['accessToken'];

      // 기기에 저장된 AccessToken과 RefreshToken 갱신
      tokenStorage.saveToken(newAccessToken, refreshToken);

      // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      // 수행하지 못했던 API 요청 복사본 생성
      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      // API 복사본으로 재요청
      return handler.resolve(clonedRequest);
    }

    return handler.next(error);
  }));

  return dio;
}
