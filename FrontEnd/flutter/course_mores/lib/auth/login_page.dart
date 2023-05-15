import 'package:coursemores/controller/getx_controller.dart';
import 'package:coursemores/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'sign_up.dart' as signup;
// import '../home_screen/home_screen.dart' as home;
import '../main.dart' as main;
// import 'package:dio/dio.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'auth_dio.dart';

final tokenController = Get.put(TokenStorage());
final userInfoController = Get.put(UserInfo());
final firstLoginController = Get.put(LoginCheck());

void postLogin(accessToken) async {
  print(accessToken);
  print('555555555555');

  dynamic bodyData = json.encode({'accessToken': accessToken});
  print(bodyData);

  final response = await dio.post('auth/kakao/login', data: bodyData);

  print(response);

  if (response.statusCode == 200) {
    if (response.data['agree'] == false) {
      Get.dialog(
        AlertDialog(
          title: Text('Error'),
          content: Text('이메일 수집동의항목에 체크해주세요'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    } else {
      await tokenController.saveToken(
        response.data['accessToken'],
      );
      if (response.data['userInfo'] == null) {
        Get.to(signup.SignUp());
      } else {
        print('로그인시 컨트롤러에 저장된 토큰 : ${tokenController.accessToken}');
        loginController.changeLoginStatus(true);
        print(loginController.isLoggedIn);
        userInfoController.saveNickname(response.data['userInfo']['nickname']);
        userInfoController.saveAge(response.data['userInfo']['age']);
        userInfoController.saveGender(response.data['userInfo']['gender']);
        userInfoController
            .saveImageUrl(response.data['userInfo']['profileImage']);
        firstLoginController.changeFirstLogin(false);
        // Get.replace(main.MyApp());
        print(loginController.isLoggedIn);
        print(pageController.pageNum());
      }
      Get.back();
    }
  }
}

void signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final dio = await authDio();
  if (googleUser != null) {
    // print('name = ${googleUser.displayName}');
    print('email = ${googleUser.email}');
    // print('id = ${googleUser.id}');

    // dynamic bodyData = {'email': googleUser.email};
    dynamic bodyData = json.encode({'email': googleUser.email});

    final response = await dio.post('auth/google/login', data: bodyData);

    print(response);

    if (response.statusCode == 200) {
      // 추후에 issignup으로 교체
      tokenController.saveToken(
        response.data['token']['accessToken'],
      );
      if (response.data['userInfo'] == null) {
        Get.to(signup.SignUp());
      } else {
        loginController.changeLoginStatus(true);
        firstLoginController.changeFirstLogin(false);
        userInfoController.saveNickname(response.data['userInfo']['nickname']);
        userInfoController.saveAge(response.data['userInfo']['age']);
        userInfoController.saveGender(response.data['userInfo']['gender']);
        // 이미지는 받을때 type이 경로인가..? null보내면 default string으로?

        Get.back();
      }
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
                Column(children: const [
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
                            child: InkWell(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: SizedBox(
                                height: 50,
                                width: 190,
                                child: Image(
                                  image: AssetImage('assets/google.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
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
