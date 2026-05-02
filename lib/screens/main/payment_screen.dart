import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../orders/order_tracking _screen.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final double total;
  final List items;

  const PaymentScreen({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.total,
    required this.items,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedMethod;
  bool isLoading = false;

  Future<void> placeOrder() async {
    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select payment method")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final cart = Provider.of<CartProvider>(context, listen: false);
      final user = Provider.of<AuthProvider>(context, listen: false).user;

      
      final orderId = await cart.checkout(
        userId: user?.uid ?? '',
        paymentMethod: selectedMethod!,
        
        extraData: {
          'name': widget.name,
          'address': widget.address,
          'phone': widget.phone,
        },
      );

      if (!mounted) return;

      if (orderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order failed. Please try again.")),
        );
        return;
      }

      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: orderId),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint("ORDER ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text("Name: ${widget.name}"),
            Text("Address: ${widget.address}"),
            Text("Phone: ${widget.phone}"),

            const SizedBox(height: 10),

            Text(
              "Total: ₱${widget.total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            
            const Text(
              "Select Payment Method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            RadioListTile(
              value: "cod",
              groupValue: selectedMethod,
              title: const Text("Cash on Delivery"),
              onChanged: (value) =>
                  setState(() => selectedMethod = value.toString()),
            ),

            RadioListTile(
              value: "gcash",
              groupValue: selectedMethod,
              title: const Text("GCash"),
              onChanged: (value) =>
                  setState(() => selectedMethod = value.toString()),
            ),

            const Spacer(),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : placeOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Place Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}