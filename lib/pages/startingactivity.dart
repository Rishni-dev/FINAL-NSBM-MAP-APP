import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nsbm_map/homebase.dart';
import 'package:nsbm_map/pages/Login/loginpage.dart';

class StartingActivity extends StatefulWidget {
  const StartingActivity({super.key});

  @override
  State<StartingActivity> createState() => _StartingActivityState();
}

class _StartingActivityState extends State<StartingActivity> {
  @override
  Widget build(BuildContext context) {
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
          children: [
            Image.asset(
              'lib/assets/image.png',
              height: 170,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "100% Government owned global level university",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  try {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeBase(),
                        ));
                  } catch (e) {
                    print(e);
                  }
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 97, 205, 20),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                    child: Text(
                  "Get Started",
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
