import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoogleMapsTrackingScreen extends StatelessWidget {
  final String orderId;

  const GoogleMapsTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Tracking")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final riderLat = data["riderLat"] ?? 0.0;
          final riderLng = data["riderLng"] ?? 0.0;

          final destLat = data["destinationLat"] ?? 0.0;
          final destLng = data["destinationLng"] ?? 0.0;

          final rider = LatLng(riderLat, riderLng);
          final destination = LatLng(destLat, destLng);

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: rider,
              zoom: 14,
            ),

            markers: {
              Marker(
                markerId: const MarkerId("rider"),
                position: rider,
                infoWindow: const InfoWindow(title: "Rider"),
              ),
              Marker(
                markerId: const MarkerId("destination"),
                position: destination,
                infoWindow: const InfoWindow(title: "You"),
              ),
            },

            myLocationEnabled: true,
            zoomControlsEnabled: false,
          );
        },
      ),
    );
  }
}