import 'package:flutter/material.dart';

class InputFieldText extends StatelessWidget {
  const InputFieldText(this.textCus);
  final String textCus;

  @override
  Widget build(BuildContext context) {
    return Text(
      textCus,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}
