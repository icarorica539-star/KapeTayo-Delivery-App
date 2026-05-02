import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main/home_screen.dart'; // ✅ correct import

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Your Order")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {

          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Order not found ❌"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'pending';

          if (status == "pending") {
            return _pendingUI();
          } else {
            return _successUI(context, status);
          }
        },
      ),
    );
  }

  
  Widget _pendingUI() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 100, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            "Order Placed...",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Waiting for confirmation ☕"),
        ],
      ),
    );
  }

  
  Widget _successUI(BuildContext context, String status) {
    String message;
    String subText;
    IconData icon;
    Color iconColor;

    if (status == "preparing") {
      message = "Preparing your coffee ☕";
      subText = "Please wait while we make your order";
      icon = Icons.coffee_maker_rounded;
      iconColor = Colors.blue;
    } else if (status == "delivered") {
      message = "Delivered 🎉";
      subText = "Enjoy your coffee!";
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else {
      message = "Order Updated";
      subText = "";
      icon = Icons.check_circle;
      iconColor = Colors.green;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(icon, size: 100, color: iconColor),

            const SizedBox(height: 20),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              subText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text("Back to Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}