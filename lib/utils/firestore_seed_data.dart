import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class to seed Firestore with dummy data for testing
class FirestoreSeedData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seeds all collections with dummy data
  static Future<void> seedAllData() async {
    try {
      await seedLectures();
      await seedNotifications();
      print('✅ All data seeded successfully!');
    } catch (e) {
      print('❌ Error seeding data: $e');
    }
  }

  /// Seeds the Lectures collection with dummy lecture data
  static Future<void> seedLectures() async {
    print('📚 Seeding Lectures...');

    // Get current date to create lectures for this week
    final now = DateTime.now();
    final today = now.day;

    final List<Map<String, dynamic>> lectures = [
      // Today's lectures
      {
        'lcName': 'Database Management Systems',
        'lcNb': 'COM301',
        'from': '08:00 AM',
        'to': '10:00 AM',
        'du': '2 hours',
        'date': today,
      },
      {
        'lcName': 'Web Development',
        'lcNb': 'COM302',
        'from': '10:30 AM',
        'to': '12:30 PM',
        'du': '2 hours',
        'date': today,
      },
      {
        'lcName': 'Software Engineering',
        'lcNb': 'COM303',
        'from': '01:00 PM',
        'to': '03:00 PM',
        'du': '2 hours',
        'date': today,
      },
      {
        'lcName': 'Mobile App Development',
        'lcNb': 'COM304',
        'from': '03:30 PM',
        'to': '05:30 PM',
        'du': '2 hours',
        'date': today,
      },

      // Tomorrow's lectures
      {
        'lcName': 'Data Structures & Algorithms',
        'lcNb': 'COM201',
        'from': '08:00 AM',
        'to': '10:00 AM',
        'du': '2 hours',
        'date': today + 1,
      },
      {
        'lcName': 'Object Oriented Programming',
        'lcNb': 'COM202',
        'from': '10:30 AM',
        'to': '12:30 PM',
        'du': '2 hours',
        'date': today + 1,
      },
      {
        'lcName': 'Computer Networks',
        'lcNb': 'COM203',
        'from': '01:00 PM',
        'to': '03:00 PM',
        'du': '2 hours',
        'date': today + 1,
      },

      // Day after tomorrow
      {
        'lcName': 'Artificial Intelligence',
        'lcNb': 'COM401',
        'from': '08:00 AM',
        'to': '10:00 AM',
        'du': '2 hours',
        'date': today + 2,
      },
      {
        'lcName': 'Machine Learning',
        'lcNb': 'COM402',
        'from': '10:30 AM',
        'to': '12:30 PM',
        'du': '2 hours',
        'date': today + 2,
      },
      {
        'lcName': 'Cloud Computing',
        'lcNb': 'COM403',
        'from': '01:00 PM',
        'to': '03:00 PM',
        'du': '2 hours',
        'date': today + 2,
      },

      // Yesterday
      {
        'lcName': 'Business Analytics',
        'lcNb': 'BUS201',
        'from': '08:00 AM',
        'to': '10:00 AM',
        'du': '2 hours',
        'date': today - 1,
      },
      {
        'lcName': 'Digital Marketing',
        'lcNb': 'BUS202',
        'from': '10:30 AM',
        'to': '12:30 PM',
        'du': '2 hours',
        'date': today - 1,
      },

      // Day before yesterday
      {
        'lcName': 'Project Management',
        'lcNb': 'BUS301',
        'from': '08:00 AM',
        'to': '10:00 AM',
        'du': '2 hours',
        'date': today - 2,
      },
      {
        'lcName': 'Cyber Security',
        'lcNb': 'COM501',
        'from': '10:30 AM',
        'to': '12:30 PM',
        'du': '2 hours',
        'date': today - 2,
      },
    ];

    // Add lectures to Firestore
    for (var lecture in lectures) {
      await _firestore.collection('Lectures').add(lecture);
    }

    print('✅ ${lectures.length} lectures added successfully!');
  }

  /// Seeds the Notifications collection with dummy notification data
  static Future<void> seedNotifications() async {
    print('🔔 Seeding Notifications...');

    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Semester Exams Schedule Released',
        'by': 'Academic Office',
        'text':
            'The final examination schedule for Semester 1, 2026 has been published. Please check your student portal for detailed timetable.',
        'time': '2h ago',
        'image': 'https://via.placeholder.com/100/4CAF50/FFFFFF?text=EXAM',
      },
      {
        'title': 'Library Extended Hours',
        'by': 'Library Administration',
        'text':
            'The library will be open 24/7 during the examination period from March 28 to April 15. Study rooms available for booking.',
        'time': '5h ago',
        'image': 'https://via.placeholder.com/100/2196F3/FFFFFF?text=LIB',
      },
      {
        'title': 'Sports Day Registration Open',
        'by': 'Sports Committee',
        'text':
            'Register for the Annual Sports Day 2026. Last date for registration: March 30, 2026. Individual and team events available.',
        'time': '1d ago',
        'image': 'https://via.placeholder.com/100/FF9800/FFFFFF?text=SPORT',
      },
      {
        'title': 'Guest Lecture: AI & Machine Learning',
        'by': 'Faculty of Computing',
        'text':
            'Join us for an insightful guest lecture on Artificial Intelligence and Machine Learning applications on March 29 at 2:00 PM.',
        'time': '1d ago',
        'image': 'https://via.placeholder.com/100/9C27B0/FFFFFF?text=AI',
      },
      {
        'title': 'Career Fair 2026',
        'by': 'Career Guidance Unit',
        'text':
            'Meet top employers at the NSBM Career Fair on April 5-6, 2026. Bring your updated CV and dress professionally!',
        'time': '2d ago',
        'image': 'https://via.placeholder.com/100/F44336/FFFFFF?text=CAREER',
      },
      {
        'title': 'Workshop: Flutter Mobile Development',
        'by': 'Tech Society',
        'text':
            'Free workshop on Flutter mobile app development for beginners. Register now! Limited seats available. March 27, 3:00 PM.',
        'time': '2d ago',
        'image': 'https://via.placeholder.com/100/00BCD4/FFFFFF?text=CODE',
      },
      {
        'title': 'Campus Wifi Maintenance',
        'by': 'IT Department',
        'text':
            'Campus wifi will be under maintenance on March 26 from 1:00 AM to 3:00 AM. Please plan accordingly.',
        'time': '3d ago',
        'image': 'https://via.placeholder.com/100/607D8B/FFFFFF?text=WIFI',
      },
      {
        'title': 'Blood Donation Campaign',
        'by': 'Wellbeing Association',
        'text':
            'Annual blood donation drive on March 28. Your donation can save lives! Refreshments will be provided to all donors.',
        'time': '3d ago',
        'image': 'https://via.placeholder.com/100/E91E63/FFFFFF?text=BLOOD',
      },
      {
        'title': 'New Cafeteria Menu',
        'by': 'Student Services',
        'text':
            'Check out our new healthy meal options at the cafeteria. Special student discounts available for combo meals!',
        'time': '4d ago',
        'image': 'https://via.placeholder.com/100/FF5722/FFFFFF?text=FOOD',
      },
      {
        'title': 'Student Council Elections',
        'by': 'Student Affairs',
        'text':
            'Nominations open for Student Council elections 2026. Be the voice of change! Deadline: April 1, 2026.',
        'time': '5d ago',
        'image': 'https://via.placeholder.com/100/3F51B5/FFFFFF?text=VOTE',
      },
    ];

    // Add notifications to Firestore
    for (var notification in notifications) {
      await _firestore.collection('Notifications').add(notification);
    }

    print('✅ ${notifications.length} notifications added successfully!');
  }

  /// Clears all data from Lectures collection
  static Future<void> clearLectures() async {
    print('🗑️ Clearing Lectures...');
    final snapshot = await _firestore.collection('Lectures').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    print('✅ Lectures cleared!');
  }

  /// Clears all data from Notifications collection
  static Future<void> clearNotifications() async {
    print('🗑️ Clearing Notifications...');
    final snapshot = await _firestore.collection('Notifications').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    print('✅ Notifications cleared!');
  }

  /// Clears all seeded data
  static Future<void> clearAllData() async {
    try {
      await clearLectures();
      await clearNotifications();
      print('✅ All data cleared successfully!');
    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }

  /// Reseeds all data (clears and then adds fresh data)
  static Future<void> reseedAllData() async {
    print('🔄 Reseeding all data...');
    await clearAllData();
    await seedAllData();
  }
}
