import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsbm_map/pages/Components/gridcon.dart';
import 'package:nsbm_map/pages/SecondaryPages/membershippage.dart';

class SportPage extends StatelessWidget {
  const SportPage({super.key});

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
                          height: 850,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    "Sport Clubs",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 800,
                                  child: GridView.count(
                                    primary: false,
                                    padding: const EdgeInsets.all(20),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,
                                    children: [
                                      GridCon(
                                        text: "Athletics Club  ",
                                        image: "athletics.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Athletics Club",
                                                ),
                                              ));
                                        },
                                      ),
                                      GridCon(
                                        text: "Badminton Club",
                                        image: "badminton.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Badminton Club",
                                                ),
                                              ));
                                        },
                                      ),
                                      GridCon(
                                        text: "Chess Club",
                                        image: "chess.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Chess Club",
                                                ),
                                              ));
                                        },
                                      ),
                                      GridCon(
                                          text: "Cricket Club",
                                          image: "cricket.png",
                                          onCl: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MembershipPage(
                                                    type: "Sport",
                                                    club: "Cricket Club",
                                                  ),
                                                ));
                                          }),
                                      GridCon(
                                        text: "Martial Arts Club",
                                        image: "martial.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Martial Arts Club",
                                                ),
                                              ));
                                        },
                                      ),
                                      GridCon(
                                        text: "Table Tennis Club",
                                        image: "martial.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Table Tennis Club",
                                                ),
                                              ));
                                        },
                                      ),
                                      GridCon(
                                        text: "Swimming Club",
                                        image: "swimming.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Swimming Club",
                                                ),
                                              ));
                                        },
                                      ),
                                      GridCon(
                                        text: "Rugby Club",
                                        image: "rugby.png",
                                        onCl: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MembershipPage(
                                                  type: "Sport",
                                                  club: "Rugby Club",
                                                ),
                                              ),);
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
            }));
  }
}
