import 'package:coursemores/course_make/make3.dart';
import 'package:coursemores/course_make/make_map.dart';
import 'package:coursemores/course_make/make_search.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as frl;
import 'package:flutter/material.dart';
import './place_edit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../controller/make_controller.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../auth/auth_dio.dart';

class CourseMake extends StatefulWidget {
  final String? courseId;
  CourseMake({Key? key, this.courseId}) : super(key: key);

  @override
  State<CourseMake> createState() => _CourseMakeState();
}

enum DraggingMode {
  iOS,
  android,
}

class _CourseMakeState extends State<CourseMake> {
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
      fetchCourse(widget.courseId!);
    }
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

  Future<void> fetchCourse(String courseId) async {
    final dio = await authDio();
    final response = await dio.get('course/$courseId');
    print(response);
    if (response.statusCode == 200) {
      final courseImportList = response.data['courseImportList '];
      print(courseImportList);
      importCourse(courseImportList);
    } else {
      throw Exception('Failed to load course');
    }
  }

  void importCourse(List<dynamic> courseImportList) async {
    for (dynamic course in courseImportList) {
      if (course is Map<String, dynamic>) {
        print('very good!!!');
        _addItem(
          course["name"],
          course["latitude"],
          course["longitude"],
          course["sido"],
          course["gugun"],
          shouldLoadImage: true, // 이미지 로드 여부를 지정
          UniqueKey(), // Create a unique key for each course item
        );
      }
    }

    // 모든 이미지가 로드된 후에 상태 변경을 알림
    setState(() {});
  }

  _CourseMakeState() {
    _items = <LocationData>[];
  }

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
          title: Text('장소 추가 불가'),
          content: Text('장소는 최대 5개까지 추가 가능합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인', style: TextStyle(color: Colors.blue)),
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
    // if (shouldLoadImage) {
    //   loadImages(locationData);
    // }
    // 이미지 로드를 수행할 때만 loadImages 함수 호출
    if (shouldLoadImage) {
      loadImages(locationData).then((_) {
        // 이미지 로드가 완료되면 Flutter에게 상태 변경을 알림
        setState(() {});
      });
    }
  }

  // 시도, 구군 정보 따로 저장하는 과정
  // Future<String> _getSido(double lat, double lon) async {
  //   final List<geocoding.Placemark> placemarks = await geocoding
  //       .placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
  //   if (placemarks != null && placemarks.isNotEmpty) {
  //     final geocoding.Placemark place = placemarks.first;
  //     final String administrativeArea = place.administrativeArea ?? '';
  //     return '$administrativeArea';
  //   }
  //   return '';
  // }
  Future<String> _getSido(double lat, double lon) async {
    final List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    // if (placemarks != null && placemarks.isNotEmpty) {
    if (placemarks.isNotEmpty) {
      final geocoding.Placemark place = placemarks.first;
      final String administrativeArea = place.administrativeArea ?? '';
      if (administrativeArea.isNotEmpty) {
        return administrativeArea;
      }
      return '전체';
    }
    return '';
  }

  Future<String> _getGugun(double lat, double lon) async {
    final List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    // if (placemarks != null && placemarks.isNotEmpty) {
    if (placemarks.isNotEmpty) {
      final geocoding.Placemark place = placemarks.first;
      final String locality = place.locality ?? '';
      final String subLocality = place.subLocality ?? '';
      if (locality.isNotEmpty) {
        return locality.trim();
      } else if (subLocality.isNotEmpty) {
        return subLocality.trim();
      } else {
        return '전체';
      }
    }
    return '';
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
        builder: (context) => EditItemPage(locationData: item),
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
        children: const [Text('장소 추가하기 🏙', style: TextStyle(color: Colors.white))],
      ),
      headerWidget: headerWidget(context),
      headerExpandedHeight: 0.3,
      body: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                          onPressed: () {
                            if (_items.length >= 5) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('장소 추가 불가'),
                                  content: Text('장소는 최대 5개까지 추가 가능합니다.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('확인', style: TextStyle(color: Colors.blue)),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CMSearch();
                            })).then((selectedPlace) async {
                              if (selectedPlace != null) {
                                double latitude = selectedPlace.geometry!.location.lat;
                                double longitude = selectedPlace.geometry!.location.lng;
                                String sido = await _getSido(latitude, longitude);
                                String gugun = await _getGugun(latitude, longitude);
                                _addItem(
                                  selectedPlace.name,
                                  latitude,
                                  longitude,
                                  sido,
                                  gugun,
                                  UniqueKey(),
                                  shouldLoadImage: true,
                                );
                              }
                            });
                          },
                          icon: Icon(Icons.search),
                          label: Text(
                            '검색 추가',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          )),
                      SizedBox(width: 16),
                      FilledButton.icon(
                          onPressed: () {
                            if (_items.length >= 5) {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('장소 추가 불가'),
                                  content: Text('장소는 최대 5개까지 추가 가능합니다.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('확인', style: TextStyle(color: Colors.blue)),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return CMMap();
                            })).then((data) {
                              if (data != null) {
                                _addItem(
                                  data['locationName'],
                                  data['latitude'],
                                  data['longitude'],
                                  data['sido'],
                                  data['gugun'],
                                  UniqueKey(),
                                  shouldLoadImage: true,
                                );
                              }
                            });
                          },
                          icon: Icon(Icons.location_on, color: Colors.red),
                          label: Text('마커 추가', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 600,
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
                                      padding: EdgeInsets.symmetric(vertical: 10),
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

                  SizedBox(height: 10),
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
                        icon: Icon(Icons.route),
                        label: Text('동선 미리보기'),
                      ),
                      SizedBox(width: 16),
                      FilledButton.icon(
                        icon: Icon(Icons.verified),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (_items.length >= 2) {
                            // _items 리스트에 2개 이상의 항목이 있는 경우
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('작성한 내용을 저장하겠습니까?'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '작성한 장소 ${_items.length}곳:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: _items
                                            .map((item) => Text(
                                                  '- ${item.name}',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
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
                                      child: Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MakeStepper()),
                                        );
                                      },
                                      child: Text('저장'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // _items 리스트에 2개 미만의 항목이 있는 경우
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: Row(
                                    children: const [
                                      Icon(Icons.do_not_disturb),
                                      Text('코스 등록 불가'),
                                    ],
                                  )),
                                  content: Text('코스는 2개 이상의 장소여야 등록이 가능합니다.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('확인'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        label: Text('코스 지정 완료'),
                      ),
                    ],
                  ),
                ],
              ),
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
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? frl.ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Color(0x08000000),
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

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
                      Text(data.name, style: Theme.of(context).textTheme.titleMedium),
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
                              // 페이지 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditItemPage(locationData: data),
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
                              onDelete();
                            },
                            icon: Icon(Icons.delete),
                            label: Text('장소 삭제', style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 243, 115, 115),
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
                  child: dragHandle,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget image = Container(
      // height: MediaQuery.of(context).size.height / 4,
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage('assets/img1.jpg'),
        //   fit: BoxFit.cover,
        // ),
        image: DecorationImage(
          // image: AssetImage('assets/img1.jpg'),
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.android) {
      content = frl.DelayedReorderableListener(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Column(children: [image, content]),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 3, offset: Offset(0, 2)),
      ]),
      child: Column(children: [image, content]),
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
        Text("장소 추가하기", style: TextStyle(fontSize: 25, color: Colors.white)),
        SizedBox(height: 30),
        Text("코스에 넣을 장소들을 골라보세요", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text("장소는 최대 5개까지 추가할 수 있어요", style: TextStyle(fontSize: 16, color: Colors.white)),
      ],
    ),
  );
}
