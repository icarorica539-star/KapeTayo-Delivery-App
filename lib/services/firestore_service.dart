import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  Stream<List<CartItem>> getItems() {
    return _db.collection('cart').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CartItem.fromMap({
          ...doc.data(),
          'id': doc.id, 
        });
      }).toList();
    });
  }

 
  Future<void> addItem(CartItem item) async {
    await _db.collection('cart').add(item.toMap());
  }

  
  Future<void> updateItem(String id, CartItem item) async {
    await _db.collection('cart').doc(id).update(item.toMap());
  }

  
  Future<void> deleteItem(String id) async {
    await _db.collection('cart').doc(id).delete();
  }

  
  Future<void> clearCart() async {
    final snapshot = await _db.collection('cart').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}