import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:nsbm_map/pages/SecondaryPages/libfloors/confirmpage.dart';
import 'package:nsbm_map/pages/SecondaryPages/libfloors/groundfloor.dart';
import 'package:nsbm_map/pages/SecondaryPages/libfloors/timeblock.dart';

class BookFloor extends StatefulWidget {
  BookFloor(
      {super.key, required this.day, required this.floor, required this.room});

  String day;
  String floor;
  String room;
  @override
  State<BookFloor> createState() => _BookFloorState();
}

class _BookFloorState extends State<BookFloor> {
  List SelectedTimes = [];
  Future sendMail() async {
    // print("object");
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
      },
      body: json.encode(
        {
          'service_id': 'service_dnzby66',
          'template_id': 'template_3yokpwr',
          'user_id': 'TbXeoWXJeXAU0i82K',
          // 'private_key': 'lNDy6rwq8ih0STnokwi-s',
          'template_params': {
            'user_email': FirebaseAuth.instance.currentUser!.email,
            'message':
                "Your Boocking ${widget.day} in floor ${widget.floor} room number is ${widget.room} is successful",
          }
        },
      ),
    );
    print(response.body);
  }

  var nb = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios)),
                        Icon(Icons.close),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('library')
                            .where('day', isEqualTo: widget.day)
                            .where('room', isEqualTo: widget.room)
                            .where('floor', isEqualTo: widget.floor)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List ti = [
                              "09",
                              "10",
                              "11",
                              "12",
                              "13",
                              "14",
                              "15",
                              "16",
                            ];
                            List boocked = [
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true
                            ];
                            List til = [
                              ["09", true],
                              ["10", true],
                              ["11", true],
                              ["12", true],
                              ["13", true],
                              ["14", true],
                              ["15", true],
                              ["16", true]
                            ];

                            List times = [];
                            var docs = snapshot.data!.docs;
                            if (docs.isNotEmpty) {
                              List timesBoocked = [];
                              var i = 0;
                              while (i < docs.length) {
                                timesBoocked.add(docs[i]["time"]);
                                i++;
                              }
                              timesBoocked.sort();

                              i = 0;
                              nb = 0;
                              while (i != timesBoocked.length) {
                                if (ti.contains(timesBoocked[i])) {
                                  int x = ti.indexOf("${timesBoocked[i]}");
                                  boocked[x] = false;
                                  nb++;
                                  print(nb);
                                }
                                // print(i);

                                i++;
                              }

                              // var x = 0;

                              // while (x != ti.length) {
                              //   while (i != docs.length) {
                              //     print(docs[i]["time"]);
                              //     if (docs[i]["time"] == ti[x]) {
                              //       times.add([ti[x], false]);
                              //     } else {
                              //       times.add([ti[x], true]);
                              //     }

                              //     i++;
                              //   }

                              //   i = 0;
                              //   x++;
                              // }

                              return SizedBox(
                                height: 300,
                                child: GridView.builder(
                                  itemCount: til.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 70),
                                  itemBuilder: (context, index) {
                                    return boocked[index]
                                        ? Center(
                                            child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (SelectedTimes.contains(
                                                    til[index][0])) {
                                                  SelectedTimes.remove(
                                                      til[index][0]);
                                                } else {
                                                  SelectedTimes.add(
                                                      til[index][0]);
                                                }
                                                SelectedTimes.sort();
                                              });
                                            },
                                            child: TimeBlock(
                                              open: boocked[index],
                                              time: "${til[index][0]}.00",
                                            ),
                                          ))
                                        : Center(
                                            child: GestureDetector(
                                            child: TimeBlock(
                                              open: boocked[index],
                                              time: "${til[index][0]}.00",
                                            ),
                                          ));
                                  },
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 300,
                                child: GridView.builder(
                                  itemCount: til.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 70),
                                  itemBuilder: (context, index) {
                                    return Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (SelectedTimes.contains(
                                              til[index][0])) {
                                            SelectedTimes.remove(til[index][0]);
                                          } else {
                                            SelectedTimes.add(til[index][0]);
                                          }
                                          SelectedTimes.sort();

                                          // print(SelectedTimes);
                                        });
                                      },
                                      child: TimeBlock(
                                        open: true,
                                        time: "${til[index][0]}.00",
                                      ),
                                    ));
                                  },
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child:
                                  SizedBox(child: CircularProgressIndicator()),
                            );
                          }
                        }),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: SelectedTimes.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 40,
                            width: 60,
                            child: Center(
                              child: Text("${SelectedTimes[index]}.00"),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        await sendMail();

                        nb = nb + SelectedTimes.length;

                        if (nb == 8) {
                          FirebaseFirestore.instance
                              .collection('rooms')
                              .doc("${widget.day}:${widget.room}")
                              .set({
                            'id': "${widget.day}:${widget.room}",
                            'day': widget.day,
                            'room': widget.room,
                            'floor': widget.floor,
                            'st': true,
                          });
                        }
                        Navigator.pop(context);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmationPage(
                                    day: widget.day,
                                    floor: widget.floor,
                                    room: widget.room,
                                    times: SelectedTimes,
                                  )),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(255, 182, 46, 46)),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15),
                          child: Center(
                            child: Text(
                              "Got it",
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
