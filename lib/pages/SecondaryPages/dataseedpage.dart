import 'package:flutter/material.dart';
import 'package:nsbm_map/utils/firestore_seed_data.dart';

class DataSeedPage extends StatefulWidget {
  const DataSeedPage({super.key});

  @override
  State<DataSeedPage> createState() => _DataSeedPageState();
}

class _DataSeedPageState extends State<DataSeedPage> {
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _seedAllData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Seeding data...';
    });

    try {
      await FirestoreSeedData.seedAllData();
      setState(() {
        _statusMessage = '✅ All data seeded successfully!\nCheck Lectures and Notifications.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _seedLectures() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Seeding lectures...';
    });

    try {
      await FirestoreSeedData.seedLectures();
      setState(() {
        _statusMessage = '✅ Lectures seeded successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _seedNotifications() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Seeding notifications...';
    });

    try {
      await FirestoreSeedData.seedNotifications();
      setState(() {
        _statusMessage = '✅ Notifications seeded successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _clearAllData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing data...';
    });

    try {
      await FirestoreSeedData.clearAllData();
      setState(() {
        _statusMessage = '✅ All data cleared successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _reseedAllData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Reseeding data...';
    });

    try {
      await FirestoreSeedData.reseedAllData();
      setState(() {
        _statusMessage = '✅ Data reseeded successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        title: const Text('Data Seeding Tool'),
        backgroundColor: const Color.fromARGB(255, 132, 192, 2),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            'Developer Tool',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Use this page to populate Firestore with dummy data for testing. This will add sample lectures and notifications to your database.',
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Seed All Data Button
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),

                _buildActionButton(
                  title: 'Seed All Data',
                  subtitle: 'Add lectures and notifications',
                  icon: Icons.cloud_upload,
                  color: Colors.green,
                  onPressed: _isLoading ? null : _seedAllData,
                ),
                const SizedBox(height: 15),

                _buildActionButton(
                  title: 'Reseed All Data',
                  subtitle: 'Clear and add fresh data',
                  icon: Icons.refresh,
                  color: Colors.orange,
                  onPressed: _isLoading ? null : _reseedAllData,
                ),
                const SizedBox(height: 30),

                // Individual Actions
                const Text(
                  'Individual Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),

                _buildActionButton(
                  title: 'Seed Lectures Only',
                  subtitle: 'Add sample lecture schedule',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                  onPressed: _isLoading ? null : _seedLectures,
                ),
                const SizedBox(height: 15),

                _buildActionButton(
                  title: 'Seed Notifications Only',
                  subtitle: 'Add sample notifications',
                  icon: Icons.notifications,
                  color: Colors.purple,
                  onPressed: _isLoading ? null : _seedNotifications,
                ),
                const SizedBox(height: 15),

                _buildActionButton(
                  title: 'Clear All Data',
                  subtitle: 'Remove all seeded data',
                  icon: Icons.delete_forever,
                  color: Colors.red,
                  onPressed: _isLoading ? null : _clearAllData,
                ),
                const SizedBox(height: 30),

                // Status Section
                if (_statusMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info, color: Color.fromARGB(255, 132, 192, 2)),
                            SizedBox(width: 10),
                            Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _statusMessage,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                // Loading Indicator
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                const SizedBox(height: 30),

                // Warning Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange),
                          SizedBox(width: 10),
                          Text(
                            'Note',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '• This is a development tool\n'
                        '• Data will be visible immediately after seeding\n'
                        '• Lectures are created for today and surrounding days\n'
                        '• Remove this page before production deployment',
                        style: TextStyle(fontSize: 13, height: 1.5),
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

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
