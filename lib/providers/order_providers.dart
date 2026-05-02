import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import '../models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  
  Future<void> placeOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
  }) async {
    final doc = _firestore.collection('orders').doc();

    final order = OrderModel(
      id: doc.id,
      userId: userId,

      
      items: items,

      total: total,
      status: 'pending',

      paymentMethod: paymentMethod,
      paymentStatus: paymentMethod == "cod" ? "unpaid" : "paid",

      riderId: "",
      riderName: "",
      riderPhone: "",

      createdAt: DateTime.now(),
    );

    await doc.set(order.toMap());

    _orders.insert(0, order);
    notifyListeners();
  }

  
  void fetchOrders(String userId) {
    _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data()))
          .toList();

      notifyListeners();
    });
  }

  
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });

    final index = _orders.indexWhere((o) => o.id == orderId);

    if (index != -1) {
      final old = _orders[index];

      _orders[index] = OrderModel(
        id: old.id,
        userId: old.userId,
        items: old.items,
        total: old.total,
        status: status,
        paymentMethod: old.paymentMethod,
        paymentStatus: old.paymentStatus,
        riderId: old.riderId,
        riderName: old.riderName,
        riderPhone: old.riderPhone,
        createdAt: old.createdAt,
      );

      notifyListeners();
    }
  }

  
  Future<void> assignRider({
    required String orderId,
    required String riderId,
    required String riderName,
    required String riderPhone,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'riderId': riderId,
      'riderName': riderName,
      'riderPhone': riderPhone,
    });

    final index = _orders.indexWhere((o) => o.id == orderId);

    if (index != -1) {
      final old = _orders[index];

      _orders[index] = OrderModel(
        id: old.id,
        userId: old.userId,
        items: old.items,
        total: old.total,
        status: old.status,
        paymentMethod: old.paymentMethod,
        paymentStatus: old.paymentStatus,
        riderId: riderId,
        riderName: riderName,
        riderPhone: riderPhone,
        createdAt: old.createdAt,
      );

      notifyListeners();
    }
  }
}