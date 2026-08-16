import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsbm_map/pages/Components/gridcon.dart';
import 'package:nsbm_map/pages/SecondaryPages/clubandsocietypage.dart';
import 'package:nsbm_map/pages/SecondaryPages/lectureschedule.dart';
import 'package:nsbm_map/pages/SecondaryPages/membershippage.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now().hour;
    var grad = "";
    print(time);
    if (time <= 12) {
      grad = "Morning";
    } else {
      grad = "Afternoon";
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      // ignore: prefer_const_constructors
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docs = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good $grad ${docs[0]['name']}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey[100]),
                        height: 650,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  "Activity Based Clubs",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                height: 600,
                                child: GridView.count(
                                  primary: false,
                                  padding: const EdgeInsets.all(20),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  children: [
                                    GridCon(
                                      text: "Dancing Club",
                                      image: "dancing.png",
                                      onCl: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MembershipPage(
                                                type: "club",
                                                club: "Dancing Club",
                                              ),
                                            ));
                                      },
                                    ),
                                    GridCon(
                                      text: "Drama Club",
                                      image: "drama.png",
                                      onCl: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MembershipPage(
                                                type: "club",
                                                club: "Drama Club",
                                              ),
                                            ));
                                      },
                                    ),
                                    GridCon(
                                      text: "Literature Club",
                                      image: "lit.png",
                                      onCl: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MembershipPage(
                                                type: "club",
                                                club: "Literature Club",
                                              ),
                                            ));
                                      },
                                    ),
                                    GridCon(
                                      text: "Music Club",
                                      image: "music.png",
                                      onCl: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MembershipPage(
                                                type: "club",
                                                club: "Music Club",
                                              ),
                                            ));
                                      },
                                    ),
                                    GridCon(
                                      text: "Media & Photography Club",
                                      image: "photo.png",
                                      onCl: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MembershipPage(
                                                type: "club",
                                                club:
                                                    "Media & Photography Club",
                                              ),
                                            ));
                                      },
                                    ),
                                    GridCon(
                                      text: "Volunteers Club",
                                      image: "vol.png",
                                      onCl: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MembershipPage(
                                                type: "club",
                                                club: "Dancing Club",
                                              ),
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
