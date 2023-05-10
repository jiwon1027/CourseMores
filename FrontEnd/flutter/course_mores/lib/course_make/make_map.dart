import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CMMap extends StatefulWidget {
  const CMMap({super.key});

  @override
  State<CMMap> createState() => _CMMapState();
}

class _CMMapState extends State<CMMap> {
  final Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;
  // LatLng? _selectedLocation;
  String _locationName = '';
  double _latitude = 0;
  double _longitude = 0;
  String _sido = '';
  String _gugun = '';

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

  void _onTap(LatLng location) async {
    // Add marker
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected-location'),
          position: location,
          icon: customIcon,
        ),
      );
    });
    // Get address and show in bottom sheet
    String address = await _getAddress(location.latitude, location.longitude);
    final String apiKey = dotenv.get('GOOGLE_MAP_API_KEY');
    final String url =
        "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=${location.latitude},${location.longitude}&fov=90&heading=235&pitch=10&key=$apiKey";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Expanded(child: SizedBox(height: 200, child: Image.network(url))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(address),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // 저장 버튼 클릭 시, _selectedLocation 변수에 현재 선택한 위치 값을 사용할 수 있습니다.
                      _onSavePressed();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('해당 위치 저장'),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.backspace),
                      label: Text('뒤로 가기'))
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }

  Future<String> _getAddress(double lat, double lon) async {
    final List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    if (placemarks != null && placemarks.isNotEmpty) {
      final geocoding.Placemark place = placemarks.first;
      final String thoroughfare = place.thoroughfare ?? '';
      final String subThoroughfare = place.subThoroughfare ?? '';
      final String locality = place.locality ?? '';
      final String subLocality = place.subLocality ?? '';
      final String administrativeArea = place.administrativeArea ?? '';
      return '$administrativeArea $locality $subLocality $thoroughfare $subThoroughfare';
    }
    return '';
  }

  // 시도, 구군 정보 따로 저장하는 과정
  Future<String> _getSido(double lat, double lon) async {
    final List<geocoding.Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko');
    if (placemarks != null && placemarks.isNotEmpty) {
      final geocoding.Placemark place = placemarks.first;
      final String administrativeArea = place.administrativeArea ?? '';
      return '$administrativeArea';
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
      return '$locality $subLocality';
    }
    return '';
  }

  void _onMyLocationButtonPressed() async {
    final position = await Geolocator.getCurrentPosition();
    final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 17);
    _mapController?.animateCamera(cameraUpdate);
  }

  void _onSavePressed() async {
    final selectedMarker = _markers.first;
    final latitude = selectedMarker.position.latitude;
    final longitude = selectedMarker.position.longitude;

    String address = await _getAddress(latitude, longitude);
    String sido = await _getSido(latitude, longitude);
    String gugun = await _getGugun(latitude, longitude);
    setState(() {
      _locationName = address;
      _latitude = latitude;
      _longitude = longitude;
      _sido = sido;
      _gugun = gugun;
    });

    // Show alert dialog to get the name of the location
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String locationName = '';
        return AlertDialog(
          title: Text('이 장소의 이름을 입력하세요.'),
          content: TextField(
            onChanged: (value) {
              locationName = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                // Save location with the entered name
                String message =
                    '위치 이름: $locationName\n위도: $latitude, 경도: $longitude';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(message),
                ));
                // Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.pop(context, {
                  'locationName': locationName,
                  'latitude': latitude,
                  'longitude': longitude,
                  'sido': sido,
                  'gugun': gugun,
                });
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            Text('누르면 마커가 생겨요',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
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
