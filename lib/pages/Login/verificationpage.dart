import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "6 digit-code",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Enter the code we send to ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: VerificationCode(
                underlineColor: Colors.purple,
                isSecure: false,
                keyboardType: TextInputType.number,
                digitsOnly: true,
                length: 6,
                fullBorder: true,
                textStyle: const TextStyle(fontSize: 20.0, color: Colors.black),
                onCompleted: (e) {},
                onEditing: (e) {},
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Code is expired in 4:57s",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Resend ",
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
