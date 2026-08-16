import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nsbm_map/pages/mainPages/feedbackpage.dart';
import 'package:nsbm_map/pages/mainPages/guesthome.dart';
import 'package:nsbm_map/pages/mainPages/notificataionpage.dart';
import 'package:nsbm_map/pages/startingactivity.dart';

class GuestHomePage extends StatefulWidget {
  const GuestHomePage({super.key});

  @override
  State<GuestHomePage> createState() => _GuestHomePageState();
}

int ACTIVENUMBER = 0;
// List pages = [];
List pages = [
  GuestHome(),
  FeedbackPage(),
  NotificationPage(
    notif: "gNotifications",
  ),
  NotificationPage(
    notif: "gNotifications",
  ),
];

class _GuestHomePageState extends State<GuestHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[ACTIVENUMBER],
      bottomNavigationBar: GNav(
          onTabChange: (value) {
            setState(() {
              ACTIVENUMBER = value;
            });
            if (ACTIVENUMBER == 3) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StartingActivity()));
            }
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.feedback,
              text: 'feedback',
            ),
            GButton(
              icon: Icons.notifications,
              text: 'Notifications',
            ),
            GButton(
              icon: Icons.logout,
              text: 'Logout',
            ),
          ]),
    );
  }
}
