import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class OrderModel {
  final String? id;
  final String userId;

  
  final String paymentMethod; 
  final String paymentStatus; 

  
  final List<CartItem> items;

  final double total;

  
  final String status;

  
  final String riderId;
  final String riderName;
  final String riderPhone;

  final DateTime createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.paymentMethod,
    this.paymentStatus = "unpaid",
    this.riderId = "",
    this.riderName = "",
    this.riderPhone = "",
    required this.createdAt,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,

      
      'items': items.map((item) => item.toMap()).toList(),

      'total': total,
      'status': status,

      
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,

      
      'riderId': riderId,
      'riderName': riderName,
      'riderPhone': riderPhone,

      
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }


  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['userId'] ?? '',

      
      items: (map['items'] as List? ?? [])
          .map((item) => CartItem.fromMap(item))
          .toList(),

      total: (map['total'] is int)
          ? (map['total'] as int).toDouble()
          : (map['total'] ?? 0).toDouble(),

      status: map['status'] ?? 'pending',

      
      paymentMethod: map['paymentMethod'] ?? 'cod',
      paymentStatus: map['paymentStatus'] ?? 'unpaid',

      
      riderId: map['riderId'] ?? '',
      riderName: map['riderName'] ?? '',
      riderPhone: map['riderPhone'] ?? '',

      
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
              DateTime.now(),
    );
  }
}