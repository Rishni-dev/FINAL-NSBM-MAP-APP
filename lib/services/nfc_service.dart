import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/nfc_location.dart';
import '../models/nfc_scan_result.dart';

class NFCService {
  static final NFCService _instance = NFCService._internal();
  factory NFCService() => _instance;
  NFCService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isScanning = false;
  StreamController<NFCScanResult>? _scanController;

  // Stream for listening to NFC scan results
  Stream<NFCScanResult> get scanStream =>
      _scanController?.stream ?? const Stream.empty();

  /// Check if NFC is available on the device
  Future<bool> isNFCAvailable() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      debugPrint('Error checking NFC availability: $e');
      return false;
    }
  }

  /// Check and request NFC permissions
  Future<bool> checkNFCPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // NFC permissions are automatically granted when declared in AndroidManifest.xml
      // We just need to check if NFC is available and enabled
      try {
        bool isAvailable = await NfcManager.instance.isAvailable();
        return isAvailable;
      } catch (e) {
        debugPrint('Error checking NFC permissions: $e');
        return false;
      }
    }
    return true; // iOS doesn't require explicit NFC permission for basic reading
  }

  /// Start NFC scanning session
  Future<bool> startNFCScan() async {
    if (_isScanning) return false;

    try {
      final isAvailable = await isNFCAvailable();
      if (!isAvailable) {
        throw Exception('NFC is not available on this device');
      }

      final hasPermission = await checkNFCPermissions();
      if (!hasPermission) {
        throw Exception('NFC permission denied');
      }

      _scanController ??= StreamController<NFCScanResult>.broadcast();
      _isScanning = true;

      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          await _handleNFCTag(tag);
        },
      );

      return true;
    } catch (e) {
      debugPrint('Error starting NFC scan: $e');
      _isScanning = false;
      return false;
    }
  }

  /// Stop NFC scanning session
  Future<void> stopNFCScan() async {
    if (!_isScanning) return;

    try {
      await NfcManager.instance.stopSession();
      _isScanning = false;
    } catch (e) {
      debugPrint('Error stopping NFC scan: $e');
    }
  }

  /// Handle discovered NFC tag
  Future<void> _handleNFCTag(NfcTag tag) async {
    try {
      // Extract tag ID
      String tagId = _extractTagId(tag);

      if (tagId.isEmpty) {
        debugPrint('Could not extract tag ID');
        return;
      }

      debugPrint('NFC Tag discovered: $tagId');

      // Look up location data for this tag
      NFCLocation? location = await getLocationByTagId(tagId);

      // Create scan result
      final scanResult = NFCScanResult(
        tagId: tagId,
        location: location,
        scannedAt: DateTime.now(),
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        additionalData: _extractTagData(tag),
      );

      // Save scan result to Firestore
      await saveScanResult(scanResult);

      // Emit scan result to listeners
      _scanController?.add(scanResult);

      // Stop session after successful read
      await stopNFCScan();
    } catch (e) {
      debugPrint('Error handling NFC tag: $e');
    }
  }

  /// Extract tag ID from NFC tag
  String _extractTagId(NfcTag tag) {
    try {
      // Try different tag technologies to extract ID
      if (tag.data.containsKey('nfca')) {
        final nfca = NfcA.from(tag);
        return nfca?.identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join('') ??
            '';
      }

      if (tag.data.containsKey('nfcb')) {
        final nfcb = NfcB.from(tag);
        return nfcb?.identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join('') ??
            '';
      }

      if (tag.data.containsKey('nfcf')) {
        final nfcf = NfcF.from(tag);
        return nfcf?.identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join('') ??
            '';
      }

      if (tag.data.containsKey('nfcv')) {
        final nfcv = NfcV.from(tag);
        return nfcv?.identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join('') ??
            '';
      }

      return '';
    } catch (e) {
      debugPrint('Error extracting tag ID: $e');
      return '';
    }
  }

  /// Extract additional data from NFC tag
  Map<String, dynamic> _extractTagData(NfcTag tag) {
    final data = <String, dynamic>{};

    try {
      data['technologies'] = tag.data.keys.toList();

      // Add technology-specific data
      tag.data.forEach((key, value) {
        data[key] = value.toString();
      });
    } catch (e) {
      debugPrint('Error extracting tag data: $e');
    }

    return data;
  }

  /// Get location information by tag ID from Firestore
  Future<NFCLocation?> getLocationByTagId(String tagId) async {
    try {
      final doc = await _firestore.collection('nfc_locations').doc(tagId).get();

      if (doc.exists && doc.data() != null) {
        return NFCLocation.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting location by tag ID: $e');
      return null;
    }
  }

  /// Save scan result to Firestore
  Future<void> saveScanResult(NFCScanResult scanResult) async {
    try {
      await _firestore.collection('nfc_scan_history').add(scanResult.toJson());

      debugPrint('Scan result saved successfully');
    } catch (e) {
      debugPrint('Error saving scan result: $e');
    }
  }

  /// Get scan history for current user
  Future<List<NFCScanResult>> getScanHistory({int limit = 50}) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final query = await _firestore
          .collection('nfc_scan_history')
          .where('userId', isEqualTo: userId)
          .orderBy('scannedAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => NFCScanResult.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting scan history: $e');
      return [];
    }
  }

  /// Register a new NFC location (Admin function)
  Future<bool> registerNFCLocation(String tagId, NFCLocation location) async {
    try {
      await _firestore
          .collection('nfc_locations')
          .doc(tagId)
          .set(location.toJson());

      debugPrint('NFC location registered successfully');
      return true;
    } catch (e) {
      debugPrint('Error registering NFC location: $e');
      return false;
    }
  }

  /// Get all registered NFC locations
  Future<List<NFCLocation>> getAllNFCLocations() async {
    try {
      final query = await _firestore
          .collection('nfc_locations')
          .orderBy('facultyName')
          .orderBy('buildingCode')
          .get();

      return query.docs.map((doc) => NFCLocation.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Error getting NFC locations: $e');
      return [];
    }
  }

  /// Get NFC locations by faculty
  Future<List<NFCLocation>> getNFCLocationsByFaculty(String facultyName) async {
    try {
      final query = await _firestore
          .collection('nfc_locations')
          .where('facultyName', isEqualTo: facultyName)
          .orderBy('buildingCode')
          .get();

      return query.docs.map((doc) => NFCLocation.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Error getting NFC locations by faculty: $e');
      return [];
    }
  }

  /// Cleanup resources
  void dispose() {
    stopNFCScan();
  
    _scanController?.close();
    _scanController = null;
  }

  bool get isScanning => _isScanning;
}
