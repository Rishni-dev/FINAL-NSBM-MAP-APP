import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key, required this.notif});

  final String notif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: const Color.fromARGB(255, 132, 192, 2),
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Notifications List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(notif).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      return _buildNotificationCard(
                        title: doc['title'] ?? 'No Title',
                        by: doc['by'] ?? 'Unknown',
                        text: doc['text'] ?? '',
                        time: doc['time'] ?? '',
                        imageUrl: doc['image'] ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String by,
    required String text,
    required String time,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with error handling
            _buildAvatar(imageUrl),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // By
                  Text(
                    by,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 132, 192, 2),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String imageUrl) {
    // Default icon configurations based on notification type
    final Map<String, IconData> iconMap = {
      'EXAM': Icons.school,
      'LIB': Icons.local_library,
      'SPORT': Icons.sports,
      'AI': Icons.smart_toy,
      'CAREER': Icons.work,
      'CODE': Icons.code,
      'WIFI': Icons.wifi,
      'BLOOD': Icons.favorite,
      'FOOD': Icons.restaurant,
      'VOTE': Icons.how_to_vote,
    };

    final Map<String, Color> colorMap = {
      'EXAM': Colors.green,
      'LIB': Colors.blue,
      'SPORT': Colors.orange,
      'AI': Colors.purple,
      'CAREER': Colors.red,
      'CODE': Colors.cyan,
      'WIFI': Colors.blueGrey,
      'BLOOD': Colors.pink,
      'FOOD': Colors.deepOrange,
      'VOTE': Colors.indigo,
    };

    // Extract type from image URL
    String type = 'DEFAULT';
    for (String key in iconMap.keys) {
      if (imageUrl.contains(key)) {
        type = key;
        break;
      }
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: (colorMap[type] ?? const Color.fromARGB(255, 132, 192, 2)).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconMap[type] ?? Icons.notifications,
        color: colorMap[type] ?? const Color.fromARGB(255, 132, 192, 2),
        size: 28,
      ),
    );
  }
}
