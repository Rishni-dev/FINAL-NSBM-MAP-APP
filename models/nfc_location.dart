class NFCLocation {
  final String id;
  final String name;
  final String facultyName;
  final String buildingCode;
  final String roomNumber;
  final double latitude;
  final double longitude;
  final String description;
  final Map<String, dynamic> amenities;
  final String mapLevel; // Ground, Level1, Level2, etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  NFCLocation({
    required this.id,
    required this.name,
    required this.facultyName,
    required this.buildingCode,
    required this.roomNumber,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.amenities,
    required this.mapLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NFCLocation.fromJson(Map<String, dynamic> json) {
    return NFCLocation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      facultyName: json['facultyName'] ?? '',
      buildingCode: json['buildingCode'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      amenities: Map<String, dynamic>.from(json['amenities'] ?? {}),
      mapLevel: json['mapLevel'] ?? 'Ground',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'facultyName': facultyName,
      'buildingCode': buildingCode,
      'roomNumber': roomNumber,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'amenities': amenities,
      'mapLevel': mapLevel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get fullLocationName => '$facultyName - $buildingCode $roomNumber';
  
  String get shortLocationCode => '$buildingCode-$roomNumber';
}