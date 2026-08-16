import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:nsbm_map/pages/Components/inputfieldcustom.dart';
import 'package:nsbm_map/pages/Components/inputfieldtext.dart';
import 'package:nsbm_map/pages/Login/otppage.dart';
import 'package:uuid/uuid.dart';

class LoginTwo extends StatelessWidget {
  const LoginTwo({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailTextController = TextEditingController();
    // EmailOTP myAuth = EmailOTP();

    var otp;
// var uuid = Uuid();
    Future sendMail() async {
      final random = Random();

      otp = random.nextInt(999999 - 111111);
      print(emailTextController.text);
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
        },
        body: json.encode(
          {
            'service_id': 'service_dnzby66',
            'template_id': 'template_3yokpwr',
            'user_id': 'TbXeoWXJeXAU0i82K',
            // 'private_key': 'lNDy6rwq8ih0STnokwi-s',
            'template_params': {
              'user_email': emailTextController.text,
              'message': "Your OTP is ${otp}",
            }
          },
        ),
      );
      print("yes");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              otp: otp,
              email: emailTextController.text,
              mobile: "",
            ),
          ));

      // try {
      //   await FirebaseAuth.instance
      //       .sendPasswordResetEmail(email: emailTextController.text);
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text("email sent")));
      //   Navigator.pop(context);
      // } on FirebaseAuthException catch (e) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(e.message.toString())));
      // }
    }

// XL82YPW41E3M3C9L3BN527TU
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InputFieldText("Enter Your Email"),
                InputFieldCustom("Enter Email", emailTextController),
                const SizedBox(
                  height: 25,
                ),
                const Divider(height: 1, color: Colors.black),
                const SizedBox(
                  height: 20,
                ),
                // const Center(
                //   child: Text(
                //     "OR",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                //   ),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // const InputFieldText("Mobile Number"),
                // InputFieldCustom(
                //     "Enter Your Mobile Number", emailTextController),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: TextButton(
                    onPressed: sendMail,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 120.0, vertical: 10),
                      child: Text(
                        "Send",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 204, 204, 204))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
