import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  
  static const _statusFlow = ['pending', 'preparing', 'delivered'];

  static Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'preparing':
        return const Color(0xFF2196F3);
      case 'delivered':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  static IconData _statusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'preparing':
        return Icons.coffee_maker_rounded;
      case 'delivered':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline;
    }
  }

  static String _nextStatus(String current) {
    final idx = _statusFlow.indexOf(current);
    if (idx == -1 || idx >= _statusFlow.length - 1) return current;
    return _statusFlow[idx + 1];
  }

  static String _nextStatusLabel(String current) {
    switch (current) {
      case 'pending':
        return 'Mark as Preparing';
      case 'preparing':
        return 'Mark as Delivered';
      default:
        return '';
    }
  }

  
  Future<void> _updateStatus(
    BuildContext context,
    String orderId,
    String currentStatus,
  ) async {
    final next = _nextStatus(currentStatus);
    if (next == currentStatus) return;

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': next});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order updated to "$next" ✅'),
            backgroundColor: _statusColor(next),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: Colors.white,
        title: const Text(
          '☕ Admin — Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
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
                  Icon(Icons.inbox_rounded, size: 80, color: Colors.brown),
                  SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, color: Colors.brown),
                  ),
                ],
              ),
            );
          }

          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final orderId = doc.id;
              final status = data['status'] ?? 'pending';
              final customerName =
                  data['customerName'] ?? data['userName'] ?? 'Customer';
              final totalPrice = data['totalPrice'] ?? data['total'] ?? 0;
              final items = data['items'] as List<dynamic>? ?? [];
              final createdAt = data['createdAt'] as Timestamp?;
              final dateStr = createdAt != null
                  ? _formatDate(createdAt.toDate())
                  : 'N/A';

              return _OrderCard(
                orderId: orderId,
                customerName: customerName,
                status: status,
                totalPrice: totalPrice,
                items: items,
                dateStr: dateStr,
                statusColor: _statusColor(status),
                statusIcon: _statusIcon(status),
                nextLabel: _nextStatusLabel(status),
                onAdvance: status == 'delivered'
                    ? null
                    : () => _updateStatus(context, orderId, status),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}


class _OrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String status;
  final dynamic totalPrice;
  final List<dynamic> items;
  final String dateStr;
  final Color statusColor;
  final IconData statusIcon;
  final String nextLabel;
  final VoidCallback? onAdvance;

  const _OrderCard({
    required this.orderId,
    required this.customerName,
    required this.status,
    required this.totalPrice,
    required this.items,
    required this.dateStr,
    required this.statusColor,
    required this.statusIcon,
    required this.nextLabel,
    required this.onAdvance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Text(
                  dateStr,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    const Icon(Icons.person_rounded,
                        size: 18, color: Color(0xFF3E2723)),
                    const SizedBox(width: 6),
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Order ID: ${orderId.substring(0, 8).toUpperCase()}...',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),

                
                if (items.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  ...items.map((item) {
                    final itemMap = item as Map<String, dynamic>;
                    final name = itemMap['name'] ?? itemMap['productName'] ?? 'Item';
                    final qty = itemMap['quantity'] ?? itemMap['qty'] ?? 1;
                    final price = itemMap['price'] ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text('× $qty',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(name,
                                style: const TextStyle(fontSize: 14)),
                          ),
                          Text(
                            '₱${price}',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Total: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '₱$totalPrice',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                  ],
                ),

                
                if (onAdvance != null) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAdvance,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text(nextLabel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded,
                            color: Color(0xFF4CAF50), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Order Completed',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}