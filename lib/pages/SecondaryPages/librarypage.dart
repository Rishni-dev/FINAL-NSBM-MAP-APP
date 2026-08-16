import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nsbm_map/pages/SecondaryPages/floorselection.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.now();
    var day = "${dt.month}:${dt.day}";

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Let's find you a study space",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Search by",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                    onDateChanged: (value) {
                      day = "${value.month}:${value.day}";
                      print(day);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    print(day);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FloorSelection(day: day),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 182, 46, 46)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15),
                      child: Center(
                        child: Text(
                          "Check Availability",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Reservations"),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('library')
                                .where('uid',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var docs = snapshot.data!.docs;
                                if (docs.length == 0) {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Text("No Reservations"),
                                  ));
                                } else {
                                  return ListView.builder(
                                    itemCount: docs.length,
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var dt = docs[index]['day'].split(':');

                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Room ${docs[index]['room']}  ${docs[index]['floor'] == '0' ? "GroundFloor" : "Floor ${docs[index]['floor']}"}",
                                                ),
                                                Text(DateFormat('MMMd').format(
                                                    DateTime.parse(
                                                        "2024-0${dt[0]}-${dt[1]}"))),
                                                Text(
                                                  "${docs[index]['time']} - ${int.parse(docs[index]['time']) + 1}",
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.red)),
                                              onPressed: () {
                                                print(
                                                    "${docs[index]['day']}:${docs[index]['room']}");
                                                FirebaseFirestore.instance
                                                    .collection('library')
                                                    .doc(docs[index]['id'])
                                                    .delete();
                                                FirebaseFirestore.instance
                                                    .collection('rooms')
                                                    .doc(
                                                        "${docs[index]['day']}:${docs[index]['room']}")
                                                    .delete();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
