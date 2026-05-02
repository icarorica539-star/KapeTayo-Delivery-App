import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        title: const Text("My Orders ☕"),
      ),
      body: user == null
          ? const Center(child: Text("Please login first"))
          : StreamBuilder<QuerySnapshot>(
              
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {

                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 80, color: Colors.brown),
                        SizedBox(height: 16),
                        Text(
                          "No orders yet 😢",
                          style: TextStyle(fontSize: 18, color: Colors.brown),
                        ),
                      ],
                    ),
                  );
                }

                
                final orders = docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  try {
                    return OrderModel.fromMap({
                      ...data,
                      'id': doc.id,
                      'createdAt': (data['createdAt'] as Timestamp?)
                              ?.toDate()
                              .toIso8601String() ??
                          DateTime.now().toIso8601String(),
                    });
                  } catch (e) {
                    debugPrint('❌ Error parsing order ${doc.id}: $e');
                    return null;
                  }
                })
                .whereType<OrderModel>() 
                .toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); 

                if (orders.isEmpty) {
                  return const Center(child: Text("No orders yet 😢"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final status = order.status;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          "Order #${order.id?.substring(0, 8).toUpperCase() ?? 'N/A'}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _statusLabel(status),
                          style: TextStyle(
                            color: _statusColor(status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Text(
                          "₱${order.total.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "Date: ${_formatDate(order.createdAt)}",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),

                                const SizedBox(height: 10),
                                const Divider(height: 1),
                                const SizedBox(height: 10),

                                const Text(
                                  "Items:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 5),

                                ...order.items.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      children: [
                                        const Text("• ", style: TextStyle(color: Colors.brown)),
                                        Expanded(
                                          child: Text(
                                            "${item.coffee.name} x${item.quantity} (${item.size.name})",
                                          ),
                                        ),
                                        Text(
                                          "₱${item.totalPrice.toStringAsFixed(2)}",
                                          style: const TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  );
                                }),

                                const SizedBox(height: 10),
                                const Divider(height: 1),
                                const SizedBox(height: 8),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Payment: ${order.paymentMethod.toUpperCase()}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: order.paymentStatus == 'paid'
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        order.paymentStatus.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: order.paymentStatus == 'paid'
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case "pending":   return "🕐 Order Placed";
      case "preparing": return "☕ Preparing Your Coffee";
      case "delivered": return "🎉 Delivered";
      default:          return "Unknown";
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case "pending":   return Colors.orange;
      case "preparing": return Colors.blue;
      case "delivered": return Colors.green;
      default:          return Colors.grey;
    }
  }

  String _formatDate(DateTime dt) {
    return "${dt.month}/${dt.day}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}