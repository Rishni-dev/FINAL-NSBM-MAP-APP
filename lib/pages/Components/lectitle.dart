import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LecTile extends StatelessWidget {
  LecTile(this.day, this.dayN, this.today);

  final String day;
  final bool today;
  final String dayN;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          today
              ? Text(
                  dayN,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                )
              : Text(
                  dayN,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
          today
              ? Text(
                  day,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.purple),
                )
              : Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
        ],
      ),
    );
  }
}
