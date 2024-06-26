import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker {
  static Future<BitmapDescriptor> createCustomMarkerIcon() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paintContour = Paint()..color = Colors.white;
    final Paint paintPoint = Paint()..color = Colors.blue;
    final Paint paintRadius = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(50, 50), 40, paintRadius);

    canvas.drawCircle(const Offset(50, 50), 25, paintContour);

    canvas.drawCircle(const Offset(50, 50), 20, paintPoint);

    final ui.Image image = await pictureRecorder.endRecording().toImage(100, 100);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  static Future<Marker> createCustomMarker(LatLng position) async {
    final icon = await createCustomMarkerIcon();
    return Marker(
      markerId: MarkerId('customMarker_${position.latitude}_${position.longitude}'),
      position: position,
      icon: icon,
    );
  }
}
