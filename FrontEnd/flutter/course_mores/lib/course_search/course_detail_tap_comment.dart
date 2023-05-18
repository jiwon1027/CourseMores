import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:coursemores/course_search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' show DateFormat;

import 'course_change_comment.dart';
import 'course_new_comment.dart';

ScrollController commentScrollController = ScrollController();

class CourseComments extends StatelessWidget {
  CourseComments({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Column(children: [
          CommentsCreateSection(),
          SortButtonBar(),
          SizedBox(
            height: detailController.nowCourseCommentList.isEmpty ? null : 600,
            child: CommentsListSection(),
          ),
        ]));
  }
}

class SortButtonBar extends StatelessWidget {
  SortButtonBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: 40,
          margin: EdgeInsets.only(top: 10),
          child: ButtonBar(
            buttonPadding: EdgeInsets.symmetric(horizontal: 0),
            alignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  detailController.changeCommentPage(0);
                  detailController.isCommentLatestSelectedClick();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
                  padding: MaterialStateProperty.all(EdgeInsetsDirectional.symmetric(horizontal: 10)),
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      detailController.isCommentLatestSelected.value ? Colors.blue : Colors.grey),
                ),
                child: Text('최신순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
              ElevatedButton(
                onPressed: () {
                  detailController.changeCommentPage(0);
                  detailController.isCommentPopularSelectedClick();
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
                  padding: MaterialStateProperty.all(EdgeInsetsDirectional.symmetric(horizontal: 10)),
                  elevation: MaterialStateProperty.all<double>(0),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      detailController.isCommentPopularSelected.value ? Colors.blue : Colors.grey),
                ),
                child: Text('인기순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ],
          ),
        ));
  }
}

