class Coffee {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final String image;
  final String category;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.image,
    required this.category,
  });

  
  double priceBySize(String size) {
    switch (size) {
      case "Small":
        return basePrice;
      case "Medium":
        return basePrice + 20;
      case "Large":
        return basePrice + 40;
      default:
        return basePrice;
    }
  }

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'image': image,
      'category': category,
    };
  }

  
  factory Coffee.fromMap(Map<String, dynamic> map) {
    return Coffee(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      category: map['category'] ?? '',
    );
  }
}