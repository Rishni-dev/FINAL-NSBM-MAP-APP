import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutCampusPage extends StatelessWidget {
  const AboutCampusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        title: const Text('About NSBM Campus'),
        backgroundColor: const Color.fromARGB(255, 132, 192, 2),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // University Name & Logo Section
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'NSBM Green University',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 132, 192, 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Best University in Sri Lanka',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // About Section
                _buildSectionCard(
                  title: 'About NSBM',
                  icon: Icons.school,
                  content:
                      'NSBM Green University operates as a self-financed university and is renowned for its world-class academic offerings. As Sri Lanka\'s premier green university, NSBM offers a wide range of internationally recognized bachelor degree programs.',
                ),
                const SizedBox(height: 15),

                // Location Section
                _buildSectionCard(
                  title: 'Location',
                  icon: Icons.location_on,
                  content:
                      'Mahenwaththa, Pitipana, Homagama, Sri Lanka\n\nGeographical Coordinates:\nLatitude: 6.82° North\nLongitude: 80.04° East',
                ),
                const SizedBox(height: 15),

                // Contact Section
                _buildSectionCard(
                  title: 'Contact Information',
                  icon: Icons.contact_phone,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: '+94 11 544 5000',
                        onTap: () => _launchUrl('tel:+94115445000'),
                      ),
                      const SizedBox(height: 10),
                      _buildContactItem(
                        icon: Icons.phone_android,
                        label: 'Mobile',
                        value: '+94 71 244 5000',
                        onTap: () => _launchUrl('tel:+94712445000'),
                      ),
                      const SizedBox(height: 10),
                      _buildContactItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: 'inquiries@nsbm.ac.lk',
                        onTap: () => _launchUrl('mailto:inquiries@nsbm.ac.lk'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Faculties Section
                _buildSectionCard(
                  title: 'Faculties',
                  icon: Icons.apartment,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFacultyItem('Faculty of Computing', Colors.blue),
                      const SizedBox(height: 8),
                      _buildFacultyItem('Faculty of Business Management', Colors.red),
                      const SizedBox(height: 8),
                      _buildFacultyItem(
                          'Faculty of Engineering', const Color.fromARGB(255, 141, 129, 24)),
                      const SizedBox(height: 8),
                      _buildFacultyItem('Faculty of Science', Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Quick Links
                _buildSectionCard(
                  title: 'Quick Links',
                  icon: Icons.link,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuickLink('Official Website', 'https://www.nsbm.ac.lk/'),
                      _buildQuickLink('Degree Programmes', 'https://www.nsbm.ac.lk/undergraduate/'),
                      _buildQuickLink('Library', 'https://library.nsbm.ac.lk'),
                      _buildQuickLink('Alumni', 'https://www.nsbm.ac.lk/alumni/'),
                      _buildQuickLink('Careers', 'https://www.nsbm.ac.lk/careers-at-nsbm-green-university/'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    String? content,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color.fromARGB(255, 132, 192, 2),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (content != null)
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color.fromARGB(255, 132, 192, 2)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 132, 192, 2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacultyItem(String name, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLink(String title, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: Color.fromARGB(255, 132, 192, 2),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 132, 192, 2),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
