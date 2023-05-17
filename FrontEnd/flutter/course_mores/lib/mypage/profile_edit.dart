// import 'dart:convert';
import '../controller/getx_controller.dart';
import 'package:coursemores/auth/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';

final userInfoController = Get.put(UserInfo());

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  void initState() {
    super.initState();
    print('수정페이지에서 불러온 이미지 : ${userInfoController.profileImage}');
    // downloadImage();
  }

  // Future<void> downloadImage() async {
  //   if (userInfoController.imageUrl.value != 'default') {
  //     dio.Response response = await dio.Dio().get(
  //         '${userInfoController.imageUrl}',
  //         options: dio.Options(responseType: dio.ResponseType.bytes));
  //     String tempDir = (await getTemporaryDirectory()).path;
  //     String filePath = join(tempDir, 'image.jpg');
  //     await File(filePath).writeAsBytes(response.data);
  //     XFile xFile = XFile(filePath);
  //     userInfoController.saveImage(xFile);
  //     print('서버에서 받은 이미지 다운로드! : ${userInfoController.profileImage}');
  //   } else {
  //     print('프로필이미지 등록되어있지 않음!');
  //     userInfoController.profileImage = null;
  //     print(userInfoController.profileImage);
  //   }
  // }

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
  bool isDelete = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Padding(padding: EdgeInsets.only(bottom: 15), child: Text('프로필 사진')),
        ),
        if (_pickedFile == null)
          InkWell(
            onTap: () {
              _showBottomSheet(context);
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://coursemores.s3.amazonaws.com/default_profile.png'),
                    fit: BoxFit.cover),
              ),
            ),
          )
        else
          InkWell(
            onTap: () {
              _showBottomSheet2(context);
            },
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  image: DecorationImage(image: FileImage(File(_pickedFile!.path)), fit: BoxFit.cover),
                ),
              ),
            ),
          )
      ],
    );
  }

  _getCameraImage1() async {
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

  _getCameraImage2() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        userInfoController.saveImage(pickedFile);
        userInfoController.imageIsDelete(true);
        print(pickedFile);
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage1() async {
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

  _getPhotoLibraryImage2() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        userInfoController.saveImage(pickedFile);
        userInfoController.imageIsDelete(true);
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _showBottomSheet(BuildContext context) {
    // 기본 이미지가 없을 때
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
                              _getCameraImage1();
                              Navigator.pop(context);
                            },
                            child: Center(
                                child: Text('사진 촬영하기', style: TextStyle(fontSize: 16), textAlign: TextAlign.center))),
                      ),
                      Expanded(
                        child: InkWell(
                            onTap: () {
                              _getPhotoLibraryImage1();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                              child: Center(
                                  child: Text(
                                '앨범에서 가져오기',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              )),
                            )),
                      ),
                    ]),
              ));
        });
  }

  _showBottomSheet2(BuildContext context) {
    // 기존 이미지가 있을 떄
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 180,
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
                              userInfoController.imageIsDelete(true);

                              setState(() {
                                _pickedFile = null;
                                userInfoController.profileImage = null;
                                Navigator.pop(context);
                              });
                              print(userInfoController.profileImage);
                            },
                            child: Center(
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
                              _getCameraImage2();
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                              child: Center(
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
                              _getPhotoLibraryImage2();
                            },
                            child: Container(
                              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 1))),
                              child: Center(
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
                    child: textFormFieldComponent(false, userInfoController.nickname.value, 10, 2, '최소 2자 이상이어야 합니다.',
                        '최대 10자 이하여야 합니다.', '이미 존재하는 닉네임입니다.', _helperText)),
              ),
              SizedBox(width: 5),
              FilledButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text('중복 확인', style: TextStyle(fontSize: 14))),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate() == false) {
      userInfoController.changeEditCheck(false);
      return;
    } else {
      formKey.currentState!.save();
      // userInfoController.changeEditCheck(true);

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

Widget textFormFieldComponent(bool obscureText, String hintText, int maxSize, int minSize, String underError,
    String overError, String duplicateError, String? helperText) {
  return TextFormField(
    initialValue: userInfoController.nickname.value,
    obscureText: obscureText,
    decoration: InputDecoration(hintText: hintText, helperText: helperText, helperStyle: TextStyle(color: Colors.blue)),
    onSaved: (String? inputValue) {
      String nicknameValue = inputValue!;
      userInfoController.saveNickname(nicknameValue);
      print('닉네임inputvalue!');
    },
    onChanged: (value) => userInfoController.saveNickname(value),
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
        userInfoController.changeEditCheck(true);
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
          ButtonBar(
            children: [
              FilledButton(
                onPressed: () {
                  setState(() {
                    _gender = 'M';
                    userInfoController.saveGender('M');
                  });
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: manColor,
                  fixedSize: Size(MediaQuery.of(context).size.width / 2 - 40, 40),
                ),
                child: Text('남성', style: TextStyle(color: manTextColor)),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _gender = 'W';
                    userInfoController.saveGender('W');
                  });
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: womanColor,
                    fixedSize: Size(MediaQuery.of(context).size.width / 2 - 40, 40)),
                child: Text('여성', style: TextStyle(color: womanTextColor)),
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
            labelFormatterCallback: (dynamic actualValue, String formattedText) {
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
        if (userInfoController.editCheck.value == true ||
            userInfoController.currentNickname.value ==
                userInfoController.nickname.value) {
          print(userInfoController.nickname);
          print(userInfoController.age);
          print(userInfoController.gender);
          print(userInfoController.profileImage);
          print(userInfoController.isDeleteImage.value);
          post_profile_edit.postProfileEdit(
            userInfoController.nickname.value,
            userInfoController.age.value,
            userInfoController.gender.value,
            userInfoController.profileImage,
            tokenController.accessToken.value,
            userInfoController.isDeleteImage.value,
          );
          userInfoController.changeEditCheck(false);
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
      child: Text('수정하기'),
    ),
  );
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
        Text("프로필 수정", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("프로필 사진, 닉네임, 성별, 연령대 등의", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text("프로필을 수정하실 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    ),
  );
}

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Future<void> downloadImage() async {
//   if (userInfoController.imageUrl.value != 'default') {
//     dio.Response response = await dio.Dio().get(
//         '${userInfoController.imageUrl}',
//         options: dio.Options(responseType: dio.ResponseType.bytes));
//     String tempDir = (await getTemporaryDirectory()).path;
//     String filePath = join(tempDir, 'image.jpg');
//     await File(filePath).writeAsBytes(response.data);
//     XFile xFile = XFile(filePath);
//     userInfoController.saveImage(xFile);
//     print('서버에서 받은 이미지 다운로드! : ${userInfoController.profileImage}');
//   } else {
//     print('프로필이미지 등록되어있지 않음!');
//     userInfoController.profileImage = null;
//     print(userInfoController.profileImage);
//   }
// }
