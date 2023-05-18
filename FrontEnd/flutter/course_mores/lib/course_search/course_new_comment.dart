import 'package:coursemores/course_search/search.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

final TextEditingController textController = TextEditingController();

class NewComment extends StatelessWidget {
  NewComment({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.transparent)),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('코멘트 작성하기', style: TextStyle(color: Colors.white))],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 20),
                SliderPeople(),
                SizedBox(height: 20),
                AddImage(),
                AddText(),
                SizedBox(height: 30),
                Row(
                  children: [
                    CancleConfirmButton(),
                    SizedBox(width: 20),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await detailController.changeCommentPage(0);
                          await detailController.addComment();
                          Get.back();
                        },
                        child: Text("저장하기"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Color.fromARGB(255, 80, 170, 208),
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
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              FilledButton(
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
            Text("방문 인원이 궁금해요 👀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfSlider(
                labelPlacement: LabelPlacement.onTicks,
                value: detailController.sliderValue.value.toDouble(),
                min: 1.0,
                max: 5.0,
                stepSize: 1.0,
                // enableTooltip: true,
                showLabels: true,
                labelFormatterCallback: (actualValue, formattedText) {
                  return "${detailController.peopleMapping[actualValue]}";
                },
                // tooltipTextFormatterCallback: (value, formattedText) {
                //   return "${detailController.peopleMapping[value]}";
                // },
                showDividers: true,
                interval: 1.0,
                onChanged: (newValue) {
                  detailController.changeSliderValue(newValue);
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ));
  }
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
        Text("코멘트 작성하기", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("다른 사람의 코스에 대한 경험이나 생각을", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text("사진과 글, 방문한 인원 수 등으로 남길 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    ),
  );
}

class CancleConfirmButton extends StatelessWidget {
  const CancleConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black12)),
        child: Text("취소하기", style: TextStyle(color: Colors.black)),
        onPressed: () async {
          bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("코멘트 수정 나가기", style: TextStyle(fontSize: 16)),
                content: Text("지금 나가면 저장이 되지 않아요! 정말로 취소하시겠어요?", style: TextStyle(fontSize: 14)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // 취소 버튼을 누를 때 false 반환
                    },
                    child: Text("취소"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // 확인 버튼을 누를 때 true 반환
                    },
                    child: Text("확인"),
                  ),
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
