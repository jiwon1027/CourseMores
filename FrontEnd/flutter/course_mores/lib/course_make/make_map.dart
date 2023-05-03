import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CMMap extends StatefulWidget {
  const CMMap({super.key});

  @override
  State<CMMap> createState() => _CMMapState();
}

class _CMMapState extends State<CMMap> {
  final Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;
  // LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(30, 40)), 'assets/flower_marker.png')
        .then((icon) => customIcon = icon);
  }

  GoogleMapController? _mapController;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    // 위치 권한 확인
    LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentPosition = LatLng(position.latitude, position.longitude);

    // 현재 위치 마커 추가
    // setState(() {
    //   _markers.add(
    //     Marker(
    //       markerId: MarkerId('current-position'),
    //       position: currentPosition,
    //       icon:
    //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    //     ),
    //   );
    // });

    // 카메라 이동
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentPosition,
          zoom: 15.0,
        ),
      ),
    );
  }

  void _onTap(LatLng location) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected-location'),
          position: location,
          icon: customIcon,
        ),
      ); // _selectedLocation = location;
    });
  }

  void _onMyLocationButtonPressed() async {
    final position = await Geolocator.getCurrentPosition();
    final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 17);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onSavePressed() {
    final selectedMarker = _markers.first;
    final latitude = selectedMarker.position.latitude;
    final longitude = selectedMarker.position.longitude;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('위도: $latitude, 경도: $longitude'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              text: '지도 마커로 추가하기',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(37.5665, 126.9780),
                    zoom: 10,
                  ),
                  markers: _markers,
                  onTap: _onTap,
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: false, // 현재 위치 버튼 숨기기
                  myLocationEnabled: true, // 현재 위치 파란색 마커로 표시
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    // 저장 버튼 클릭 시, _selectedLocation 변수에 현재 선택한 위치 값을 사용할 수 있습니다.
                    _onSavePressed();
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('해당 위치 저장'),
                  elevation: 15,
                ),
                FloatingActionButton(
                  onPressed: _onMyLocationButtonPressed,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
