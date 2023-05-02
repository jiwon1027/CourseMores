import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            bool isKakaoInstalled = await isKakaoTalkInstalled();
            OAuthToken? token;
            // UserService userService = UserService();

            if (isKakaoInstalled) {
              try {
                token = await UserApi.instance.loginWithKakaoTalk();
                debugPrint('카카오톡으로 로그인 성공');
              } catch (error) {
                debugPrint('카톡로그인 실패 $error');
                if (error is PlatformException && error.code == 'CANCELED') {
                  return;
                }
                try {
                  token = await UserApi.instance.loginWithKakaoAccount();
                  debugPrint('카카오계정로그인 성공');
                } catch (error) {
                  debugPrint('카카오계정로그인 실패 $error');
                }
              }
            } else {
              try {
                token = await UserApi.instance.loginWithKakaoAccount();
                debugPrint('카카오계정 로그인 성공');
              } catch (error) {
                debugPrint('카카오계정 로그인 실패 $error');
              }
            }
            // if (token != null) {
            //   Map<String, dynamic>? response =
            //       await userService.signInByKakaoToken(token.accessToken);
            // }
          },
          child: Image(
            image: AssetImage('assets/kakao.png'),
            fit: BoxFit.fill,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Image(
            image: AssetImage('assets/google.png'),
            fit: BoxFit.fill,
          ),
        ),
      ],
    ));
  }
}
