import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CMSearch extends StatefulWidget {
  const CMSearch({super.key});

  @override
  State<CMSearch> createState() => _CMSearchState();
}

class _CMSearchState extends State<CMSearch> {
  final _placesApiClient = GoogleMapsPlaces(apiKey: dotenv.get('GOOGLE_MAP_API_KEY'));
  final _searchController = TextEditingController();
  List<PlacesSearchResult> _searchResults = [];

  LatLng? _selectedLocation;

  void _onSearchPressed() async {
    final response = await _placesApiClient.searchByText(_searchController.text, language: 'ko');
    if (response.isOkay) {
      setState(() {
        _searchResults = response.results;
      });
    }
  }

  void _onSearchChanged(String value) async {
    final response = await _placesApiClient.searchByText(value, language: 'ko');
    if (response.isOkay) {
      setState(() {
        _searchResults = response.results;
      });
    }
  }

  void _onPlaceSelected(PlacesSearchResult selectedPlace) {
    if (selectedPlace.geometry == null) {
      // 예외 처리: 선택된 장소에 대한 위치 정보가 없음
      return;
    }
    setState(() {
      _selectedLocation = LatLng(
        selectedPlace.geometry!.location.lat,
        selectedPlace.geometry!.location.lng,
      );
    });
    Navigator.pop(context, selectedPlace);
    print(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 80, 170, 208),
        leading: IconButton(
          icon: Icon(Icons.navigate_before, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: RichText(
              text: const TextSpan(
            children: [
              // WidgetSpan(child: Icon(Icons.edit_note, color: Colors.white)),
              WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(
                text: '장소 검색으로 추가하기',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ],
          )),
        ),
        // 피그마와 모양 맞추려고 close 아이콘 하나 넣어둠
        // <와 X 중 하나만 있어도 될 것 같아서 상의 후 삭제 필요
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close, color: Colors.white)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(hintText: ' 찾으시려는 장소를 입력하세요'),
                    onChanged: _onSearchChanged,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearchPressed,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color.fromARGB(255, 119, 181, 212)), // 버튼의 배경색을 설정
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      // 버튼의 모양을 둥글게 만듭니다
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // 둥근 모서리의 반경을 설정
                      ),
                    ),
                  ),
                  child: Text('검색'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.formattedAddress ?? ''),
                  onTap: () => _onPlaceSelected(place),
                );
              },
            ),
          ),
          if (_selectedLocation != null) Text('선택된 장소: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}')
        ],
      ),
    );
  }
}
