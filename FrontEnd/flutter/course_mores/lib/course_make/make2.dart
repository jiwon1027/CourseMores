import 'package:coursemores/course_make/make3.dart';
import 'package:coursemores/course_make/make_map.dart';
import 'package:coursemores/course_make/make_search.dart';
// import 'package:coursemores/course_search/course_list.dart';
// import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as frl;
import 'package:flutter/material.dart';
import './place_edit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../make_controller.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class CourseMake extends StatefulWidget {
  const CourseMake({Key? key}) : super(key: key);

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

  // list of tiles
  late List<LocationData> _items;

  // @override
  // void initState() {
  //   final courseController = Get.put(CourseController());
  //   final locationController = Get.put(LocationController());
  //   super.initState();
  // }

  _CourseMakeState() {
    _items = <LocationData>[];
  }

  void _addItem(
      String name, double latitude, double longitude, String sido, String gugun,
      [Key? key]) {
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

    final String _apiKey2 = dotenv.get('GOOGLE_MAP_API_KEY');

    final String _imgUrl2 =
        "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=${latitude},${longitude}&fov=90&heading=235&pitch=10&key=$_apiKey2";

    LocationData locationData = LocationData(
      key: UniqueKey(),
      name: name,
      latitude: latitude,
      longitude: longitude,
      sido: sido,
      gugun: gugun,
      roadViewImage: _imgUrl2,
    );
    _items.add(locationData);
    // CourseController에서 locationList에 locationData를 추가
    courseController.locationList.add(locationData);
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
    final List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    if (placemarks != null && placemarks.isNotEmpty) {
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
    final List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    if (placemarks != null && placemarks.isNotEmpty) {
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

  // // 기존 아이템을 수정하는 함수
  // void _editItem(int index, String title, double latitude, double longitude) {
  //   setState(() {
  //     final item = LocationData(
  //       name: title,
  //       latitude: latitude,
  //       longitude: longitude,
  //       key: _items[index].key,
  //     );
  //     _items[index] = item;
  //   });
  // }
  // 기존 아이템을 수정하는 함수
  // void _editItem(int index, String title, double latitude, double longitude) {
  //   final locationData = LocationData(
  //     key: _items[index].key,
  //     name: title,
  //     latitude: latitude,
  //     longitude: longitude,
  //   );
  //   final locationController = Get.find<LocationController>();
  //   locationController.editItem(index, locationData);
  // }
  void _editItem(int index, String title, double latitude, double longitude,
      String sido, String gugun) {
    final locationData = LocationData(
      name: title,
      latitude: latitude,
      longitude: longitude,
      key: _items[index].key,
      sido: sido,
      gugun: gugun,
    );
    locationController.updateLocation(index, locationData);
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

  // void onDelete(ItemData item) {
  //   // TODO: Implement deleting logic here
  // }
  void onDelete(LocationData item) {
    setState(() {
      _items.remove(item);
    });
  }
  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

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
                Icons.edit_note,
                color: Colors.black,
              ),
            ),
            WidgetSpan(
              child: SizedBox(
                width: 5,
              ),
            ),
            TextSpan(
              text: '장소 추가하기 🏙',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              const Text(
                '장소는 최대 5개까지 추가할 수 있어요',
                style: TextStyle(
                    color: Color.fromARGB(255, 92, 67, 67), fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 380,
                height: 520,
                child: frl.ReorderableList(
                  onReorder: _reorderCallback,
                  onReorderDone: _reorderDone,
                  child: CustomScrollView(
                    // cacheExtent: 3000,
                    slivers: <Widget>[
                      SliverPadding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Item(
                                  data: _items[index],
                                  // first and last attributes affect border drawn during dragging
                                  isFirst: index == 0,
                                  isLast: index == _items.length - 1,
                                  draggingMode: _draggingMode,
                                  onEdit: () => onEdit(_items[index]),
                                  onDelete: () => onDelete(_items[index]),
                                );
                              },
                              childCount: _items.length,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // const MyStatefulWidget(),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
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
                                  child: const Text('확인',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return CMSearch();
                        // })).then((selectedPlace) {
                        //   if (selectedPlace != null) {
                        //     _addItem(
                        //         selectedPlace.name,
                        //         selectedPlace.geometry!.location.lat,
                        //         selectedPlace.geometry!.location.lng,
                        //         UniqueKey());
                        //   }
                        // });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CMSearch();
                        })).then((selectedPlace) async {
                          if (selectedPlace != null) {
                            double latitude =
                                selectedPlace.geometry!.location.lat;
                            double longitude =
                                selectedPlace.geometry!.location.lng;
                            String sido = await _getSido(latitude, longitude);
                            String gugun = await _getGugun(latitude, longitude);
                            _addItem(
                              selectedPlace.name,
                              latitude,
                              longitude,
                              sido,
                              gugun,
                              UniqueKey(),
                            );
                          }
                        });
                      },
                      icon: const Icon(Icons.search),
                      label: const Text(
                        '검색 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                      onPressed: () {
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
                                  child: const Text('확인',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
                            );
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      label: const Text(
                        '마커 추가',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
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
                  ElevatedButton.icon(
                    icon: const Icon(Icons.verified),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // 코스 저장여부 확인 코드 시작 check //
                      // GetX에서 CourseController 가져오기
                      final CourseController courseController =
                          Get.find<CourseController>();

                      // courseController 내부의 값들 출력하기
                      print(courseController.title);
                      print(courseController.locationList);
                      print(courseController.locationList[0].name);
                      print(courseController.locationList[1].name);
                      print(courseController.locationList[2].name);
                      print(courseController.locationList[3].name);
                      // print(courseController.locationList[4].name);
                      print(courseController.locationList[0].title);
                      print(courseController.locationList[0].sido);
                      print(courseController.locationList[1].sido);
                      print(courseController.locationList[2].sido);
                      print(courseController.locationList[3].sido);
                      print(courseController.locationList[4].sido);
                      print(courseController.locationList[0].gugun);
                      print(courseController.locationList[1].gugun);
                      print(courseController.locationList[2].gugun);
                      print(courseController.locationList[3].gugun);
                      print(courseController.locationList[4].gugun);
                      print(courseController.locationList[1].content);
                      // print(courseController.locationList[0].name);
                      // print(courseController.locationList[1].name);
                      // print(courseController.locationList[2].name);
                      // print(courseController.locationList[3].name);
                      // 코스 저장여부 확인 코드 끝 check //
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('정말로 작성이 완료 되었나요?'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('작성하신 내용을 저장하시겠습니까?'),
                                const SizedBox(height: 8),
                                Text('작성한 장소 ${_items.length}곳:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red)),
                                const SizedBox(height: 8),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _items
                                      .map((item) => Text(
                                            '- ${item.name}',
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MakeStepper()),
                                  );
                                },
                                child: const Text('저장'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('취소'),
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

    final String _apiKey = dotenv.get('GOOGLE_MAP_API_KEY');

    final String _imgUrl =
        "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=${data.latitude},${data.longitude}&fov=90&heading=235&pitch=10&key=$_apiKey";

    if (state == frl.ReorderableItemState.dragProxy ||
        state == frl.ReorderableItemState.dragProxyFinished) {
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
              padding: const EdgeInsets.only(right: 18.0, left: 18.0),
              color: const Color(0x08000000),
              child: const Center(
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
                  padding:
                      EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
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
                                  builder: (context) =>
                                      EditItemPage(locationData: data),
                                ),
                              );
                              // },
                            },
                            icon: Icon(Icons.edit),
                            label: Text('추가 정보 작성'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              onDelete();
                            },
                            icon: Icon(Icons.delete),
                            label: Text('장소 삭제'),
                            style: ElevatedButton.styleFrom(
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
          image: NetworkImage(_imgUrl),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          image,
          content,
        ],
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
    final List<LatLng> positions =
        items.map((item) => LatLng(item.latitude, item.longitude)).toList();
    final List<Future<BitmapDescriptor>> futures = [
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'assets/marker1.png'),
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'assets/marker2.png'),
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'assets/marker3.png'),
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'assets/marker4.png'),
      BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(24, 24)), 'assets/marker5.png'),
    ];
    final Future<List<BitmapDescriptor>> markersFuture = Future.wait(futures);
    return FutureBuilder<List<BitmapDescriptor>>(
        future: markersFuture,
        builder: (BuildContext context,
            AsyncSnapshot<List<BitmapDescriptor>> snapshot) {
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
