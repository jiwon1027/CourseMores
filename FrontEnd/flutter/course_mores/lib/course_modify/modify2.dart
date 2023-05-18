import 'package:coursemores/course_modify/modify3.dart';
import 'package:coursemores/course_modify/modify_place.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as frl;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../controller/make_controller.dart';
// ignore: unused_import
import 'package:geocoding/geocoding.dart' as geocoding;
import '../auth/auth_dio.dart';
import 'package:image_picker/image_picker.dart';

class CourseModify extends StatefulWidget {
  final String? courseId;
  CourseModify({Key? key, this.courseId}) : super(key: key);
  // const CourseMake({Key? key}) : super(key: key);

  @override
  State<CourseModify> createState() => _CourseModifyState();
}

enum DraggingMode {
  iOS,
  android,
}

class _CourseModifyState extends State<CourseModify> {
  final courseController = Get.put(CourseController());
  final LocationController locationController = Get.put(LocationController());

  bool isRefreshing = false;

  // list of tiles
  late List<LocationData> _items;

  @override
  void initState() {
    super.initState();

    // Initialize the controller values
    courseController.title.value = '';
    courseController.content.value = '';
    courseController.people.value = 0;
    courseController.time.value = 0;
    courseController.visited.value = false;
    courseController.locationList.clear();
    courseController.hashtagList.clear();
    courseController.themeIdList.clear();

    if (widget.courseId != null) {
      // Fetch the course information using the courseId
      getCourseInfo(widget.courseId!);
    }

    // Initialize _items
    // _items = List<LocationData>.from(courseController.locationList);
  }

  Future<void> refreshImages() async {
    setState(() {
      isRefreshing = true;
    });

    // 이미지 다시 로드
    for (var locationData in courseController.locationList) {
      await loadImages(locationData);
    }

    setState(() {
      isRefreshing = false;
    });
  }

  Future<void> loadImages(LocationData locationData) async {
    try {
      final String apiKey = dotenv.get('GOOGLE_MAP_API_KEY');
      final String imgUrl =
          "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=${locationData.latitude},${locationData.longitude}&fov=90&heading=235&pitch=10&key=$apiKey";

      final imageProvider = NetworkImage(imgUrl);
      await precacheImage(imageProvider, context);
    } catch (error) {
      // 이미지 로딩 중 에러 발생
      print(error);
    }
  }

  Future<void> getCourseInfo(String courseId) async {
    final dio = await authDio();
    final response1 = await dio.get('course/info/$courseId');
    print(response1);
    if (response1.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      print('수정용 코스 정보 가져오기 성공');
      final courseInfo = response1.data['courseInfo'];
      List<int> themeIdList = courseInfo['themeList'].map<int>((map) => map['themeId'] as int).toList();

      courseController.title.value = courseInfo['title'];
      courseController.content.value = courseInfo['content'];
      courseController.people.value = courseInfo['people'];
      courseController.time.value = courseInfo['time'];
      courseController.visited.value = courseInfo['visited'];
      courseController.hashtagList.value = RxList<String>.from(courseInfo['hashtagList']);
      courseController.themeIdList.value = RxList<int>.from(themeIdList.map((dynamic item) => item as int));
    } else {
      throw Exception('Failed to load course');
    }

    final response2 = await dio.get('course/detail/$courseId');
    print('2349860');
    print(response2);
    if (response2.statusCode == 200) {
      print('수정용 장소 정보 가져오기 성공');
      final locationDetailInfo = response2.data['courseDetailList'];
      print('486');
      print(locationDetailInfo);

      // courseController.locationList.clear();
      List<LocationData> locationList = (locationDetailInfo as List<dynamic>).map((detail) {
        // 장소 정보 추출
        int? courseLocationId = detail['courseLocationId'];
        String name = detail['name'];
        String title = detail['title'] ?? ''; // Null일 경우 빈 문자열로 대체
        String content = detail['content'] ?? ''; // Null일 경우 빈 문자열로 대체
        double latitude = detail['latitude'] ?? 0.0; // Null일 경우 0.0으로 대체
        double longitude = detail['longitude'] ?? 0.0; // Null일 경우 0.0으로 대체
        String sido = detail['sido'] ?? ''; // Null일 경우 빈 문자열로 대체
        String gugun = detail['gugun'] ?? ''; // Null일 경우 빈 문자열로 대체
        String roadViewImage = detail['roadViewImage'] ?? ''; // Null일 경우 빈 문자열로 대체
        // List<String> locationImageList =
        //     (detail['locationImageList'] as List<dynamic>)
        //         .cast<String>(); // locationImageList 추출
        List<XFile> locationImageList =
            (detail['locationImageList'] as List<dynamic>).cast<String>().map((imagePath) => XFile(imagePath)).toList();

        // LocationData 객체 생성
        LocationData locationData = LocationData(
          // key: UniqueKey(),
          key: ValueKey(courseLocationId),
          // key: key ?? UniqueKey(),
          name: name,
          title: title,
          content: content,
          latitude: latitude,
          longitude: longitude,
          sido: sido,
          gugun: gugun,
          roadViewImage: roadViewImage,
          // temporaryImageList: [], // 임시 이미지 리스트는 초기화
          temporaryImageList: locationImageList, // locationImageList 할당
        );

        locationData.courseLocationId = courseLocationId;

        return locationData;
      }).toList();

// 기존의 locationList를 제거하고 새로운 locationList로 설정
      courseController.locationList.assignAll(locationList);

      setState(() {
        _items = List<LocationData>.from(courseController.locationList);
      });
      final courseModifyList = courseController.locationList;
      print(courseModifyList[0].title);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load course');
    }
  }

