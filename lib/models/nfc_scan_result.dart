import 'nfc_location.dart';

class NFCScanResult {
  final String tagId;
  final NFCLocation? location;
  final DateTime scannedAt;
  final String userId;
  final Map<String, dynamic> additionalData;

  NFCScanResult({
    required this.tagId,
    this.location,
    required this.scannedAt,
    required this.userId,
    required this.additionalData,
  });

  factory NFCScanResult.fromJson(Map<String, dynamic> json) {
    return NFCScanResult(
      tagId: json['tagId'] ?? '',
      location: json['location'] != null ? NFCLocation.fromJson(json['location']) : null,
      scannedAt: DateTime.parse(json['scannedAt'] ?? DateTime.now().toIso8601String()),
      userId: json['userId'] ?? '',
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'location': location?.toJson(),
      'scannedAt': scannedAt.toIso8601String(),
      'userId': userId,
      'additionalData': additionalData,
    };
  }
}