class CommentsListSection extends StatelessWidget {
  CommentsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    commentScrollController.addListener(() {
      print("=============");
      if (commentScrollController.position.pixels == commentScrollController.position.maxScrollExtent) {
        print("불러오기");
        // 스크롤이 리스트의 끝까지 도달하면 다음 검색 결과 호출
        detailController.getNextCommentResults();
      }
    });
    return Obx(() => detailController.nowCourseCommentList.isEmpty
        ? Container(
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: const [
                Text("☺", style: TextStyle(fontSize: 70)),
                SizedBox(height: 20),
                Text("아직 코멘트가 없어요."),
                SizedBox(height: 10),
                Text("첫 작성자가 되어보시는 건 어떨까요?"),
              ],
            ),
          )
        : Column(children: [
            Expanded(
                child: ListView.builder(
              controller: commentScrollController, // ScrollController 설정
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              itemCount: detailController.nowCourseCommentList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.fromLTRB(4, 10, 4, 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              ProfileImage(index: index),
                              SizedBox(width: 8),
                              Text(detailController.nowCourseCommentList[index]['writeUser']['nickname']),
                            ]),
                            Obx(
                              () => LikeButton(
                                isLiked: detailController.nowCourseCommentList[index]['like'],
                                onTap: (isLiked) => detailController.onCommentLikeButtonTapped(index),
                                size: 26,
                                likeCountPadding: EdgeInsets.symmetric(horizontal: 6),
                                likeCount: detailController.nowCourseCommentList[index]['likeCount'],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_month, size: 16),
                            SizedBox(width: 5),
                            Text(
                                DateFormat('yyyy. MM.dd')
                                    .format(DateTime.parse(detailController.nowCourseCommentList[index]['createTime'])),
                                style: TextStyle(fontSize: 12)),
                            SizedBox(width: 10),
                            Icon(Icons.people, size: 16),
                            SizedBox(width: 5),
                            if (detailController.nowCourseCommentList[index]['people'] != 0)
                              if (detailController.nowCourseCommentList[index]['people'] != 5)
                                Text('${detailController.nowCourseCommentList[index]['people']}명',
                                    style: TextStyle(fontSize: 12)),
                            if (detailController.nowCourseCommentList[index]['people'] >= 5)
                              Text('5명 이상', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        // SizedBox(height: 10),
                        if (detailController.nowCourseCommentList[index]['imageList'].length != 0)
                          ImageGridView(index: index),
                        SizedBox(height: 10),
                        Text('${detailController.nowCourseCommentList[index]['content']}',
                            style: TextStyle(height: 1.6)),
                        SizedBox(height: 10),
                        if (detailController.nowCourseCommentList[index]['write'])
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(child: Container()),
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await detailController.setComment(index);
                                    Get.to(ChangeComment(index));
                                  },
                                  tooltip: "수정"),
                              IconButton(
                                  icon: Icon(Icons.delete_forever_rounded),
                                  onPressed: () async {
                                    print(detailController.nowIndex);
                                    bool confirmed = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("코멘트 삭제", style: TextStyle(fontSize: 16)),
                                          content: Text("정말로 삭제하시겠습니까?", style: TextStyle(fontSize: 14)),
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
                                      detailController.deleteComment(index);
                                    }
                                  },
                                  tooltip: "삭제"),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ))
          ]));
    // :
    // Padding(
    //     padding: EdgeInsets.all(8.0),
    //     child: Column(
    //         children: List.generate(
    //       detailController.nowCourseCommentList.length,
    //       (index) {
    //         // padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
    //         // itemCount: detailController.nowCourseCommentList.length,
    //         // itemBuilder: (context, index) {
    //         return Card(
    //           elevation: 6,
    //           margin: EdgeInsets.fromLTRB(4, 10, 4, 0),
    //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //           child: Padding(
    //             padding: EdgeInsets.all(15),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Row(children: [
    //                       ProfileImage(index: index),
    //                       SizedBox(width: 8),
    //                       Text(detailController.nowCourseCommentList[index]['writeUser']['nickname']),
    //                     ]),
    //                     Obx(
    //                       () => LikeButton(
    //                         isLiked: detailController.nowCourseCommentList[index]['like'],
    //                         onTap: (isLiked) => detailController.onCommentLikeButtonTapped(index),
    //                         size: 26,
    //                         likeCountPadding: EdgeInsets.symmetric(horizontal: 6),
    //                         likeCount: detailController.nowCourseCommentList[index]['likeCount'],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(height: 8),
    //                 Row(
    //                   children: [
    //                     Icon(Icons.calendar_month, size: 16),
    //                     SizedBox(width: 5),
    //                     Text(
    //                         DateFormat('yyyy. MM.dd')
    //                             .format(DateTime.parse(detailController.nowCourseInfo['createTime'])),
    //                         style: TextStyle(fontSize: 12)),
    //                     SizedBox(width: 10),
    //                     Icon(Icons.people, size: 16),
    //                     SizedBox(width: 5),
    //                     if (detailController.nowCourseCommentList[index]['people'] != 0)
    //                       if (detailController.nowCourseCommentList[index]['people'] != 5)
    //                         Text('${detailController.nowCourseCommentList[index]['people']}명',
    //                             style: TextStyle(fontSize: 12)),
    //                     if (detailController.nowCourseCommentList[index]['people'] >= 5)
    //                       Text('5명 이상', style: TextStyle(fontSize: 12)),
    //                   ],
    //                 ),
    //                 // SizedBox(height: 10),
    //                 if (detailController.nowCourseCommentList[index]['imageList'].length != 0)
    //                   ImageGridView(index: index),
    //                 SizedBox(height: 10),
    //                 Text('${detailController.nowCourseCommentList[index]['content']}',
    //                     style: TextStyle(height: 1.6)),
    //                 SizedBox(height: 10),
    //                 if (detailController.nowCourseCommentList[index]['write'])
    //                   Row(
    //                     crossAxisAlignment: CrossAxisAlignment.end,
    //                     children: [
    //                       Expanded(child: Container()),
    //                       IconButton(
    //                           icon: Icon(Icons.edit),
    //                           onPressed: () async {
    //                             await detailController.setComment(index);
    //                             Get.to(ChangeComment(index));
    //                           },
    //                           tooltip: "수정"),
    //                       IconButton(
    //                           icon: Icon(Icons.delete_forever_rounded),
    //                           onPressed: () async {
    //                             await detailController.setComment(index);
    //                             Get.to(ChangeComment(index));
    //                           },
    //                           tooltip: "삭제"),
    //                     ],
    //                   ),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     ))));

    // Column(
    //     children: [
    //       Expanded(
    //         child: ListView.builder(
    //           controller: commentScrollController, // ScrollController 설정
    //           padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
    //           itemCount: detailController.nowCourseCommentList.length,
    //           itemBuilder: (context, index) {
    //             return Card(
    //               elevation: 6,
    //               margin: EdgeInsets.fromLTRB(4, 10, 4, 0),
    //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //               child: Padding(
    //                 padding: EdgeInsets.all(15),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Row(children: [
    //                           ProfileImage(index: index),
    //                           SizedBox(width: 8),
    //                           Text(detailController.nowCourseCommentList[index]['writeUser']['nickname']),
    //                         ]),
    //                         Obx(
    //                           () => LikeButton(
    //                             isLiked: detailController.nowCourseCommentList[index]['like'],
    //                             onTap: (isLiked) => detailController.onCommentLikeButtonTapped(index),
    //                             size: 26,
    //                             likeCountPadding: EdgeInsets.symmetric(horizontal: 6),
    //                             likeCount: detailController.nowCourseCommentList[index]['likeCount'],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(height: 8),
    //                     Row(
    //                       children: [
    //                         Icon(Icons.calendar_month, size: 16),
    //                         SizedBox(width: 5),
    //                         Text(
    //                             DateFormat('yyyy. MM.dd')
    //                                 .format(DateTime.parse(detailController.nowCourseInfo['createTime'])),
    //                             style: TextStyle(fontSize: 12)),
    //                         SizedBox(width: 10),
    //                         Icon(Icons.people, size: 16),
    //                         SizedBox(width: 5),
    //                         if (detailController.nowCourseCommentList[index]['people'] != 0)
    //                           if (detailController.nowCourseCommentList[index]['people'] != 5)
    //                             Text('${detailController.nowCourseCommentList[index]['people']}명',
    //                                 style: TextStyle(fontSize: 12)),
    //                         if (detailController.nowCourseCommentList[index]['people'] >= 5)
    //                           Text('5명 이상', style: TextStyle(fontSize: 12)),
    //                       ],
    //                     ),
    //                     // SizedBox(height: 10),
    //                     if (detailController.nowCourseCommentList[index]['imageList'].length != 0)
    //                       ImageGridView(index: index),
    //                     SizedBox(height: 10),
    //                     Text('${detailController.nowCourseCommentList[index]['content']}',
    //                         style: TextStyle(height: 1.6)),
    //                     SizedBox(height: 10),
    //                     if (detailController.nowCourseCommentList[index]['write'])
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.end,
    //                         children: [
    //                           Expanded(child: Container()),
    //                           IconButton(
    //                               icon: Icon(Icons.edit),
    //                               onPressed: () async {
    //                                 await detailController.setComment(index);
    //                                 Get.to(ChangeComment(index));
    //                               },
    //                               tooltip: "수정"),
    //                           IconButton(
    //                               icon: Icon(Icons.delete_forever_rounded),
    //                               onPressed: () async {
    //                                 await detailController.setComment(index);
    //                                 Get.to(ChangeComment(index));
    //                               },
    //                               tooltip: "삭제"),
    //                         ],
    //                       ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //       if (detailController.isCommentLoading.value) CircularProgressIndicator(), // 로딩 중인 경우 표시할 위젯
    //     ],
    //   )
    // );
  }
}