  _CourseModifyState() {
    _items = [];
    _items = courseController.locationList;
  }

  // ignore: unused_element
  void _addItem(
    String name,
    double latitude,
    double longitude,
    String sido,
    String gugun,
    Key? key, {
    bool shouldLoadImage = false,
  }) {
    if (_items.length >= 5) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('장소 추가 불가'),
          content: const Text('장소는 최대 5개까지 추가 가능합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
      return;
    }

    final String apiKey2 = dotenv.get('GOOGLE_MAP_API_KEY');

    final String imgUrl2 =
        "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=$latitude,$longitude&fov=90&heading=235&pitch=10&key=$apiKey2";

    LocationData locationData = LocationData(
      // key: UniqueKey(),
      key: key ?? UniqueKey(), // Use the provided key or create a new one if none is provided
      name: name,
      latitude: latitude,
      longitude: longitude,
      sido: sido,
      gugun: gugun,
      roadViewImage: imgUrl2,
      temporaryImageList: [],
    );
    _items.add(locationData);
    // CourseController에서 locationList에 locationData를 추가
    courseController.locationList.add(locationData);

    // 이미지 로드를 수행할 때만 loadImages 함수 호출
    if (shouldLoadImage) {
      loadImages(locationData);
    }
  }

// Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((LocationData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
      courseController.locationList.removeAt(draggingIndex);
      courseController.locationList.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.name}}");
  }

  void onEdit(LocationData item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage2(locationData: item),
      ),
    );
  }

  void onDelete(LocationData item) {
    setState(() {
      _items.remove(item);

      // CourseController의 locationList에서 해당 아이템 제거
      Get.find<CourseController>().removeLocation(item);
    });
  }
  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  final DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.transparent)),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text('코스 수정하기', style: TextStyle(color: Colors.white))],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       '장소는 최대 5개까지 추가할 수 있어요',
                //       style: TextStyle(color: Color.fromARGB(255, 92, 67, 67), fontSize: 18),
                //     ),
                //     IconButton(
                //       icon: Icon(Icons.refresh),
                //       onPressed: isRefreshing ? null : refreshImages,
                //     ),
                //   ],
                // ),
                SizedBox(height: 5),
                SizedBox(
                  width: 380,
                  height: 650,
                  child: frl.ReorderableList(
                    onReorder: _reorderCallback,
                    onReorderDone: _reorderDone,
                    child: CustomScrollView(
                      // cacheExtent: 3000,
                      slivers: <Widget>[
                        SliverPadding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Padding(
                                    // padding: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(5),
                                    child: Item(
                                      data: _items[index],
                                      // first and last attributes affect border drawn during dragging
                                      isFirst: index == 0,
                                      isLast: index == _items.length - 1,
                                      draggingMode: _draggingMode,
                                      onEdit: () => onEdit(_items[index]),
                                      onDelete: () => onDelete(_items[index]),
                                    ),
                                  );
                                },
                                childCount: _items.length,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // const MyStatefulWidget(),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     Icon(Icons.highlight_off),
                //     SizedBox(
                //       width: 3,
                //     ),
                //     Text('코스 수정에서는 장소 추가, 삭제 및 순서 변경이 불가능합니다'),
                //   ],
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        final List<LocationData> items = _items;
                        if (items.length <= 1) {
                          showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                              title: Text('동선 미리보기'),
                              content: Text('장소를 2개 이상 선택해주세요.'),
                            ),
                          );
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: SizedBox(
                              height: 400,
                              width: 300,
                              child: PreviewRoute(items: items),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.route),
                      label: const Text('동선 미리보기'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      icon: const Icon(Icons.verified),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        // 코스 저장여부 확인 코드 시작 check //
                        // GetX에서 CourseController 가져오기
                        // ignore: unused_local_variable
                        final CourseController courseController = Get.find<CourseController>();

                        // 코스 저장여부 확인 코드 끝 check //
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('작성한 내용을 저장하겠습니까?'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('작성한 장소 ${_items.length}곳:',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                  const SizedBox(height: 8),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: _items
                                        .map((item) => Text(
                                              '- ${item.name}',
                                              style: const TextStyle(color: Colors.red),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ModifyStepper(
                                                courseId: widget.courseId,
                                              )),
                                    );
                                  },
                                  child: const Text('저장'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: const Text('코스 지정 완료'),
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

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  static late List<LocationData> _items;
  final LocationData data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static int indexOfKey(Key key) {
    return _items.indexWhere((LocationData d) => d.key == key);
  }

  Widget _buildChild(BuildContext context, frl.ReorderableItemState state) {
    BoxDecoration decoration;

    final String apiKey = dotenv.get('GOOGLE_MAP_API_KEY');

    final String imgUrl =
        "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=${data.latitude},${data.longitude}&fov=90&heading=235&pitch=10&key=$apiKey";

    if (state == frl.ReorderableItemState.dragProxy || state == frl.ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = const BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == frl.ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    // Widget dragHandle = draggingMode == DraggingMode.iOS
    //     ? frl.ReorderableListener(
    //         child: Container(
    //           padding: const EdgeInsets.only(right: 18.0, left: 18.0),
    //           color: const Color(0x08000000),
    //           child: const Center(
    //             child: Icon(Icons.do_not_disturb, color: Color(0xFF888888)),
    //           ),
    //         ),
    //       )
    //     : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 21, 20, 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // 출력할 값들
                              print('Key: ${data.key}');
                              print('Name: ${data.name}');
                              print('Latitude: ${data.latitude}');
                              print('Longitude: ${data.longitude}');
                              print('roadViewImage: ${data.roadViewImage}');
                              print('numberOfImage: ${data.numberOfImage}');
                              print('Title: ${data.title}');
                              print('Content: ${data.content}');
                              print('Sido: ${data.sido}');
                              print('Gugun: ${data.gugun}');
                              print('isUpdate: ${data.isUpdate}');
                              // 페이지 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditItemPage2(locationData: data),
                                ),
                              );
                              // },
                            },
                            icon: Icon(Icons.edit),
                            label: Text('추가 정보 작성', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 119, 181, 212),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              // onDelete();
                            },
                            icon: Icon(Icons.delete),
                            label: Text('삭제 불가', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  // child: dragHandle,
                  child: Container(
                      padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                      color: const Color(0x08000000),
                      child: Center(child: Icon(Icons.do_not_disturb, color: Color(0xFF888888)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget image = Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.android) {
      content = frl.DelayedReorderableListener(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              image,
              content,
            ],
          ),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 3, offset: Offset(0, 2)),
      ]),
      child: Column(
        children: [image, content],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return frl.ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}

class PreviewRoute extends StatelessWidget {
  const PreviewRoute({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<LocationData> items;

  @override
  Widget build(BuildContext context) {
    final List<LatLng> positions = items.map((item) => LatLng(item.latitude, item.longitude)).toList();
    final List<Future<BitmapDescriptor>> futures = [
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)), 'assets/marker1.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)), 'assets/marker2.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)), 'assets/marker3.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)), 'assets/marker4.png'),
      BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)), 'assets/marker5.png'),
    ];
    final Future<List<BitmapDescriptor>> markersFuture = Future.wait(futures);
    return FutureBuilder<List<BitmapDescriptor>>(
        future: markersFuture,
        builder: (BuildContext context, AsyncSnapshot<List<BitmapDescriptor>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('Error: no data');
          }
          final List<BitmapDescriptor> markerIcons = snapshot.data!;
          final List<Marker> markers = positions.asMap().entries.map((entry) {
            final index = entry.key;
            final position = entry.value;
            final icon = markerIcons[index];
            return Marker(
              markerId: MarkerId('marker$index'),
              position: position,
              icon: icon,
            );
          }).toList();
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: positions[0], // 첫 번째 장소를 화면 중앙에 띄우기
              zoom: 15.0,
            ),
            markers: Set.from(markers),
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: positions,
                color: Colors.blue,
                width: 5,
              ),
            },
          );
        });
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
        Text("코스 수정하기", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("코스 수정에서는 장소 추가, 삭제 및 순서 변경이 불가능해요",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color.fromARGB(255, 179, 54, 95))),
        SizedBox(height: 10),
        Text("장소는 최대 5개까지 추가할 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    ),
  );
}
