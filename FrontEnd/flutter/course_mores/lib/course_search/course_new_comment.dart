import 'package:coursemores/course_search/search.dart';
import 'package:get/get.dart';
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
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: RichText(
            text: TextSpan(
          children: const [
            WidgetSpan(child: Icon(Icons.edit, color: Colors.black, size: 20)),
            WidgetSpan(child: SizedBox(width: 5)),
            TextSpan(text: '코멘트 작성하기', style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.close, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 40),
              SliderPeople(),
              AddImage(),
              AddText(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await detailController.changeCommentPage(0);
                  await detailController.addComment();
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
  AddText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("글을 작성할 수 있어요 📝", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        SizedBox(height: 10),
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
        Text("이미지를 첨부해보세요 📷", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (detailController.imageList.length < 5) {
                    detailController.showSelectionDialog(context);
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
                  children: const [Icon(Icons.image), SizedBox(width: 8), Text('이미지 첨부하기')],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: detailController.imageList.isEmpty ? Center(child: Text("이미지를 선택해주세요.")) : ImageGridView(),
              ),
            ],
          ),
        ));
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
    return Obx(() => Column(
          children: [
            Text("방문 인원이 궁금해요 👀", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            SizedBox(height: 30),
            SfSlider(
              value: detailController.sliderValue.value.toDouble(),
              min: 1.0,
              max: 5.0,
              stepSize: 1.0,
              shouldAlwaysShowTooltip: true,
              tooltipTextFormatterCallback: (value, formattedText) {
                return "${detailController.peopleMapping[value]}";
              },
              showDividers: true,
              interval: 1.0,
              onChanged: (newValue) {
                detailController.changeSliderValue(newValue);
              },
            ),
            SizedBox(height: 30),
          ],
        ));
  }
}
