import 'package:coursemores/controller/getx_controller.dart';
import 'package:coursemores/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'sign_up.dart' as signup;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'auth_dio.dart';
import 'dart:math';

final tokenController = Get.put(TokenStorage());
final userInfoController = Get.put(UserInfo());
final firstLoginController = Get.put(LoginCheck());

void postLogin(accessToken) async {
  dynamic bodyData = json.encode({'accessToken': accessToken});

  final response = await dio.post('auth/kakao/login', data: bodyData);

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
        loginController.changeLoginStatus(true);
        userInfoController.saveNickname(response.data['userInfo']['nickname']);
        userInfoController.saveAge(response.data['userInfo']['age']);
        userInfoController.saveGender(response.data['userInfo']['gender']);
        userInfoController
            .saveImageUrl(response.data['userInfo']['profileImage']);
        firstLoginController.changeFirstLogin(false);
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10), // 10초 동안 애니메이션 실행
    )..repeat(); // 애니메이션을 반복하도록 설정
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background-pink.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image(image: AssetImage('assets/flower.png'), height: 200),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _animationController.value * 2 * pi,
                          child: child,
                        );
                      },
                      child: Image(
                        image: AssetImage('assets/flower.png'),
                        height: 200,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("COURSE MORES",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    SizedBox(height: 10),
                    Text("코스모스",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    SizedBox(height: 100),
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
                              postLogin(token.accessToken);
                              // Map<String, dynamic>? response =
                              //     await userService.signInByKakaoToken(token.accessToken);
                            }
                          },
                          child: Image(
                            image: AssetImage(
                                'assets/kakao_login_medium_wide.png'),
                            fit: BoxFit.fill,
                          ),
                        ),

                        SizedBox(height: 15),
                        // Padding(
                        //     padding: const EdgeInsets.only(top: 20.0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         signInWithGoogle();
                        //       },
                        //       child: SizedBox(
                        //         height: 50,
                        //         width: 190,
                        //         child: Image(
                        //           image: AssetImage('assets/google.png'),
                        //           fit: BoxFit.fill,
                        //         ),
                        //       ),
                        //     )),
                        Container(
                          width: 300,
                          height: 40,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SizedBox(
                            child: InkWell(
                              onTap: () {
                                signInWithGoogle();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 4),
                                  Image.asset('assets/glogo.png', height: 20),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        // '구글 로그인',
                                        'Google로 시작하기',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                      opacity: 0.0,
                                      child: Image.asset('assets/glogo.png')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
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
