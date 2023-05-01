import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class NewComment extends StatefulWidget {
  const NewComment({super.key});

  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
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
                text: '새 코멘트 작성',
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
        )),
        // 피그마와 모양 맞추려고 close 아이콘 하나 넣어둠
        // <와 X 중 하나만 있어도 될 것 같아서 상의 후 삭제 필요
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
      // 알림 리스트
      // body: Text("data"),
      body: ImageUploader(),
    );
  }
}

// class ImgUploader extends StatefulWidget {
//   const ImgUploader({super.key});

//   @override
//   State<ImgUploader> createState() => _ImgUploaderState();
// }

// class _ImgUploaderState extends State<ImgUploader> {
//   final ImagePicker _picker = ImagePicker();
//   List<XFile> _pickedImgs = [];

//   Future<void> _pickImg() async {
//     final List<XFile>? images = await _picker.pickMultiImage();
//     if (images != null) {
//       setState(() {
//         _pickedImgs = images;
//       });
//     }
//   }

//   final List<Widget> _boxContends = [
//     IconButton(
//         onPressed: () => _pickImg(),
//         icon: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
//             child: Icon(
//               CupertinoIcons.camera,
//               color: Theme.of(context).colorScheme.primary,
//             ))),
//     Container(),
//     Container(),
//     _pickedImgs.length <= 4
//         ? Container()
//         : FittedBox(
//             child: Container(
//                 padding: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.6),
//                     shape: BoxShape.circle),
//                 child: Text(
//                   '+${(_pickedImgs.length - 4).toString()}',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleSmall
//                       ?.copyWith(fontWeight: FontWeight.w800),
//                 ))),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 500,
//       child: GridView.count(
//         padding: EdgeInsets.all(2),
//         crossAxisCount: 2,
//         mainAxisSpacing: 5,
//         crossAxisSpacing: 5,
//         children: List.generate(
//             4,
//             (index) => DottedBorder(
//                 child: Container(),
//                 color: Colors.grey,
//                 dashPattern: [5, 3],
//                 borderType: BorderType.RRect,
//                 radius: Radius.circular(10))).toList(),
//       ),
//     );
//   }
// }

// // 1장만 로컬에 업로드하는 코드
// class ImagePickerExample extends StatefulWidget {
//   @override
//   _ImagePickerExampleState createState() => _ImagePickerExampleState();
// }

// class _ImagePickerExampleState extends State<ImagePickerExample> {
//   List<File> _images = [];

//   Future<void> _pickImages() async {
//     final picker = ImagePicker();
//     final pickedImages = await picker.pickMultiImage();
//     if (pickedImages != null) {
//       setState(() {
//         _images =
//             pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickImages,
//               child: Text('Select Images'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 3,
//                 children: _images.map((image) {
//                   return Image.file(image);
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// 여러 장 로컬에 선택할 수 있는 코드
// class MultipleImagePicker extends StatefulWidget {
//   const MultipleImagePicker({super.key});

//   @override
//   State<MultipleImagePicker> createState() => _MultipleImagePickerState();
// }

// class _MultipleImagePickerState extends State<MultipleImagePicker> {
//   List<File> _images = [];

//   Future<void> _pickImages() async {
//     final List<XFile> images =
//         await ImagePicker().pickMultiImage(imageQuality: 50);

//     setState(() {
//       _images = images.map((image) => File(image.path)).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Multiple Image Picker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _pickImages,
//               child: Text('Select Images'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 5,
//                   mainAxisSpacing: 5,
//                 ),
//                 itemCount: _images.length,
//                 itemBuilder: (context, index) {
//                   return Image.file(_images[index], fit: BoxFit.cover);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// 5개까지만 선택 가능하고 그 이상은 동작하지 않고, 카메라로 찍기도 가능한 코드
// class UploadImages extends StatefulWidget {
//   @override
//   _UploadImagesState createState() => _UploadImagesState();
// }

// class _UploadImagesState extends State<UploadImages> {
//   List<File> _imageList = [];
//   int imageCount = 0; // 이미지 개수

//   Future<void> _getImage(ImageSource source) async {
//     // 이미지가 5개 초과인 경우 중단
//     if (imageCount >= 5) return;

//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         _imageList.add(File(pickedFile.path));
//         imageCount++;
//       });
//     }
//   }

//   Future<void> _uploadImages() async {
//     // 업로드 로직
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upload Images'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 4.0,
//                 mainAxisSpacing: 4.0,
//               ),
//               itemBuilder: (BuildContext context, int index) {
//                 return Image.file(_imageList[index]);
//               },
//               itemCount: _imageList.length,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () => _getImage(ImageSource.camera),
//                 child: Text('Camera'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _getImage(ImageSource.gallery),
//                 child: Text('Gallery'),
//               ),
//               ElevatedButton(
//                 onPressed: _uploadImages,
//                 child: Text('Upload'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

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
              content: Text("이미지는 최대 $maxImageCount개까지만 업로드 가능합니다."),
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
        print('No image selected.');
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
      crossAxisCount: 3,
      children: List.generate(_imageList.length, (index) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.all(5),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("이미지 업로드"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getImage,
              child: Text("이미지 선택"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_imageList.length < 5) {
                  _showSelectionDialog(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('You can only upload up to 5 images.')),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Take a picture'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _imageList.isEmpty
                  ? Center(child: Text("이미지를 선택해주세요."))
                  : buildGridView(),
            ),
            ElevatedButton(
              onPressed: () {
                // 이미지 업로드 코드
              },
              child: Text("업로드"),
            ),
          ],
        ),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
