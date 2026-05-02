import 'package:flutter/material.dart';
import '../models/coffee.dart';

class CoffeeCard extends StatelessWidget {
  final Coffee coffee;
  final VoidCallback onAdd;

  const CoffeeCard({
    super.key,
    required this.coffee,
    required this.onAdd,
  });

  double get basePrice => coffee.basePrice;
  double get mediumPrice => coffee.basePrice + 20;
  double get largePrice => coffee.basePrice + 40;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.asset(
                coffee.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          const SizedBox(height: 5),

        
          Text(
            coffee.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          
          Text(
            "From ₱${basePrice.toStringAsFixed(0)}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          
          const Text(
            "S ₱0 | M +₱20 | L +₱40",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),

          /// 🌡 HOT/COLD INFO
          const Text(
            "Hot / Cold available",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),

          const SizedBox(height: 5),

          
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
            ),
            child: const Text("Customize"),
          ),

          const SizedBox(height: 5),
        ],
      ),
    );
  }
}