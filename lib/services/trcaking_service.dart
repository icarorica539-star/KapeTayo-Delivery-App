import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> trackOrder(String orderId) {
    return _firestore.collection('orders').doc(orderId).snapshots();
  }

  Future<void> updateStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  Future<void> assignRider(String orderId, Map<String, dynamic> rider) async {
    await _firestore.collection('orders').doc(orderId).update({
      'riderName': rider['name'],
      'riderPhone': rider['phone'],
    });
  }
}