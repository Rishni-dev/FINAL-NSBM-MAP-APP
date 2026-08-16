import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LecTileTwo extends StatelessWidget {
  LecTileTwo(
    this.LectureName,
    this.LectureNb,
    this.from,
    this.to,
    this.du,
  );
  final String LectureName;
  final String LectureNb;
  final String from;
  final String to;
  final String du;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.square),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LectureName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(LectureNb),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${from} - ${to}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(du),
            ],
          ),
        ],
      ),
    );
  }
}