class ImageGridView extends StatelessWidget {
  ImageGridView({Key? key, required this.index}) : super(key: key);

  final index;
  late final commentImageList = detailController.nowCourseCommentList[index]['imageList'];

  @override
  Widget build(BuildContext context) {
    for (int index = 0; index < commentImageList.length; index++) {
      detailController.downloadImage(commentImageList[index]);
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: commentImageList.length > 3 ? 3 : commentImageList.length,
      itemBuilder: (context, imageIndex) {
        if (imageIndex == 2 && commentImageList.length > 3) {
          return Stack(
            children: [
              ImageInkWell(
                commentIndex: index,
                imageIndex: imageIndex,
                commentImageId: commentImageList[imageIndex]["commentImageId"],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.black38, borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(2),
                    width: 94,
                    height: 94,
                    child: Center(
                        child: Text('+${commentImageList.length - 3}',
                            style: TextStyle(color: Colors.white, fontSize: 20))),
                  ),
                ),
              ),
            ],
          );
        } else {
          return ImageInkWell(
            commentIndex: index,
            imageIndex: imageIndex,
            commentImageId: commentImageList[imageIndex]["commentImageId"],
          );
        }
      },
    );
  }
}

class ImageInkWell extends StatelessWidget {
  ImageInkWell({super.key, required this.commentIndex, required this.imageIndex, required this.commentImageId});

