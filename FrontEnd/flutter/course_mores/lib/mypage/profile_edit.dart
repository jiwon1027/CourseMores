// import 'dart:convert';
import '../controller/getx_controller.dart';
import 'package:coursemores/auth/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../notification/notification.dart' as noti;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:dio/dio.dart';
import 'package:get/get.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../main.dart' as main;
// import 'package:fluttertoast/fluttertoast.dart';
import 'post_profile_edit.dart' as post_profile_edit;
import '../auth/auth_dio.dart';

final userInfoController = Get.put(UserInfo());

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const ProfileEditAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: boxDeco(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
              )),
        ),
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
        const Padding(
          padding: EdgeInsets.only(
            bottom: 15,
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text('프로필 사진'),
          ),
        ),
        if (_pickedFile == null)
          InkWell(
            onTap: () {
              _showBottomSheet();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: imageSize,
              ),
            ),
          )
        else
          InkWell(
            onTap: () {
              _showBottomSheet2();
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: FileImage(File(_pickedFile!.path)),
                    fit: BoxFit.cover),
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
        print(pickedFile);
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
                            child: const Center(
                                child: Text(
                              '사진 촬영하기',
                              style: TextStyle(
                                fontSize: 20,
                              ),
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
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: const Center(
                                  // color: Colors.yellow,
                                  child: Text(
                                '앨범에서 가져오기',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
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
                                Navigator.pop(context);
                              });
                              print(userInfoController.profileImage);
                            },
                            child: const Center(
                                child: Text(
                              '기본 이미지로 변경',
                              style: TextStyle(
                                fontSize: 20,
                              ),
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
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: const Center(
                                  child: Text(
                                '사진 촬영하기',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
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
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 1))),
                              child: const Center(
                                  // color: Colors.yellow,
                                  child: Text(
                                '앨범에서 가져오기',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
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
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: const Text(
              '닉네임',
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Form(
                    key: formKey,
                    child: textFormFieldComponent(
                        false,
                        userInfoController.nickname.value,
                        10,
                        2,
                        '최소 2자 이상이어야 합니다.',
                        '최대 10자 이하여야 합니다.',
                        '이미 존재하는 닉네임입니다.',
                        _helperText)),
              ),
              IconButton(
                  onPressed: () {
                    _submit();
                  },
                  icon: const Icon(Icons.check))
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate() == false) {
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
    initialValue: userInfoController.nickname.value,
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
        return null;
      }
    },
  );
}

bool? isDuplicate;
void duplicateCheck(nickname) async {
  final dio = await authDio();
  // dynamic nicknameData = json.encode({'nickname': nickname});
  final response = await dio.get(
    'user/validation/nickname/$nickname',
  );

  if (response.statusCode == 200) {
    print('닉네임 중복 검사!');
    isDuplicate = response.data['isDuplicated'];
    print('중복여부=$isDuplicate');
  }
}

class GenderChoice extends StatefulWidget {
  const GenderChoice({super.key});

  @override
  State<GenderChoice> createState() => _GenderChoiceState();
}

class _GenderChoiceState extends State<GenderChoice> {
  String? _gender = userInfoController.gender.value;
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
      manColor = Colors.white;
    }
    if (_gender == 'W') {
      womanColor = Colors.blue;
      womanTextColor = Colors.white;
      manTextColor = Colors.blue;
    } else {
      womanColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              '성별',
              textAlign: TextAlign.start,
            ),
          ),
          ButtonBar(
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _gender = 'M';
                    userInfoController.saveGender('M');
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: manColor,
                  fixedSize:
                      Size(MediaQuery.of(context).size.width / 2 - 40, 40),
                ),
                child: Text(
                  '남성',
                  style: TextStyle(color: manTextColor),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _gender = 'W';
                    userInfoController.saveGender('W');
                  });
                },
                style: TextButton.styleFrom(
                    backgroundColor: womanColor,
                    fixedSize:
                        Size(MediaQuery.of(context).size.width / 2 - 40, 40)),
                child: Text(
                  '여성',
                  style: TextStyle(color: womanTextColor),
                ),
              )
            ],
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
  double _value = userInfoController.age.value.toDouble();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              '연령대',
              textAlign: TextAlign.start,
            ),
          ),
          SfSlider(
            value: _value,
            onChanged: (dynamic newValue) {
              setState(() {
                _value = newValue;
                userInfoController.saveAge(_value.toInt());
              });
              print(_value);
            },
            min: 0.0,
            max: 70.0,
            interval: 10,
            showLabels: true,
            showTicks: true,
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
    padding: const EdgeInsets.only(top: 60.0),
    child: ElevatedButton(
      onPressed: () {
        print(userInfoController.nickname);
        print(userInfoController.age);
        print(userInfoController.gender);
        print(userInfoController.profileImage);
        post_profile_edit.postProfileEdit(
          userInfoController.nickname.value,
          userInfoController.age.value,
          userInfoController.gender.value,
          userInfoController.profileImage,
          tokenController.accessToken.value,
        );
      },
      child: Text('수정하기'),
    ),
  );
}

// void postSignUp(nickname, age, gender, image, aToken) async {
//   dynamic userInfoCreateReqDto = {
//     'nickname': nickname,
//     'age': age,
//     'gender': gender,
//   };
//   // FormData formData =
//   dynamic bodyData = json.encode({
//     'UserInfoCreateReqDto': userInfoCreateReqDto,
//     'profileImage': image,
//   });
//   final response = await dio.post('user/signup',
//       data: bodyData,
//       options: Options(headers: {'Authorization': 'Bearer $aToken'}));
//   if (response.statusCode == 200) {
//     Get.to(main.MyApp());
//     print('가입성공!!!');
//   }
// }

// void postSignUp(nickname, age, gender, image, aToken) async {
//   var formData = FormData.fromMap({
//     'nickname': nickname,
//     'age': age,
//     'gender': gender,
//     'profileImage':
//         await MultipartFile.fromFile(image.path, filename: "image.jpg"),
//   });

//   final response = await dio.post('user/signup',
//       data: formData,
//       options: Options(headers: {'Authorization': 'Bearer $aToken'}));
//   if (response.statusCode == 200) {
//     Get.to(main.MyApp());
//     print('가입성공!!!');
//   }
// }

boxDeco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 3,
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ],
  );
}

class ProfileEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileEditAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black54, // 아이콘 색깔
      ),
      title: const Text('CourseMores', style: TextStyle(color: Colors.black)),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const noti.Notification()),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
