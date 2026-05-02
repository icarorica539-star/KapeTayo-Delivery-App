class RiderModel {
  final String id;
  final String name;
  final String phone;
  final bool isAvailable;

  final double lat;
  final double lng;

  RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isAvailable,
    required this.lat,
    required this.lng,
  });

  factory RiderModel.fromMap(String id, Map<String, dynamic> map) {
    return RiderModel(
      id: id,
      name: map['name'],
      phone: map['phone'],
      isAvailable: map['isAvailable'] ?? true,
      lat: map['lat'] ?? 0,
      lng: map['lng'] ?? 0,
    );
  }
}