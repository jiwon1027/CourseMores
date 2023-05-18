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
import 'package:fluttertoast/fluttertoast.dart';

final tokenController = Get.put(TokenStorage());
final userInfoController = Get.put(UserInfo());
// final firstLoginController = Get.put(LoginCheck());

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
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
              fit: BoxFit.cover)),
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
                    LogoAnimation(animationController: _animationController),
                    SizedBox(height: 100),
                    Column(
                      children: const [
                        KakaoLoginButton(),
                        SizedBox(height: 15),
                        GoogleLoginButton(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class LogoAnimation extends StatelessWidget {
  const LogoAnimation({
    super.key,
    required AnimationController animationController,
  }) : _animationController = animationController;

  final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animationController.value * 2 * pi,
              child: child,
            );
          },
          child: Image(image: AssetImage('assets/flower.png'), height: 200),
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
      ],
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 45,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        child: InkWell(
          onTap: () {
            signInWithGoogle();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 4),
              Image.asset('assets/glogo.png', height: 20),
              Expanded(
                child: Center(
                  child: Text(
                    '구글로 시작하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.85),
                      fontSize: 16,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 45,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 254, 229, 0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox(
        child: InkWell(
          onTap: () async {
            bool isKakaoInstalled = await isKakaoTalkInstalled();
            OAuthToken? token;

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

            if (token != null) {
              postLogin(token.accessToken);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 4),
              Image.asset('assets/kakao_logo.png', height: 20),
              Expanded(
                child: Center(
                  child: Text(
                    '카카오로 시작하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.85),
                      fontSize: 16,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void postLogin(accessToken) async {
  dynamic bodyData = json.encode({'accessToken': accessToken});

  final response = await dio.post('auth/kakao/login', data: bodyData);
  print(response);
  if (response.statusCode == 200) {
    if (response.data['agree'] == false) {
      Fluttertoast.showToast(
        msg: '이메일 수집동의에 체크해 주세요',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[400],
        textColor: Colors.red,
      );
      return;
    } else {
      await tokenController.saveToken(
        response.data['accessToken'],
      );
      if (response.data['userInfo'] == null) {
        print('여기');

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
        Get.back();
      }
    }
  }
}

void signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final dio = await authDio();
  if (googleUser != null) {
    dynamic bodyData = json.encode({'email': googleUser.email});
    final response = await dio.post('auth/google/login', data: bodyData);
    print("response = $response");

    if (response.statusCode == 200) {
      // 추후에 issignup으로 교체
      tokenController.saveToken(response.data['accessToken']);
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
