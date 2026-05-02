class AddOn {
  final String id;
  final String name;
  final double price;

  const AddOn({
    required this.id,
    required this.name,
    required this.price,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  
  factory AddOn.fromMap(Map<String, dynamic> map) {
    return AddOn(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : double.tryParse(map['price'].toString()) ?? 0.0,
    );
  }

  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddOn && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AddOn(id: $id, name: $name, price: $price)';
}