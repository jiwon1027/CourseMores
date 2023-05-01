import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'notification.dart' as noti;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SignUpAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: boxDeco(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  ProfileImage(),
                  RegisterNickname(),
                ],
              ),
            )),
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
  XFile? _pickedFile;
  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 16;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('프로필 사진'),
        if (_pickedFile == null)
          InkWell(
            onTap: () {
              _showBottomSheet();
            },
            child: Container(
              width: 50,
              height: 50,
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
          Center(
              child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 2, color: Theme.of(context).colorScheme.primary),
              image: DecorationImage(
                  image: FileImage(File(_pickedFile!.path)), fit: BoxFit.cover),
            ),
          ))
      ],
    );
  }

  _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '닉네임',
          textAlign: TextAlign.start,
        ),
        Form(
            key: formKey,
            child: textFormFieldComponent(false, '사용할 닉네임을 입력하세요', 10, 2,
                '최소 2자 이상이어야 합니다', '최대 10자 이하여야 합니다')),
        IconButton(
            onPressed: () {
              _submit();
            },
            icon: const Icon(Icons.check))
      ],
    );
  }

  Future<void> _submit() async {
    if (formKey.currentState!.validate() == false) {
      return;
    } else {
      formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('확인!!'),
        duration: Duration(seconds: 1),
      ));
      Navigator.of(context).pop();
    }
  }
}

Widget textFormFieldComponent(bool obscureText, String hintText, int maxSize,
    int minSize, String underError, String overError) {
  return TextFormField(
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hintText,
    ),
    validator: (value) {
      if (value!.length < maxSize) {
        return underError;
      } else if (value.length > minSize) {
        return overError;
      } else {
        return null;
      }
    },
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
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ],
  );
}

class SignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignUpAppBar({
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
