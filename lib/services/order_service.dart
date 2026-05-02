import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Future<void> createOrder(OrderModel order, String userId) async {
    try {
      final docRef = _firestore.collection('orders').doc(); // auto ID

      await docRef.set({
        ...order.toMap(), 
        'id': docRef.id,  
        'userId': userId, 
        'createdAt': FieldValue.serverTimestamp(), 
      });
    } catch (e) {
      throw Exception("Order failed: $e");
    }
  }

  
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return OrderModel.fromMap({
              ...data,
              'id': doc.id, 
              'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ??
                  DateTime.now().toIso8601String(),
            });
          }).toList();
        });
  }
}