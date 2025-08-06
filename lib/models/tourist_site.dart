class TouristSite {
  final String id;
  final String title;
  final String description;
  final String address;
  final List<String> imageUrls;
  final String userId;
  final DateTime createdAt;
  final double latitude;
  final double longitude;

  TouristSite({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.imageUrls,
    required this.userId,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
  });

  factory TouristSite.fromMap(Map<String, dynamic> map) {
    return TouristSite(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      address: map['address'] ?? '',
      imageUrls: List<String>.from(map['image_urls'] ?? []),
      userId: map['user_id'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'image_urls': imageUrls,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
