import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsbm_map/homebase.dart';
import 'package:http/http.dart' as http;
import 'package:nsbm_map/pages/SecondaryPages/librarypage.dart';
import 'package:uuid/uuid.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage(
      {super.key,
      required this.day,
      required this.times,
      required this.room,
      required this.floor});
  final String day;
  final List times;

  final String floor;
  final String room;
  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  void initState() {
    var uuid = Uuid();
    // TODO: implement initState
    int i = 0;
    while (i != widget.times.length) {
      var idi = uuid.v1();

      FirebaseFirestore.instance.collection("library").doc(idi).set({
        "day": widget.day,
        "floor": widget.floor,
        "room": widget.room,
        "time": widget.times[i],
        "uid": FirebaseAuth.instance.currentUser!.uid,
        'id': idi,
      });
      i++;
    }

    super.initState();
  }

  Future sendMail() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url);
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    var dt = widget.day.split(':');
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "You're all set!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Confirmation Email Sent to ${FirebaseAuth.instance.currentUser!.email}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMMd').format(
                                    DateTime.parse("2024-0${dt[0]}-${dt[1]}")),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "${widget.times[0]}.00 to ${int.parse(widget.times.last) + 1}.00",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.floor == '0' ? "GroundFloor" : "Floor ${widget.floor}"}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Quiet Study Space",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeBase()));
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
              )
            ],
          ),
        ));
  }
}
