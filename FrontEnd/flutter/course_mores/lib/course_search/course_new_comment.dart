import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewComment extends StatefulWidget {
  const NewComment({super.key});

  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 없어도 <- 모양의 뒤로가기가 기본으로 있으나 < 모양으로 바꾸려고 추가함
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        // 알림 아이콘과 텍스트 같이 넣으려고 RichText 사용
        title: RichText(
            text: const TextSpan(
          children: [
            WidgetSpan(
                child: Icon(
              Icons.edit,
              color: Colors.black,
              size: 20,
            )),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: '코멘트 작성하기', style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 40),
              AddImage(),
              AddText(textController: _textController),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // 이미지 업로드 코드
                  Fluttertoast.showToast(
                    msg: "작성 내용 : ${_textController.text}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                  Get.back();
                },
                child: Text("저장하기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddText extends StatelessWidget {
  const AddText({
    super.key,
    required TextEditingController textController,
  }) : _textController = textController;

  final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("글을 작성할 수 있어요 📝",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            )),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // 그림자 위치 조절
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '~~자까지 작성할 수 있어요',
              prefixText: ' ',
              prefixStyle: TextStyle(color: Colors.transparent),
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

class AddImage extends StatelessWidget {
  const AddImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("이미지를 첨부해보세요 📷",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            )),
        SizedBox(height: 10),
        Text("이미지는 최대 5장까지 첨부할 수 있어요", style: TextStyle(color: Colors.black45)),
        SizedBox(height: 10),
        SizedBox(
          // height: 250,
          child: ImageUploader(),
        ),
      ],
    );
  }
}

// 5개까지만 선택 가능하고 그 이상은 동작하지 않고, 카메라로 찍기, 선택된 사진 취소도 가능한 코드
class ImageUploader extends StatefulWidget {
  const ImageUploader({super.key});

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final List<File> _imageList = [];
  final picker = ImagePicker();
  final int maxImageCount = 5; // 최대 업로드 가능한 이미지 수

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (_imageList.length < maxImageCount) {
          _imageList.add(File(pickedFile.path));
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("최대 이미지 개수 초과"),
              content: Text("이미지는 최대 $maxImageCount개까지만 업로드 가능해요."),
              actions: <Widget>[
                TextButton(
                  child: Text("확인"),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          );
        }
      } else {
        print('선택된 이미지가 없어요.');
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imageList.removeAt(index);
    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(_imageList.length, (index) {
        return Stack(
          children: [
            Container(
              // width: double.infinity,
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(_imageList[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: InkWell(
                onTap: () => _removeImage(index),
                child: Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    setState(() {
      _imageList.add(File(imageFile.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (_imageList.length < 5) {
                _showSelectionDialog(context);
              } else {
                Fluttertoast.showToast(
                  msg: "사진은 최대 5개까지만 업로드 가능해요.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.image),
                SizedBox(width: 8),
                Text('이미지 첨부하기'),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: _imageList.isEmpty ? Center(child: Text("이미지를 선택해주세요.")) : buildGridView(),
          ),
        ],
      ),
    );
  }

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('이미지 선택'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Get.back();
                _takePicture();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(Icons.camera_alt, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('카메라'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Get.back();
                getImage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(Icons.image, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('갤러리'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
