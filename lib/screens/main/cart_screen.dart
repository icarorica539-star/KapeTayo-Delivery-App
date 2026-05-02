import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../main/delivery_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF2E1F1A);
    const accentColor = Color(0xFFD7A86E);
    const cardColor = Color(0xFF3B2A24);
    const textColor = Color(0xFFF5E6D3);

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final user = Provider.of<AuthProvider>(context).user;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text("Your Cart ☕"),
            backgroundColor: const Color(0xFF6F4E37),
            foregroundColor: textColor,
          ),
          body: cart.items.isEmpty
              ? const Center(
                  child: Text(
                    "Your cart is empty 😔",
                    style: TextStyle(color: textColor, fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];

                          return Card(
                            color: cardColor,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(
                                item.coffee.name,
                                style: const TextStyle(color: textColor),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₱${item.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    "${item.size.name.toUpperCase()} • ${item.temperature.name.toUpperCase()}",
                                    style: const TextStyle(color: Colors.white54),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: accentColor),
                                    onPressed: item.id == null
                                        ? null
                                        : () => cart.decreaseQuantity(item.id, item),
                                  ),
                                  Text(
                                    "${item.quantity}",
                                    style: const TextStyle(color: textColor),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: accentColor),
                                    onPressed: item.id == null
                                        ? null
                                        : () => cart.increaseQuantity(item.id, item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: item.id == null
                                        ? null
                                        : () => cart.removeItem(item.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: const Color(0xFF6F4E37),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: ₱${cart.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: cart.items.isEmpty || user == null
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const DeliveryScreen(),
                                      ),
                                    );
                                  },
                            child: const Text("Checkout"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}