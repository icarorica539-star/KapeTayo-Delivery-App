import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RiderLocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Position> streamLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }

  void startUpdating(String riderId) {
    streamLocation().listen((position) {
      _firestore.collection('riders').doc(riderId).update({
        'lat': position.latitude,
        'lng': position.longitude,
      });
    });
  }
}