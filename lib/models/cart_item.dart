import 'coffee.dart';
import 'add_on.dart';

enum CoffeeSize { small, medium, large }
enum CoffeeTemperature { hot, cold }

class CartItem {
  final String? id;
  final Coffee coffee;
  final int quantity;
  final CoffeeSize size;
  final CoffeeTemperature temperature;
  final List<AddOn> addOns;

  CartItem({
    this.id,
    required this.coffee,
    this.quantity = 1,
    this.size = CoffeeSize.medium,
    this.temperature = CoffeeTemperature.hot,
    List<AddOn>? addOns,
  }) : addOns = List.unmodifiable(addOns ?? []);

  
  double get totalPrice {
    final basePrice = _getSizePrice();
    final addonsTotal = addOns.fold(0.0, (sum, a) => sum + a.price);
    return (basePrice + addonsTotal) * quantity;
  }

  double _getSizePrice() {
    switch (size) {
      case CoffeeSize.small:
        return coffee.basePrice;
      case CoffeeSize.medium:
        return coffee.basePrice + 20;
      case CoffeeSize.large:
        return coffee.basePrice + 40;
    }
  }

  
  CartItem copyWith({
    String? id,
    int? quantity,
    CoffeeSize? size,
    CoffeeTemperature? temperature,
    List<AddOn>? addOns,
  }) {
    return CartItem(
      id: id ?? this.id,
      coffee: coffee,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      temperature: temperature ?? this.temperature,
      addOns: addOns ?? this.addOns,
    );
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coffee': {
        'id': coffee.id,
        'name': coffee.name,
        'image': coffee.image,
        'basePrice': coffee.basePrice,
      },
      'quantity': quantity,
      'size': size.name,
      'temperature': temperature.name,
      'addOns': addOns.map((a) => {
            'id': a.id,
            'name': a.name,
            'price': a.price,
          }).toList(),
    };
  }

  
  factory CartItem.fromMap(Map<String, dynamic> map) {
    final coffeeMap = map['coffee'] ?? {};

    return CartItem(
      id: map['id'],
      coffee: Coffee(
        id: coffeeMap['id'] ?? '',
        name: coffeeMap['name'] ?? '',
        description: '',
        basePrice: (coffeeMap['basePrice'] ?? 0).toDouble(),
        image: coffeeMap['image'] ?? '',
        category: '',
      ),
      quantity: map['quantity'] ?? 1,
      size: CoffeeSize.values.firstWhere(
        (e) => e.name == map['size'],
        orElse: () => CoffeeSize.medium,
      ),
      temperature: CoffeeTemperature.values.firstWhere(
        (e) => e.name == map['temperature'],
        orElse: () => CoffeeTemperature.hot,
      ),
      addOns: _parseAddOns(map['addOns']),
    );
  }

  
  static List<AddOn> _parseAddOns(dynamic data) {
    if (data == null) return [];

    if (data is List) {
      return data.map((e) {
        return AddOn(
          id: e['id'] ?? '',
          name: e['name'] ?? '',
          price: (e['price'] ?? 0).toDouble(),
        );
      }).toList();
    }

    return [];
  }
}