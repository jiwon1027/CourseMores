import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

final TextEditingController textController = TextEditingController();

class NewComment extends StatelessWidget {
  NewComment({super.key});

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
            Navigator.pop(context);
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
            TextSpan(
                text: '코멘트 작성하기',
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
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
                  Navigator.pop(context);
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
  AddText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("글을 작성할 수 있어요 📝", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        SizedBox(height: 20),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3)),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '5000자까지 작성할 수 있어요',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
      ],
    );
  }
}

class AddImage extends StatelessWidget {
  AddImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("이미지를 첨부해보세요 📷", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        SizedBox(height: 10),
        Text("이미지는 최대 5장까지 첨부할 수 있어요", style: TextStyle(color: Colors.black45)),
        SizedBox(height: 10),
        SizedBox(child: ImageUploader()),
      ],
    );
  }
}

// 5개까지만 선택 가능하고 그 이상은 동작하지 않고, 카메라로 찍기, 선택된 사진 취소도 가능한 코드
class ImageUploader extends StatelessWidget {
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
                    Navigator.of(context).pop();
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
}

class ImageGridView extends StatelessWidget {
  const ImageGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.count(
          crossAxisCount: 5,
          children: List.generate(detailController.imageList.length, (index) {
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: FileImage(detailController.imageList[index]), fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () => detailController.removeImage(index),
                    child: Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: Icon(Icons.close, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            );
          }),
        ));
  }
}

class SliderPeople extends StatelessWidget {
  SliderPeople({super.key});

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
                  msg: "5개까지만 업로드 가능해요.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('5개까지만 업로드 가능해요.')),
                // );
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
            child: _imageList.isEmpty
                ? Center(child: Text("이미지를 선택해주세요."))
                : buildGridView(),
          ),
        ],
        stops: const [0.0, 0.9],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("코멘트 작성하기", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("다른 사람의 코스에 대한 경험이나 생각을", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text("사진과 글, 방문한 인원 수 등으로 남길 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
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
                Navigator.pop(context);
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
                Navigator.pop(context);
                getImage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(Icons.image, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('갤러리'),
                ],
              );
            },
          );

          if (confirmed == true) {
            Get.back();
          }
        },
      ),
    );
  }
}
