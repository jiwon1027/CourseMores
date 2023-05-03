import 'package:coursemores/getx_controller.dart';
import 'package:coursemores/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'sign_up.dart' as signup;
import 'home_screen.dart' as home;
import 'main.dart' as main;
import 'package:dio/dio.dart';

var options = BaseOptions(baseUrl: 'https://coursemores.site/api/');
final dio = Dio(options);
final tokenController = Get.put(TokenStorage());

void postLogin(accessToken) async {
  print(accessToken);

  dynamic bodyData = {'accessToken': accessToken};
  print(bodyData);

  final response = await dio.post('auth/kakao/login', data: bodyData);

  print(response);

  if (response.statusCode == 200) {
    // 추후에 issignup으로 교체
    if (response.data['userSimpleInfo'] == null) {
      tokenController.saveToken(response.data['token']['accessToken'],
          response.data['token']['refreshToken']);
      Get.to(signup.SignUp());
    } else {
      Get.to(main.MyApp());
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  // const BASE_URL = 'https://coursemores.site/api/';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.gif'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(
                    'Course',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'Mores',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              loginController.changeLoginStatus();
                              Get.to(
                                main.MyApp(),
                                transition: Transition.fadeIn,
                              );
                            },
                            child: Text(
                              '로그인된척하기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        InkWell(
                          onTap: () async {
                            bool isKakaoInstalled =
                                await isKakaoTalkInstalled();
                            OAuthToken? token;
                            // UserService userService = UserService();

                            if (isKakaoInstalled) {
                              try {
                                token =
                                    await UserApi.instance.loginWithKakaoTalk();
                                debugPrint('카카오톡으로 로그인 성공');
                              } catch (error) {
                                debugPrint('카톡로그인 실패 $error');
                                if (error is PlatformException &&
                                    error.code == 'CANCELED') {
                                  return;
                                }
                                try {
                                  token = await UserApi.instance
                                      .loginWithKakaoAccount();
                                  debugPrint('카카오계정로그인 성공');
                                } catch (error) {
                                  debugPrint('카카오계정로그인 실패 $error');
                                }
                              }
                            } else {
                              try {
                                token = await UserApi.instance
                                    .loginWithKakaoAccount();
                                debugPrint('카카오계정 로그인 성공');
                              } catch (error) {
                                debugPrint('카카오계정 로그인 실패 $error');
                              }
                            }

                            if (token != null) {
                              print(token);
                              postLogin(token.accessToken);
                              // Map<String, dynamic>? response =
                              //     await userService.signInByKakaoToken(token.accessToken);
                            }
                          },
                          child: Image(
                            image: AssetImage('assets/kakao.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                              width: 180,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const signup.SignUp(),
                                        ));
                                  },
                                  child: Text('회원가입'))),
                        ),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () {},
                    //   child: Image(
                    //     image: AssetImage('assets/google.png'),
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
