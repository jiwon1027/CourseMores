// import 'dart:convert';
import '../controller/getx_controller.dart';
import 'package:coursemores/auth/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../notification/notification.dart' as noti;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'post_signup.dart' as post_signup;
import 'package:draggable_home/draggable_home.dart';
import 'auth_dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Get.back();
        },
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('COURSE', style: TextStyle(color: Colors.white)),
          SizedBox(width: 10),
          Image.asset("assets/flower.png", height: 35),
          SizedBox(width: 10),
          Text('MORES', style: TextStyle(color: Colors.white)),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.transparent)),
      ],
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileImage(),
                RegisterNickname(),
                GenderChoice(),
                AgeRange(),
                confirmButton(),
              ],
            ),
          ),
        ),
      ],
      fullyStretchable: false,
      expandedBody: headerWidget(context),
      backgroundColor: Colors.white,
      appBarColor: Color.fromARGB(255, 95, 207, 255),
    );
    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   appBar: SignUpAppBar(),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child: Container(
    //           decoration: boxDeco(),
    //           child: Padding(
    //             padding: EdgeInsets.all(20.0),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.stretch,
    //               children: [
    //                 ProfileImage(),
    //                 RegisterNickname(),
    //                 GenderChoice(),
    //                 AgeRange(),
    //                 confirmButton(),
    //               ],
    //             ),
    //           )),
    //     ),
    //   ),
    // );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Color.fromARGB(255, 0, 90, 129),
            Color.fromARGB(232, 255, 218, 218),
          ],
          stops: const [0.0, 0.9],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("회원 가입", style: TextStyle(fontSize: 30, color: Colors.white)),
          SizedBox(height: 30),
          Text("간단히 프로필을 작성하면",
              style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(height: 10),
          Text("코스모스의 기능을 이용하실 수 있어요",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  XFile? _pickedFile = userInfoController.profileImage;
  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 16;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text('프로필 사진'),
          ),
        ),
        if (_pickedFile == null)
          InkWell(
            onTap: () {
              _showBottomSheet();
            },
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Icon(Icons.camera_alt_outlined,
                    size: imageSize, color: Colors.grey[400]),
              ),
            ),
          )
        else
          InkWell(
            onTap: () {
              _showBottomSheet2();
            },
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  image: DecorationImage(
                      image: FileImage(File(_pickedFile!.path)),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          )
      ],
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        userInfoController.saveImage(pickedFile);
        print('777777');
        print(pickedFile.path);
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        userInfoController.saveImage(pickedFile);
        print(pickedFile.path);
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _showBottomSheet() {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              _getCameraImage();
                              Navigator.pop(context);
                            },
                            child: Center(
                                child: Text(
                              '사진 촬영하기',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ))),
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              _getPhotoLibraryImage();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: Center(
                                  child: Text(
                                '앨범에서 가져오기',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                            )),
                      ),
                    ]),
              ));
        });
  }

  _showBottomSheet2() {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              userInfoController.saveImage(null);
                              userInfoController.saveImageUrl(null);

                              setState(() {
                                _pickedFile = null;
                                userInfoController.profileImage = null;
                                Navigator.pop(context);
                              });
                            },
                            child: Center(
                                child: Text(
                              '기본 이미지로 변경',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ))),
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              _getCameraImage();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: Center(
                                  child: Text(
                                '사진 촬영하기',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                            )),
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              _getPhotoLibraryImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: Center(
                                  child: Text(
                                '앨범에서 가져오기',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                            )),
                      ),
                    ]),
              ));
        });
  }
}

class RegisterNickname extends StatefulWidget {
  const RegisterNickname({super.key});

  @override
  State<RegisterNickname> createState() => _RegisterNicknameState();
}

class _RegisterNicknameState extends State<RegisterNickname> {
  final formKey = GlobalKey<FormState>();
  String? _helperText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text('닉네임', textAlign: TextAlign.start),
          ),
          Row(
            children: [
              Expanded(
                child: Form(
                    key: formKey,
                    child: textFormFieldComponent(
                        false,
                        '사용할 닉네임을 입력하세요.',
                        10,
                        2,
                        '최소 2자 이상이어야 합니다.',
                        '최대 10자 이하여야 합니다.',
                        '이미 존재하는 닉네임입니다.',
                        _helperText)),
              ),
              OutlinedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text('중복체크')),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate() == false) {
      userInfoController.changeSignupCheck(false);
      return;
    } else {
      formKey.currentState!.save();

      setState(() {
        _helperText = '사용 가능한 닉네임입니다!';
      });
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('확인!!'),
      //   duration: Duration(seconds: 1),
      // ));
      // Navigator.of(context).pop();
    }
  }
}

