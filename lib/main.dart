import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bottom_nav_bar.dart';
import 'floating_location_button.dart';
import 'package:geolocator/geolocator.dart';
import 'custom_marker.dart';
import 'faq_page.dart';
import 'profile_page.dart';
import 'delivery_map_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late GoogleMapController _controller;
  late Marker _locationMarker;
  late Circle _locationCircle;
  LatLng _currentCenter = const LatLng(48.8566, 2.3522);

  final List<Widget> _widgetOptions = [
    SizedBox(),
    const FaqPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserLocation();
  }

  void _initializeUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentCenter = LatLng(position.latitude, position.longitude);
    _initializeMap();
  }

  void _initializeMap() async {
    _locationMarker = await CustomMarker.createCustomMarker(_currentCenter);
    _locationCircle = Circle(
      circleId: const CircleId("locationCircle"),
      center: _currentCenter,
      radius: 100,
      strokeColor: Colors.transparent,
    );

    _widgetOptions[0] = MyGoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
      onCameraMove: (LatLng center) {
        _currentCenter = center;
      },
      marker: _locationMarker,
      circle: _locationCircle,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onShowDeliveryPersonsPressed() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    _refreshMarkers(currentLocation);
  }

  void _refreshMarkers(LatLng center) {
    setState(() {
      _widgetOptions[0] = DeliveryMapWidget(
        center: center,
        onRefresh: () => _refreshMarkers(center),
      );
    });
  }

  void _onFloatingButtonPressed() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    CameraPosition currentCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 15,
    );

    _controller.animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
    _updateMarker(position);
  }

  void _updateMarker(Position position) async {
    _locationMarker = await CustomMarker.createCustomMarker(LatLng(position.latitude, position.longitude));
    setState(() {
      _widgetOptions[0] = MyGoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        marker: _locationMarker,
        circle: _locationCircle,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0 ? Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: FloatingLocationButton(
              onPressed: _onFloatingButtonPressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 100),
            child: FloatingActionButton(
              onPressed: _onShowDeliveryPersonsPressed,
              child: const Icon(Icons.delivery_dining),
              backgroundColor: Colors.grey,
            ),
          ),
        ],
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class MyGoogleMap extends StatelessWidget {
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onCameraMove;
  final Marker marker;
  final Circle circle;

  const MyGoogleMap({Key? key, this.onMapCreated, this.onCameraMove, required this.marker, required this.circle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      onCameraMove: (CameraPosition position) {
        onCameraMove?.call(position.target);
      },
      initialCameraPosition: const CameraPosition(
        target: LatLng(48.8566, 2.3522),
        zoom: 12,
      ),
      markers: {marker},
      circles: {circle},
    );
  }
}