  final commentIndex;
  final imageIndex;
  final commentImageId;
  late final imageList = detailController.nowCourseCommentList[commentIndex]['imageList'];

  @override
  Widget build(BuildContext context) {
    detailController.getDirectory();
    final directory = detailController.directory;
    final file = File("$directory/${imageList[imageIndex]['commentImageId']}.jpg");
    final fileExists = file.existsSync();

    return InkWell(
      onTap: () {
        detailController.changeCommentImageIndex(imageIndex);
        Get.to(() => CommentGallery(commentIndex: commentIndex));
      },
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Hero(
          tag: 'image${commentIndex}_$commentImageId',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: fileExists
                ? Image.file(
                    file,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  )
                : CachedNetworkImage(
                    imageUrl: imageList[imageIndex]['image'],
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    placeholder: (context, url) => CircularProgressIndicator(), // 로딩 이미지 설정
                    errorWidget: (context, url, error) => Icon(Icons.error), // 에러 발생 시 표시할 위젯 설정
                  ),
          ),
        ),
      ),
    );
  }
}

class CommentGallery extends StatelessWidget {
  CommentGallery({Key? key, required this.commentIndex}) : super(key: key);

  final commentIndex;
  final pageController = PageController(initialPage: detailController.commentImageIndex.value);
  late final imageList = detailController.nowCourseCommentList[commentIndex]['imageList'];

  @override
  Widget build(BuildContext context) {
    detailController.getDirectory();
    return Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => Stack(
            children: [
              PhotoViewGallery.builder(
                scrollPhysics: BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        // FileImage(
                        //     File("$directory/${imageList[detailController.commentImageIndex.value]['commentImageId']}.jpg")),

                        CachedNetworkImageProvider(imageList[index]['image']),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes:
                        PhotoViewHeroAttributes(tag: 'image${detailController.commentImageIndex.value}_$index'),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                  );
                },
                itemCount: imageList.length,
                pageController: PageController(initialPage: detailController.commentImageIndex.value),
                onPageChanged: (int index) {
                  detailController.changeCommentImageIndex(index);
                },
              ),
              Positioned(
                top: 50,
                left: 30,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
              Obx(() => Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.map<Widget>((image) {
                        int index = imageList.indexOf(image);
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: detailController.commentImageIndex.value == index
                                ? Colors.grey.shade800
                                : Colors.grey.shade600,
                          ),
                        );
                      }).toList(),
                    ),
                  )),
            ],
          ),
        ));
  }
}

class CommentsCreateSection extends StatelessWidget {
  CommentsCreateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        "${detailController.nowCourseInfo['commentCount']}개의 코멘트가 있어요",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      )),
                  SizedBox(height: 8),
                  Text("코멘트를 남겨보세요", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                detailController.resetComment();
                Get.to(NewComment());
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 115, 81, 255),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 2,
                padding: EdgeInsets.fromLTRB(20, 3, 20, 3),
              ),
              child: Text("작성하러 가기 →", style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  ProfileImage({super.key, required this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    try {
      if (detailController.nowCourseCommentList[index]['writeUser']['profileImage'] != "default") {
        return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CachedNetworkImage(
              imageUrl: detailController.nowCourseCommentList[index]['writeUser']['profileImage'],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 25,
              width: 25,
              fit: BoxFit.cover,
            ));
      } else {
        const image = 'assets/default_profile.png';
        return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            clipBehavior: Clip.hardEdge,
            child: Image(image: AssetImage(image), height: 25, width: 25, fit: BoxFit.cover));
      }
    } catch (e) {
      print(e);
      const image = 'assets/default_profile.png';
      return Image(image: AssetImage(image), height: 25, width: 25, fit: BoxFit.cover);
    }
  }
}