Widget textFormFieldComponent(
    bool obscureText,
    String hintText,
    int maxSize,
    int minSize,
    String underError,
    String overError,
    String duplicateError,
    String? helperText) {
  return TextFormField(
    obscureText: obscureText,
    decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        helperStyle: TextStyle(color: Colors.blue)),
    onSaved: (String? inputValue) {
      String nicknameValue = inputValue!;
      userInfoController.saveNickname(nicknameValue);
      print('닉네임inputvalue!');
    },
    validator: (value) {
      duplicateCheck(value);
      if (value!.length < minSize) {
        return underError;
      } else if (value.length > maxSize) {
        return overError;
        // ###중복 닉네임 체크 필요
      } else if (isDuplicate == true) {
        return duplicateError;
      } else {
        userInfoController.changeSignupCheck(true);
        return null;
      }
    },
  );
}

bool? isDuplicate;
void duplicateCheck(nickname) async {
  final dio = await authDio();
  // dynamic nicknameData = json.encode({'nickname': nickname});
  final response = await dio.get('user/validation/nickname/$nickname');

  if (response.statusCode == 200) {
    print('닉네임 중복 검사!');
    isDuplicate = response.data['isDuplicate'];
  }
}

// final userInfoController = Get.put(UserInfo());

class GenderChoice extends StatefulWidget {
  const GenderChoice({super.key});

  @override
  State<GenderChoice> createState() => _GenderChoiceState();
}

class _GenderChoiceState extends State<GenderChoice> {
  String? _gender;
  Color? manColor;
  Color? womanColor;
  Color? manTextColor = Colors.blue;
  Color? womanTextColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    if (_gender == 'M') {
      manColor = Colors.blue;
      manTextColor = Colors.white;
      womanTextColor = Colors.blue;
    } else {
      manColor = Colors.grey[200];
    }
    if (_gender == 'W') {
      womanColor = Colors.blue;
      womanTextColor = Colors.white;
      manTextColor = Colors.blue;
    } else {
      womanColor = Colors.grey[200];
    }

    return Padding(
      padding: EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text('성별', textAlign: TextAlign.start),
          ),
          SizedBox(
            width: double.infinity,
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                // OutlinedButton(
                FilledButton(
                    onPressed: () {
                      setState(() {
                        _gender = 'M';
                        userInfoController.saveGender('M');
                      });
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: manColor,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 2 - 40, 40),
                    ),
                    child: Text('남성', style: TextStyle(color: manTextColor))),
                // OutlinedButton(
                FilledButton(
                    onPressed: () {
                      setState(() {
                        _gender = 'W';
                        userInfoController.saveGender('W');
                      });
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: womanColor,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 2 - 40, 40),
                    ),
                    child: Text('여성', style: TextStyle(color: womanTextColor))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AgeRange extends StatefulWidget {
  const AgeRange({super.key});

  @override
  State<AgeRange> createState() => _AgeRangeState();
}

class _AgeRangeState extends State<AgeRange> {
  double _value = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text('연령대', textAlign: TextAlign.start),
          ),
          SfSlider(
            value: _value,
            onChanged: (dynamic newValue) {
              setState(() {
                _value = newValue;
                userInfoController.saveAge(_value.toInt());
              });
              // print(_value);
            },
            min: 0.0,
            max: 70.0,
            interval: 10,
            showLabels: true,
            // showTicks: true,
            stepSize: 10,
            labelFormatterCallback:
                (dynamic actualValue, String formattedText) {
              if (actualValue == 0) {
                return '0~9세';
              } else if (actualValue == 70) {
                return '${actualValue.toInt()}세+';
              } else {
                return '${actualValue.toInt()}대';
              }
            },
          )
        ],
      ),
    );
  }
}

confirmButton() {
  return Padding(
    padding: EdgeInsets.only(top: 60),
    child: ElevatedButton(
      onPressed: () {
        if (userInfoController.signupCheck.value == true) {
          // print(userInfoController.nickname);
          // print(userInfoController.age);
          // print(userInfoController.gender);
          // print(userInfoController.profileImage);
          post_signup.postSignUp(
            userInfoController.nickname.value,
            userInfoController.age.value,
            userInfoController.gender.value,
            userInfoController.profileImage,
            tokenController.accessToken.value,
          );
          userInfoController.changeSignupCheck(false);
        } else {
          print('빼애애애액!');
          Fluttertoast.showToast(
            msg: '닉네임 중복확인을 해 주세요',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[400],
            textColor: Colors.red,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        fixedSize: Size.fromHeight(40),
      ),
      child: Text('가입하기'),
    ),
  );
}

boxDeco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(0, 2),
      ),
    ],
  );
}

class SignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignUpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(0, 255, 220, 220),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black54),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('COURSE', style: TextStyle(color: Colors.black)),
          SizedBox(width: 10),
          Image.asset("assets/flower.png", height: 35),
          SizedBox(width: 10),
          Text('MORES', style: TextStyle(color: Colors.black)),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => noti.Notification()),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
