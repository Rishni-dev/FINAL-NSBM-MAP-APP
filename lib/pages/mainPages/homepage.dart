import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsbm_map/pages/Components/gridcon.dart';
import 'package:nsbm_map/pages/SecondaryPages/campusmap.dart';
import 'package:nsbm_map/pages/SecondaryPages/lectureschedule.dart';
import 'package:nsbm_map/pages/SecondaryPages/newsannouncements.dart';
import 'package:nsbm_map/pages/SecondaryPages/aboutcampus.dart';
import 'package:nsbm_map/pages/SecondaryPages/nfc_scanner_page.dart';
import 'package:nsbm_map/utils/nfc_setup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSettingUpNFC = false;

  Future<void> _setupNFCData() async {
    setState(() {
      _isSettingUpNFC = true;
    });

    try {
      // First test Firebase connection
      bool connectionTest = await NFCSetup.testFirebaseConnection();
      if (!connectionTest) {
        throw Exception(
          'Firebase connection failed. Please check your internet connection.',
        );
      }

      // Try the main setup method first
      bool success = await NFCSetup.setupSampleNFCLocations();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('NFC locations setup successfully!')),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(16),
          ),
        );

        // Show stats
        _showSetupStats();
      } else {
        // Try alternative batch method
        bool batchSuccess = await NFCSetup.setupSampleNFCLocationsWithBatches();
        if (batchSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'NFC locations setup completed using batch method!',
                    ),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.all(16),
            ),
          );
          _showSetupStats();
        } else {
          throw Exception(
            'Both setup methods failed. Please try again or check your Firebase configuration.',
          );
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('permission-denied')) {
        // Show Firebase rules configuration dialog instead of generic error
        _showFirebaseRulesDialog();
        return; // Exit early to show dialog instead of snackbar
      } else if (errorMessage.contains('network')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (errorMessage.contains('User not authenticated')) {
        errorMessage = 'Please make sure you are logged in.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'NFC Setup Failed',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(errorMessage),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          action: SnackBarAction(
            label: 'RETRY',
            textColor: Colors.white,
            onPressed: _setupNFCData,
          ),
        ),
      );
    }

    setState(() {
      _isSettingUpNFC = false;
    });
  }

  Future<void> _showSetupStats() async {
    try {
      final stats = await NFCSetup.getNFCLocationStats();
      final totalLocations = stats['totalLocations'] ?? 0;

      if (totalLocations > 0) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.analytics, color: Colors.green),
                SizedBox(width: 8),
                Text('Setup Complete!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Successfully setup $totalLocations NFC locations'),
                SizedBox(height: 8),
                Text('You can now use the NFC Scanner to test the system.'),
                SizedBox(height: 12),
                Text(
                  'Faculty breakdown:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...((stats['facultyCount'] as Map<String, int>?) ?? {}).entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(left: 8, top: 2),
                        child: Text('• ${entry.key}: ${entry.value} locations'),
                      ),
                    ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('GREAT!'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // If stats fail, just continue silently
      debugPrint('Failed to show stats: $e');
    }
  }

  void _showFirebaseRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.orange),
            SizedBox(width: 8),
            Text('Firebase Setup Required'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Firebase security rules need to be configured to allow NFC data setup.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Quick Fix:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green[700]),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Go to Firebase Console',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '2. Navigate to Firestore Database → Rules',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '3. Replace rules with:',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'match /{document=**} {\n  allow read, write: if request.auth != null;\n}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '4. Click Publish → Retry Setup',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'This allows authenticated users to access NFC data.',
                      style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _setupNFCData(); // Retry setup
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
            ),
            child: Text('RETRY SETUP'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.now();

    String date1 = DateFormat('E d MMM').format(dt);
    String date2 = DateFormat('j').format(dt);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      floatingActionButton: FloatingActionButton(
        onPressed: _isSettingUpNFC ? null : _setupNFCData,
        backgroundColor: Colors.blue[700],
        child: _isSettingUpNFC
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.nfc, color: Colors.white),
        tooltip: 'Setup NFC Sample Data',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'id',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var docs = snapshot.data!.docs;

                      return dt.hour <= 12
                          ? Text(
                              "Good Morning  ${docs[0]['name']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : Text(
                              "Good Evening  ${docs[0]['name']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            );
                    } else {
                      return const Center();
                    }
                  },
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  height: 500,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      GridCon(
                        text: "Lecture Schedule",
                        image: "calendar.png",
                        onCl: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LectureSchedule(),
                            ),
                          );
                        },
                      ),
                      GridCon(
                        text: "Campus Map",
                        image: "map.png",
                        onCl: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampusMap(),
                            ),
                          );
                        },
                      ),
                      GridCon(
                        text: "NFC Scanner",
                        image: "nfc.png",
                        onCl: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NFCScannerPage(),
                            ),
                          );
                        },
                      ),
                      GridCon(
                        text: "News & Announcements",
                        image: "news.png",
                        onCl: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NewsAnnouncementsPage(),
                            ),
                          );
                        },
                      ),
                      GridCon(
                        text: "About Campus",
                        image: "info.png",
                        onCl: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutCampusPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
