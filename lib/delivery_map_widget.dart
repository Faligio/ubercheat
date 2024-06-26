import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DeliveryMapWidget extends StatefulWidget {
  final LatLng center;
  final VoidCallback onRefresh;

  const DeliveryMapWidget({Key? key, required this.center, required this.onRefresh}) : super(key: key);

  @override
  State<DeliveryMapWidget> createState() => _DeliveryMapWidgetState();
}

class _DeliveryMapWidgetState extends State<DeliveryMapWidget> {
  Set<Marker> _markers = {};
  List<String> driverImages = [
    'https://i.ibb.co/82mMXdf/jo-driver-removebg-preview-1.png',
    'https://i.ibb.co/0Zf2K7w/tofu-driver-removebg-preview-2.png',
  ];

  List<Driver> drivers = [
    Driver(firstName: 'Jo', lastName: 'Smith', rating: 4.5, phoneNumber: '+330601040553', priceDetails: '15€/hour'),
    Driver(firstName: 'Tofu', lastName: 'Jones', rating: 4.7, phoneNumber: '987654321', priceDetails: '18€/hour'),
    // Add more driver info here
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _addRandomMarkers(widget.center);
    });
  }

  void _addRandomMarkers(LatLng center) async {
    final randomMarkers = await _generateRandomMarkers(5, center);
    setState(() {
      _markers = randomMarkers;
    });
  }

  Future<Set<Marker>> _generateRandomMarkers(int count, LatLng center) async {
    Set<Marker> markers = {};
    Random random = Random();
    for (int i = 0; i < count; i++) {
      double lat = center.latitude + (random.nextDouble() * 0.1 - 0.05);
      double lng = center.longitude + (random.nextDouble() * 0.1 - 0.05);
      LatLng position = LatLng(lat, lng);
      BitmapDescriptor icon = await _bitmapDescriptorFromUrl(i);
      markers.add(Marker(
        markerId: MarkerId('livreur$i'),
        position: position,
        icon: icon,
        onTap: () => _showModalBottomSheet(context, i),
      ));
    }
    return markers;
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromUrl(int index) async {
    try {
      String imageUrl = index < driverImages.length ? driverImages[index] : 'https://via.placeholder.com/150';
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List byteData = response.bodyBytes;
      return BitmapDescriptor.fromBytes(byteData);
    } catch (e) {
      print("Erreur lors du chargement de l'image : $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

void _showModalBottomSheet(BuildContext context, int index) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // S'ajuste à la taille du contenu
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${drivers[index].firstName} ${drivers[index].lastName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('⭐ ${drivers[index].rating}', style: TextStyle(fontSize: 18, color: Colors.amber)),
              ],
            ),
            SizedBox(height: 10),
            Text('Pricing: ${drivers[index].priceDetails}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.phone, color: Colors.white),
                    label: Text('Call'),
                    onPressed: () => _makePhoneCall(drivers[index].phoneNumber),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.message, color: Colors.white),
                    label: Text('Message'),
                    onPressed: () => _sendMessage(drivers[index].phoneNumber),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


void _makePhoneCall(String phoneNumber) async {
  final Uri url = Uri.parse('tel:$phoneNumber');
  print('Trying to launch $url');  // Log the URL to debug

  try {
    final bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
    print('Launch success: $launched');
  } catch (e) {
    print('Failed to launch $url with error: $e');
    throw 'Could not launch $url';
  }
}


  void _sendMessage(String phoneNumber) async {
    final Uri url = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {},
      initialCameraPosition: CameraPosition(target: widget.center, zoom: 14.0),
      markers: _markers,
    );
  }
}

class Driver {
  final String firstName;
  final String lastName;
  final double rating;
  final String phoneNumber;
  final String priceDetails;

  Driver({required this.firstName, required this.lastName, required this.rating, required this.phoneNumber, required this.priceDetails});
}
