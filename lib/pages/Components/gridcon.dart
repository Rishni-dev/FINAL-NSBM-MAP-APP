import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nsbm_map/pages/SecondaryPages/lectureschedule.dart';

class GridCon extends StatelessWidget {
  GridCon({required this.text, required this.image, required this.onCl});

  final String text;
  final String image;
  final void Function() onCl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCl,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/${image}',
              height: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ))
          ],
        ),
      ),
    );
  }
}
