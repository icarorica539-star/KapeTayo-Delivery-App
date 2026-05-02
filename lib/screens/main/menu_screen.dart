import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/coffee_data.dart';
import '../../models/coffee.dart';
import '../../models/add_on.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import '../../widgets/coffee_card.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String selectedCategory = "All";
  String searchQuery = "";

  List<Coffee> get filteredCoffee {
    return CoffeeData.items.where((coffee) {
      final matchCategory =
          selectedCategory == "All" || coffee.category == selectedCategory;
      final matchSearch =
          coffee.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Menu ☕"),
        actions: [
          // ✅ Cart button with item count badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [

         
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search coffee...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _chip("All"),
                _chip("Coffee"),
                _chip("Non-Coffee"),
              ],
            ),
          ),

          const SizedBox(height: 10),

         
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredCoffee.length,
              itemBuilder: (context, index) {
                final coffee = filteredCoffee[index];
                return CoffeeCard(
                  coffee: coffee,
                  onAdd: () => _showAddonSheet(context, coffee, cart),
                );
              },
            ),
          ),
        ],
      ),

      
      floatingActionButton: cart.items.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              backgroundColor: const Color(0xFF3E2723),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                "Cart (${cart.items.length}) — ₱${cart.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  Widget _chip(String text) {
    final isSelected = selectedCategory == text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        label: Text(text),
        selected: isSelected,
        onSelected: (_) => setState(() => selectedCategory = text),
      ),
    );
  }

  
  void _showAddonSheet(
    BuildContext context,
    Coffee coffee,
    CartProvider cart,
  ) {
    CoffeeSize selectedSize = CoffeeSize.medium;
    CoffeeTemperature selectedTemp = CoffeeTemperature.hot;
    List<AddOn> selectedAddons = [];

    final addons = [
      AddOn(id: "1", name: "Extra Shot", price: 20),
      AddOn(id: "2", name: "Vanilla Syrup", price: 15),
      AddOn(id: "3", name: "Caramel Syrup", price: 15),
      AddOn(id: "4", name: "Whipped Cream", price: 10),
    ];

    double basePrice() {
      switch (selectedSize) {
        case CoffeeSize.small:  return coffee.basePrice;
        case CoffeeSize.medium: return coffee.basePrice + 20;
        case CoffeeSize.large:  return coffee.basePrice + 40;
      }
    }

    double addonPrice() =>
        selectedAddons.fold(0, (sum, e) => sum + e.price);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final total = basePrice() + addonPrice();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coffee.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    
                    const Text("Size", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: CoffeeSize.values.map((size) {
                        return Expanded(
                          child: RadioListTile<CoffeeSize>(
                            title: Text(size.name),
                            value: size,
                            groupValue: selectedSize,
                            onChanged: (value) =>
                                setState(() => selectedSize = value!),
                          ),
                        );
                      }).toList(),
                    ),

                    
                    const Text("Temperature", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: CoffeeTemperature.values.map((temp) {
                        return Expanded(
                          child: RadioListTile<CoffeeTemperature>(
                            title: Text(temp.name),
                            value: temp,
                            groupValue: selectedTemp,
                            onChanged: (value) =>
                                setState(() => selectedTemp = value!),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    const Text("Add-ons", style: TextStyle(fontWeight: FontWeight.bold)),

                    Expanded(
                      child: ListView.builder(
                        itemCount: addons.length,
                        itemBuilder: (context, index) {
                          final addon = addons[index];
                          final isSelected =
                              selectedAddons.any((a) => a.id == addon.id);

                          return CheckboxListTile(
                            title: Text(addon.name),
                            subtitle: Text("+₱${addon.price}"),
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  selectedAddons.add(addon);
                                } else {
                                  selectedAddons
                                      .removeWhere((a) => a.id == addon.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),

                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Total: ₱${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    
                    Row(
                      children: [
                        
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartScreen()),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: const Text("View Cart"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              cart.addToCart(
                                coffee,
                                size: selectedSize,
                                temperature: selectedTemp,
                                addOns: selectedAddons,
                              );
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${coffee.name} added to cart ☕"),
                                  duration: const Duration(seconds: 1),
                                  action: SnackBarAction(
                                    label: "View Cart",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const CartScreen()),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text("Add to Cart"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}