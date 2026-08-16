import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InputFieldCustom extends StatelessWidget {
  const InputFieldCustom(this.textHint, this.controller);

  final String textHint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: textHint,
          border: InputBorder.none,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
