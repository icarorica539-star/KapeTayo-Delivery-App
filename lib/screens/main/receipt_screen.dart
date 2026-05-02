import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const ReceiptScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order['items'] as List;

    return Scaffold(
      appBar: AppBar(title: const Text("Receipt 🧾")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Summary",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            ...items.map((item) {
              return ListTile(
                title: Text(item['coffeeName']),
                subtitle: Text(
                    "${item['size']} • ${item['temperature']}"),
                trailing: Text("₱${item['itemTotal']}"),
              );
            }),

            const Divider(),

            Text(
              "Total: ₱${order['total']}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}