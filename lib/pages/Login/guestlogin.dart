import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsbm_map/pages/Components/inputfieldcustom.dart';
import 'package:nsbm_map/pages/Components/inputfieldtext.dart';
import 'package:nsbm_map/pages/homepageguest.dart';

class GuestLogin extends StatelessWidget {
  const GuestLogin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passTextController = TextEditingController();

    void login() async {
      print(passTextController.text);
      if (passTextController.text == "") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Empty Passcode, Try again")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please Wait")));
        await FirebaseFirestore.instance
            .collection("GuestPass")
            .doc(passTextController.text)
            .get()
            .then((DocumentSnapshot DocumentSnapshot) {
          if (DocumentSnapshot.exists) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GuestHomePage(),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Incorrect Passcode, Try again")));
          }
        });
      }
    }

    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/introbg.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Welcome to NSBM",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'lib/assets/image.png',
                height: 170,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            const InputFieldText("Enter Your Passcode"),
            InputFieldCustom("Enter Passcode", passTextController),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 97, 205, 20),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                    child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
