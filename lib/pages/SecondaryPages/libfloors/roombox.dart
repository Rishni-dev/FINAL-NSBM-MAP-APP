import 'package:flutter/material.dart';

class RoomBox extends StatelessWidget {
  RoomBox({super.key, required this.selected, required this.nb});

  bool selected;
  String nb;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: selected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.red,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[300],
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Room"),
          Text(nb),
        ],
      ),
    );
  }
}
