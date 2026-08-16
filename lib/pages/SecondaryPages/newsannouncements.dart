import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsAnnouncementsPage extends StatelessWidget {
  const NewsAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsItems = [
      {
        'title': 'NSBM Association of Information Systems Hosts GITZEN 1.0',
        'subtitle': 'Exploring GitHub & Python',
        'description':
            'NSBM Association of Information Systems hosts an educational workshop focusing on GitHub and Python development.',
        'date': 'March 2026',
        'url':
            'https://www.nsbm.ac.lk/nsbm-association-of-information-systems-hosts-gitzen-1-0-exploring-github-python/'
      },
      {
        'title': 'Tourism Undergraduates at NSBM Hosts YAKARI 2026',
        'subtitle': 'Annual Gastronomic Festival',
        'description':
            'YAKARI 2026, the annual gastronomic festival organized by Tourism Undergraduates showcasing culinary excellence.',
        'date': 'March 2026',
        'url': 'https://www.nsbm.ac.lk/tourism-undergraduates-at-nsbm-hosts-yakari-2026/'
      },
      {
        'title': 'NSBM Students\' Wellbeing Association Celebrates SECMIC\'26',
        'subtitle': 'Student Wellbeing Initiative',
        'description':
            'The Students\' Wellbeing Association of NSBM Green University celebrates SECMIC\'26 focusing on student mental health and wellness.',
        'date': 'March 2026',
        'url': 'https://www.nsbm.ac.lk/nsbm-students-wellbeing-association-celebrates-secmic26/'
      },
      {
        'title': 'Grand Crown Launching Ceremony',
        'subtitle': 'Siyapathsiya Udanaya Avurudu Kumara Kumariya 2026',
        'description':
            'Setting the stage for the traditional New Year celebrations with the crown launching ceremony.',
        'date': 'March 2026',
        'url':
            'https://www.nsbm.ac.lk/grand-crown-launching-ceremony-of-siyapathsiya-udanaya-avurudu-kumara-kumariya-2026/'
      },
      {
        'title': 'NSBM Faculty of Science Conducts Workshop',
        'subtitle': 'Edexcel Science Practical Workshop',
        'description':
            'NSBM Faculty of Science conducts comprehensive Edexcel Science Practical Workshop for students.',
        'date': 'March 2026',
        'url':
            'https://www.nsbm.ac.lk/nsbm-faculty-of-science-conducts-edexcel-science-practical-workshop/'
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        title: const Text('News & Announcements'),
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
                const SizedBox(height: 10),
                const Text(
                  'Latest News & Updates',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Stay updated with the latest happenings at NSBM Green University',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsItems.length,
                  itemBuilder: (context, index) {
                    return _buildNewsCard(context, newsItems[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, Map<String, String> newsItem) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse(newsItem['url']!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open the link'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 132, 192, 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      newsItem['date']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                newsItem['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                newsItem['subtitle']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 132, 192, 2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                newsItem['description']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Read More',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 132, 192, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: const Color.fromARGB(255, 132, 192, 2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
