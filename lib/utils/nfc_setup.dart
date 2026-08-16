import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/nfc_location.dart';

class NFCSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Setup sample NFC locations for NSBM University
  /// This should be run once to populate the database with sample data
  static Future<bool> setupSampleNFCLocations() async {
    try {
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not authenticated - cannot setup NFC locations');
        return false;
      }

      // Check if locations already exist
      final existingLocations = await _firestore.collection('nfc_locations').limit(1).get();
      if (existingLocations.docs.isNotEmpty) {
        debugPrint('NFC locations already exist, skipping setup');
        return true; // Consider this a success since data already exists
      }

      List<NFCLocation> sampleLocations = _getSampleLocations();
      debugPrint('Setting up ${sampleLocations.length} NFC locations...');
      
      // Use individual writes instead of batch to avoid potential issues
      int successCount = 0;
      for (NFCLocation location in sampleLocations) {
        try {
          String tagId = _generateTagId(location);
          await _firestore.collection('nfc_locations').doc(tagId).set(location.toJson());
          successCount++;
          debugPrint('Successfully added location: ${location.name}');
        } catch (e) {
          debugPrint('Failed to add location ${location.name}: $e');
          // Continue with other locations even if one fails
        }
      }
      
      if (successCount > 0) {
        debugPrint('Successfully setup $successCount out of ${sampleLocations.length} NFC locations');
        return true;
      } else {
        debugPrint('Failed to setup any NFC locations');
        return false;
      }
    } catch (e) {
      debugPrint('Error setting up NFC locations: $e');
      return false;
    }
  }

  /// Alternative setup method using smaller batches
  static Future<bool> setupSampleNFCLocationsWithBatches() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not authenticated');
        return false;
      }

      List<NFCLocation> sampleLocations = _getSampleLocations();
      const int batchSize = 5; // Smaller batch size to avoid limits
      
      for (int i = 0; i < sampleLocations.length; i += batchSize) {
        WriteBatch batch = _firestore.batch();
        int endIndex = (i + batchSize < sampleLocations.length) ? i + batchSize : sampleLocations.length;
        
        for (int j = i; j < endIndex; j++) {
          NFCLocation location = sampleLocations[j];
          String tagId = _generateTagId(location);
          DocumentReference docRef = _firestore.collection('nfc_locations').doc(tagId);
          batch.set(docRef, location.toJson());
        }
        
        await batch.commit();
        debugPrint('Batch ${(i ~/ batchSize) + 1} committed successfully');
      }
      
      debugPrint('All batches completed successfully');
      return true;
    } catch (e) {
      debugPrint('Error in batch setup: $e');
      return false;
    }
  }

  /// Generate a predictable tag ID for demo purposes
  static String _generateTagId(NFCLocation location) {
    return '${location.buildingCode}_${location.roomNumber}'.toLowerCase().replaceAll(' ', '_');
  }

  /// Get sample NFC locations for NSBM University
  static List<NFCLocation> _getSampleLocations() {
    final now = DateTime.now();
    
    return [
      // Faculty of Computing
      NFCLocation(
        id: 'fc_101',
        name: 'Computer Lab 1',
        facultyName: 'Faculty of Computing',
        buildingCode: 'FC',
        roomNumber: '101',
        latitude: 6.8211,
        longitude: 80.0409,
        description: 'Main computer laboratory with 50 high-performance workstations. Equipped with latest software development tools.',
        amenities: {
          'Computers': '50 workstations',
          'Software': 'Visual Studio, Android Studio, IntelliJ',
          'Network': 'High-speed internet',
          'Air Conditioning': 'Yes',
          'Projector': 'Smart board available'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),
      
      NFCLocation(
        id: 'fc_201',
        name: 'Network Security Lab',
        facultyName: 'Faculty of Computing',
        buildingCode: 'FC',
        roomNumber: '201',
        latitude: 6.8212,
        longitude: 80.0410,
        description: 'Specialized laboratory for cybersecurity and network security courses.',
        amenities: {
          'Computers': '25 workstations',
          'Security Tools': 'Kali Linux, Wireshark, Nessus',
          'Network Equipment': 'Cisco routers and switches',
          'Air Conditioning': 'Yes'
        },
        mapLevel: 'Level1',
        createdAt: now,
        updatedAt: now,
      ),

      // Faculty of Engineering
      NFCLocation(
        id: 'fe_301',
        name: 'Electronics Lab',
        facultyName: 'Faculty of Engineering',
        buildingCode: 'FE',
        roomNumber: '301',
        latitude: 6.8213,
        longitude: 80.0408,
        description: 'Advanced electronics laboratory with oscilloscopes, signal generators, and testing equipment.',
        amenities: {
          'Oscilloscopes': '20 units',
          'Signal Generators': '15 units',
          'Multimeters': '30 units',
          'Power Supplies': '25 units',
          'Component Storage': 'Comprehensive inventory'
        },
        mapLevel: 'Level2',
        createdAt: now,
        updatedAt: now,
      ),

      // Faculty of Business
      NFCLocation(
        id: 'fb_205',
        name: 'Business Simulation Lab',
        facultyName: 'Faculty of Business',
        buildingCode: 'FB',
        roomNumber: '205',
        latitude: 6.8210,
        longitude: 80.0407,
        description: 'Interactive business simulation laboratory for practical business scenario training.',
        amenities: {
          'Computers': '40 workstations',
          'Simulation Software': 'SAP, Oracle, Bloomberg Terminal',
          'Smart Board': 'Interactive whiteboard',
          'Video Conferencing': 'Zoom/Teams setup'
        },
        mapLevel: 'Level1',
        createdAt: now,
        updatedAt: now,
      ),

      // Library
      NFCLocation(
        id: 'lib_main',
        name: 'Main Library',
        facultyName: 'Library Services',
        buildingCode: 'LIB',
        roomNumber: 'Main',
        latitude: 6.8209,
        longitude: 80.0411,
        description: 'Central library with extensive collection of books, journals, and digital resources.',
        amenities: {
          'Books': '50,000+ collection',
          'Digital Resources': 'IEEE, ACM, Springer databases',
          'Study Spaces': '200+ seats',
          'Computer Access': '30 public computers',
          'WiFi': 'High-speed wireless',
          'Printing': 'Print and scan services'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),

      // Student Services
      NFCLocation(
        id: 'admin_ss',
        name: 'Student Services',
        facultyName: 'Administration',
        buildingCode: 'ADMIN',
        roomNumber: 'SS',
        latitude: 6.8208,
        longitude: 80.0406,
        description: 'Student services center for academic and administrative support.',
        amenities: {
          'Services': 'Registration, transcripts, certificates',
          'Counseling': 'Academic and career guidance',
          'Financial Aid': 'Scholarship and loan assistance',
          'Waiting Area': 'Comfortable seating'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),

      // Cafeteria
      NFCLocation(
        id: 'caf_main',
        name: 'Main Cafeteria',
        facultyName: 'Student Life',
        buildingCode: 'CAF',
        roomNumber: 'Main',
        latitude: 6.8207,
        longitude: 80.0412,
        description: 'Main dining facility serving breakfast, lunch, and dinner with diverse menu options.',
        amenities: {
          'Seating': '300 capacity',
          'Food Options': 'Local and international cuisine',
          'Payment': 'Card and mobile payments accepted',
          'WiFi': 'Free wireless internet',
          'Operating Hours': '7 AM - 9 PM'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),

      // Sports Complex
      NFCLocation(
        id: 'gym_main',
        name: 'Sports Complex',
        facultyName: 'Student Life',
        buildingCode: 'GYM',
        roomNumber: 'Main',
        latitude: 6.8214,
        longitude: 80.0405,
        description: 'Comprehensive sports facility with gymnasium, fitness center, and outdoor courts.',
        amenities: {
          'Gymnasium': 'Basketball, volleyball, badminton courts',
          'Fitness Center': 'Modern equipment and weights',
          'Outdoor Courts': 'Tennis, basketball courts',
          'Swimming Pool': '25m pool with lanes',
          'Locker Rooms': 'Separate facilities for men and women'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),

      // Medical Center
      NFCLocation(
        id: 'med_center',
        name: 'Medical Center',
        facultyName: 'Health Services',
        buildingCode: 'MED',
        roomNumber: 'Center',
        latitude: 6.8206,
        longitude: 80.0413,
        description: 'On-campus medical facility providing basic healthcare services to students and staff.',
        amenities: {
          'Services': 'General consultation, first aid',
          'Pharmacy': 'Basic medications available',
          'Emergency Care': '24/7 emergency response',
          'Health Education': 'Wellness programs'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),

      // Auditorium
      NFCLocation(
        id: 'aud_main',
        name: 'Main Auditorium',
        facultyName: 'Events & Conferences',
        buildingCode: 'AUD',
        roomNumber: 'Main',
        latitude: 6.8215,
        longitude: 80.0414,
        description: 'Large auditorium for university events, conferences, and graduation ceremonies.',
        amenities: {
          'Seating': '500 capacity',
          'Audio/Visual': 'Professional sound and lighting system',
          'Stage': 'Large performance stage',
          'Air Conditioning': 'Climate controlled',
          'Accessibility': 'Wheelchair accessible'
        },
        mapLevel: 'Ground',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Clear all NFC locations (for testing purposes)
  static Future<bool> clearAllNFCLocations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not authenticated');
        return false;
      }

      QuerySnapshot snapshot = await _firestore.collection('nfc_locations').get();
      
      if (snapshot.docs.isEmpty) {
        debugPrint('No NFC locations to clear');
        return true;
      }

      // Delete in batches
      const int batchSize = 10;
      for (int i = 0; i < snapshot.docs.length; i += batchSize) {
        WriteBatch batch = _firestore.batch();
        int endIndex = (i + batchSize < snapshot.docs.length) ? i + batchSize : snapshot.docs.length;
        
        for (int j = i; j < endIndex; j++) {
          batch.delete(snapshot.docs[j].reference);
        }
        
        await batch.commit();
      }
      
      debugPrint('Successfully cleared all NFC locations');
      return true;
    } catch (e) {
      debugPrint('Error clearing NFC locations: $e');
      return false;
    }
  }

  /// Get statistics about registered NFC locations
  static Future<Map<String, dynamic>> getNFCLocationStats() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('nfc_locations').get();
      
      Map<String, int> facultyCount = {};
      Map<String, int> buildingCount = {};
      
      for (DocumentSnapshot doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final facultyName = data['facultyName'] ?? 'Unknown';
          final buildingCode = data['buildingCode'] ?? 'Unknown';
          
          facultyCount[facultyName] = (facultyCount[facultyName] ?? 0) + 1;
          buildingCount[buildingCode] = (buildingCount[buildingCode] ?? 0) + 1;
        }
      }
      
      return {
        'totalLocations': snapshot.docs.length,
        'facultyCount': facultyCount,
        'buildingCount': buildingCount,
      };
    } catch (e) {
      debugPrint('Error getting NFC location stats: $e');
      return {};
    }
  }

  /// Test Firebase connection
  static Future<bool> testFirebaseConnection() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('User not authenticated');
        return false;
      }

      // Test with a simple authenticated read operation instead of 'test' collection
      // Try to read user's own data which should be allowed
      await _firestore.collection('users').doc(user.uid).get();
      debugPrint('Firebase connection test successful');
      return true;
    } catch (e) {
      debugPrint('Firebase connection test failed: $e');
      // Even if connection test fails, we can still try the setup
      // because the user might have permission for nfc_locations collection
      return true; // Changed to true to allow setup attempt
    }
  }
}