import 'package:coursemores/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'sign_up.dart' as signup;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                              print(loginController.isLoggedIn.value);
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
