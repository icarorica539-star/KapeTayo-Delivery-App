import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/coffee.dart';
import '../models/add_on.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _db = FirestoreService();

  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  StreamSubscription? _sub;

  
  final List<Timer> _statusTimers = [];

  
  void init() {
    _sub?.cancel();

    _sub = _db.getItems().listen((data) {
      _items = data;
      notifyListeners();
    });
  }


  Future<void> addToCart(
    Coffee coffee, {
    CoffeeSize size = CoffeeSize.medium,
    CoffeeTemperature temperature = CoffeeTemperature.hot,
    List<AddOn> addOns = const [],
  }) async {
    final index = _items.indexWhere((item) =>
        item.coffee.id == coffee.id &&
        item.size == size &&
        item.temperature == temperature);

    if (index != -1) {
      final item = _items[index];
      await _db.updateItem(
        item.id!,
        item.copyWith(quantity: item.quantity + 1),
      );
    } else {
      await _db.addItem(
        CartItem(
          coffee: coffee,
          size: size,
          temperature: temperature,
          addOns: addOns,
          quantity: 1,
        ),
      );
    }
  }

  
  Future<void> removeItem(String? id) async {
    if (id == null) return;
    await _db.deleteItem(id);
  }

  
  Future<void> increaseQuantity(String? id, CartItem item) async {
    if (id == null) return;
    await _db.updateItem(id, item.copyWith(quantity: item.quantity + 1));
  }

  
  Future<void> decreaseQuantity(String? id, CartItem item) async {
    if (id == null) return;

    if (item.quantity > 1) {
      await _db.updateItem(id, item.copyWith(quantity: item.quantity - 1));
    } else {
      await _db.deleteItem(id);
    }
  }

  
  Future<void> clearCart() async {
    await _db.clearCart();
  }

  
  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  
  Future<String?> checkout({
    required String userId,
    required String paymentMethod,
    Map<String, dynamic> extraData = const {}, 
  }) async {
    if (_items.isEmpty) return null;

    try {
      
      final orderRef =
          await FirebaseFirestore.instance.collection('orders').add({
        'userId': userId,
        'items': _items.map((e) => e.toMap()).toList(),
        'total': totalPrice,
        'status': 'pending',
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentMethod == "cod" ? "unpaid" : "paid",
        'createdAt': FieldValue.serverTimestamp(),
        ...extraData, 
      });

      final orderId = orderRef.id;

      
      await clearCart();

      
      startAutoStatus(orderId);

      return orderId; 
    } catch (e) {
      debugPrint("Checkout error: $e");
      return null;
    }
  }

  
  void startAutoStatus(String orderId) {
    // pending → preparing after 10 seconds
    final t1 = Timer(const Duration(seconds: 10), () async {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .update({'status': 'preparing'});
        debugPrint('✅ Order $orderId → preparing');
      } catch (e) {
        debugPrint('❌ Failed to set preparing: $e');
      }
    });

   
    final t2 = Timer(const Duration(seconds: 30), () async {
      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .update({'status': 'delivered'});
        debugPrint('✅ Order $orderId → delivered');
      } catch (e) {
        debugPrint('❌ Failed to set delivered: $e');
      }
    });

    _statusTimers.addAll([t1, t2]);
  }

  
  @override
  void dispose() {
    _sub?.cancel();
    for (final timer in _statusTimers) {
      timer.cancel();
    }
    _statusTimers.clear();
    super.dispose();
  }
}