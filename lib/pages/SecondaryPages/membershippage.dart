import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key, required this.type, required this.club});
  final type;
  final club;
  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController email_c = new TextEditingController();
  TextEditingController ph = new TextEditingController();
  TextEditingController type = new TextEditingController();
  TextEditingController club = new TextEditingController();

  var clubs = [
    'Dancing Club',
    'Drama Club',
    'Literature Club',
    'Music Club',
    'Media & Photography Club',
    'Volunteers Club',
  ];
  var sports = [
    'Athletics Club',
    'Badminton Club',
    'Chess Club',
    'Cricket Club',
    'Martial Arts Club',
    'Table Tennis Club',
    'Swimming Club',
    'Rugby Club',
  ];

  String dropdownvalue1 = '1';
  String dropdownvalue2 = '0';

  @override
  Widget build(BuildContext context) {
    void submit() {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("wait")));
      FirebaseFirestore.instance.collection("membership").doc().set({
        'fn': fname.text,
        'ln': lname.text,
        'em': email_c.text,
        'ph': ph.text,
        's': widget.type,
        'c': widget.club,
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: const Text("Successfully submitted")));
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[100]),
                height: 900,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Membership Application Form",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: fname,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First Name",
                            suffixIcon: Icon(Icons.people)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: lname,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last Name",
                            suffixIcon: Icon(Icons.lock)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Nsbm Email",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: email_c,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email Address",
                            suffixIcon: Icon(Icons.mail)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Phone",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: ph,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Phone Number",
                            suffixIcon: Icon(Icons.mail)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Club / Society Category You wish to Join",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 20.0),

                      //     // child: DropdownButtonFormField(
                      //     //   value: dropdownvalue1,
                      //     //   decoration: const InputDecoration(
                      //     //     border: OutlineInputBorder(),
                      //     //   ),
                      //     //   items: [
                      //     //     const DropdownMenuItem(
                      //     //       value: '1',
                      //     //       child: Text("sport"),
                      //     //     ),
                      //     //     const DropdownMenuItem(
                      //     //       value: '2',
                      //     //       child: Text("club"),
                      //     //     ),
                      //     //   ],
                      //     //   onChanged: (value) {
                      //     //     setState(() {
                      //     //       dropdownvalue1 = value.toString();
                      //     //     });
                      //     //     print(dropdownvalue1);
                      //     //   },
                      //     // ),
                      //   ),
                      // ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: widget.type.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Club / Society Category You wish to Join",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: widget.club.toString(),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 185, 185, 185)),
                        width: 100,
                        child: GestureDetector(
                          onTap: submit,
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
