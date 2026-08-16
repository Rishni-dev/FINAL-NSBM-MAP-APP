import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nsbm_map/pages/Components/lectiletwo.dart';
import 'package:nsbm_map/pages/Components/lectitle.dart';

class LectureSchedule extends StatelessWidget {
  const LectureSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.now();

    int month = int.parse(dt.month.toString());
    int day1 = int.parse(dt.day.toString()) - 2;
    int day2 = int.parse(dt.day.toString()) - 1;
    int day3 = int.parse(dt.day.toString());
    int day4 = int.parse(dt.day.toString()) + 1;
    int day5 = int.parse(dt.day.toString()) + 2;

    String date1 = DateFormat('E').format(DateTime(2024, month, day1));
    String date2 = DateFormat('E').format(DateTime(2024, month, day2));
    String date3 = DateFormat('E').format(DateTime(2024, month, day3));
    String date4 = DateFormat('E').format(DateTime(2024, month, day4));
    String date5 = DateFormat('E').format(DateTime(2024, month, day5));
    List dates = ['SUN', "MON", "TUE", "WED", "THU", "FRI", "SAT"];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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

                      return dt.hour <= 11
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
                  }),
              SizedBox(
                height: 20,
              ),
              Text(
                "Lecture Schedule",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: GridView.count(
                    scrollDirection: Axis.vertical,
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 5,
                    children: [
                      LecTile(day1.toString(), date1, false),
                      LecTile(day2.toString(), date2, false),
                      LecTile(day3.toString(), date3, true),
                      LecTile(day4.toString(), date4, false),
                      LecTile(day5.toString(), date5, false),
                    ]),
              ),
              SizedBox(
                height: 50,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Lectures")
                      .where("date", isEqualTo: dt.day)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var doc = snapshot.data!.docs;
                      return SizedBox(
                        child: ListView.builder(
                          itemCount: doc.length,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => LecTileTwo(
                            "${doc[index]['lcName']}",
                            "${doc[index]['lcNb']}",
                            "${doc[index]['from']}",
                            "${doc[index]['to']}",
                            "${doc[index]['du']}",
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("Wait"),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
