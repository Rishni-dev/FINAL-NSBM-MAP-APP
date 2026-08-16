import 'package:flutter/material.dart';

class TimeBlock extends StatelessWidget {
  TimeBlock({super.key, required this.time, required this.open});
  String time;
  bool open;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: open
          ? BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            )
          : BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
      child: Center(
          child: Text(
        time,
        style: open
            ? TextStyle(color: Colors.black)
            : TextStyle(color: Colors.white),
      )),
    );
  }
}
