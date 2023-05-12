import 'package:coursemores/course_search/search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CourseComments extends StatefulWidget {
  const CourseComments({super.key});

  @override
  State<CourseComments> createState() => _CourseCommentsState();
}

class _CourseCommentsState extends State<CourseComments> {
  late var courseIndex = detailController.nowIndex;

  // TODO: 해야함
  // late List commentsList = course.courseList[courseIndex]['comments_list'] as List;

  bool isCommentLatestSelected = true;
  bool isCommentPopularSelected = false;

  isCommentLatestSelectedClick() {
    setState(() {
      isCommentLatestSelected = true;
      isCommentPopularSelected = false;
      Fluttertoast.showToast(
        msg: "최신순 : $isCommentLatestSelected, 인기순 : $isCommentPopularSelected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  isCommentPopularSelectedClick() {
    setState(() {
      isCommentLatestSelected = false;
      isCommentPopularSelected = true;
      Fluttertoast.showToast(
        msg: "최신순 : $isCommentLatestSelected, 인기순 : $isCommentPopularSelected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        children: [
          DetailTapCourseCommentsCreateSection(courseIndex: courseIndex.value),
          SortButtonBar(
              isCommentLatestSelected: isCommentLatestSelected,
              isCommentPopularSelected: isCommentPopularSelected,
              isCommentLatestSelectedClick: isCommentLatestSelectedClick,
              isCommentPopularSelectedClick: isCommentPopularSelectedClick),
          // TODO: 해야함
          // SizedBox(
          //   height: commentsList.isEmpty ? null : 600,
          //   child: DetailTapCourseCommentsListSection(commentsList: commentsList),
          // )
        ],
      ),
    );
  }
}

class SortButtonBar extends StatefulWidget {
  const SortButtonBar({
    Key? key,
    required this.isCommentLatestSelected,
    required this.isCommentPopularSelected,
    required this.isCommentLatestSelectedClick,
    required this.isCommentPopularSelectedClick,
  }) : super(key: key);

  final isCommentLatestSelected;
  final isCommentPopularSelected;
  final isCommentLatestSelectedClick;
  final isCommentPopularSelectedClick;

  @override
  State<SortButtonBar> createState() => _SortButtonBarState();
}

class _SortButtonBarState extends State<SortButtonBar> {
  late var isCommentLatestSelected = widget.isCommentLatestSelected;
  late var isCommentPopularSelected = widget.isCommentPopularSelected;
  late var isCommentLatestSelectedClick = widget.isCommentLatestSelectedClick;
  late var isCommentPopularSelectedClick = widget.isCommentPopularSelectedClick;

  @override
  void initState() {
    super.initState();
    isCommentLatestSelected = widget.isCommentLatestSelected;
    isCommentPopularSelected = widget.isCommentPopularSelected;
    isCommentLatestSelectedClick = widget.isCommentLatestSelectedClick;
    isCommentPopularSelectedClick = widget.isCommentPopularSelectedClick;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.amber,
      height: 40,
      margin: EdgeInsets.only(top: 10),
      child: ButtonBar(
        buttonPadding: EdgeInsets.symmetric(horizontal: 0),
        alignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              isCommentLatestSelectedClick();
              isCommentLatestSelected = true;
              isCommentPopularSelected = false;
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
              padding: MaterialStateProperty.all(EdgeInsetsDirectional.symmetric(horizontal: 10)),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(isCommentLatestSelected ? Colors.blue : Colors.grey),
            ),
            child: const Text(
              '최신순',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              isCommentPopularSelectedClick();
              isCommentLatestSelected = false;
              isCommentPopularSelected = true;
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(30, 35)),
              padding: MaterialStateProperty.all(EdgeInsetsDirectional.symmetric(horizontal: 10)),
              elevation: MaterialStateProperty.all<double>(0),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
              foregroundColor: MaterialStateProperty.all<Color>(isCommentPopularSelected ? Colors.blue : Colors.grey),
            ),
            child: const Text('인기순', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class DetailTapCourseCommentsListSection extends StatelessWidget {
  const DetailTapCourseCommentsListSection({
    super.key,
    required this.commentsList,
  });

  final List commentsList;

  @override
  Widget build(BuildContext context) {
    return commentsList.isEmpty
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
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            itemCount: commentsList.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                margin: EdgeInsets.fromLTRB(4, 10, 4, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.account_circle),
                              SizedBox(width: 5),
                              Text(
                                commentsList[index]['user_name'],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.favorite_outline),
                              SizedBox(width: 5),
                              Text('${commentsList[index]['likes_cnt']}'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 16),
                          SizedBox(width: 5),
                          Text('${commentsList[index]['date']}'),
                          SizedBox(width: 10),
                          Icon(Icons.people, size: 16),
                          SizedBox(width: 5),
                          Text('${commentsList[index]['people']}'),
                        ],
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Text('${commentsList[index]['text']}'),
                      SizedBox(height: 10),
                      ImageGridView(commentImageList: commentsList[index]['images']),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class ImageGridView extends StatelessWidget {
  const ImageGridView({Key? key, required this.commentImageList}) : super(key: key);

  final List<String> commentImageList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: commentImageList.length > 3 ? 3 : commentImageList.length,
      itemBuilder: (context, imageIndex) {
        if (imageIndex == 2 && commentImageList.length > 3) {
          return Stack(
            children: [
              ImageInkWell(commentImageList: commentImageList, imageIndex: imageIndex),
              Positioned(
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(2),
                    width: 94,
                    height: 94,
                    child: Center(
                      child: Text(
                        '+${commentImageList.length - 3}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return ImageInkWell(commentImageList: commentImageList, imageIndex: imageIndex);
        }
      },
    );
  }
}

class ImageInkWell extends StatelessWidget {
  const ImageInkWell({
    super.key,
    required this.commentImageList,
    required this.imageIndex,
  });

  final List<String> commentImageList;
  final imageIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CommentGallery(images: commentImageList, initialIndex: imageIndex));
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Hero(
          tag: 'image${commentImageList}_$imageIndex',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(commentImageList[imageIndex], fit: BoxFit.cover, width: 100, height: 100),
          ),
        ),
      ),
    );
  }
}

class CommentGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const CommentGallery({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<CommentGallery> createState() => _CommentGalleryState();
}

class _CommentGalleryState extends State<CommentGallery> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(widget.images[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: 'image${widget.initialIndex}_$index',
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              );
            },
            itemCount: widget.images.length,
            pageController: PageController(initialPage: widget.initialIndex),
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            top: 50,
            left: 30,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((image) {
                int index = widget.images.indexOf(image);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.grey.shade800 : Colors.grey.shade600,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTapCourseCommentsCreateSection extends StatelessWidget {
  const DetailTapCourseCommentsCreateSection({
    super.key,
    required this.courseIndex,
  });

  final int courseIndex;

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
                children: const [
                  // TODO: 해야함
                  // Text(
                  //   "${(course.courseList[courseIndex]['comments_list'] as List<dynamic>).length}개의 코멘트가 있어요",
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  // ),
                  SizedBox(height: 8),
                  Text("코멘트를 남겨보세요"),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: 해야함
                // Get.to(comment.NewComment());
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 115, 81, 255),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                elevation: 2,
                padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
              ),
              child: const Text(
                "작성하러 가기 →",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
