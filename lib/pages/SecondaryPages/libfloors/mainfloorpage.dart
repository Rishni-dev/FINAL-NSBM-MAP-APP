import 'package:flutter/material.dart';
import 'package:nsbm_map/pages/SecondaryPages/libfloors/bookfloor.dart';
import 'package:nsbm_map/pages/SecondaryPages/libfloors/groundfloor.dart';

class MainFloor extends StatefulWidget {
  MainFloor({super.key, required this.day, required this.floornb});
  String day;
  int floornb;
  @override
  State<MainFloor> createState() => _MainFloorState();
}

class _MainFloorState extends State<MainFloor> {
  @override
  Widget build(BuildContext context) {
    List floors = [
      GroundFloor(day: widget.day),
      BookFloor(
        day: widget.day,
        floor: "1",
        room: "10",
      ),
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_back_ios_outlined,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 500, child: floors[widget.floornb]),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.floornb = 1;
                        });
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
                  ],
                ))),
      ),
    );
  }
}
