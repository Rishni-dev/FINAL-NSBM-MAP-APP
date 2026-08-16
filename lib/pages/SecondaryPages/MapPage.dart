import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? currentLocation;
  String? destination;
  String selectedGif = 'lib/assets/LOWER LEVEL2.png';

  final List<String> lectureHalls = [
    "Lecture hall - 205", "Lecture hall - 204", "Lecture hall - 203", 
    "Lecture hall - 202", "Lecture hall - 206", "Lecture hall - 207"
  ];

  final Map<String, String> gifMap = {
    "205-204": "lib/assets/NSBM (1).gif",
    "205-203": "lib/assets/NSBM (2).gif",
    "205-202": "lib/assets/NSBM (3).gif",
    "205-206": "lib/assets/NSBM (4).gif",
    "205-207": "lib/assets/NSBM (5).gif",
    "204-207": "lib/assets/NSBM (6).gif",
    "204-206": "lib/assets/NSBM (7).gif", // 204 - 206
    "204-203": "lib/assets/NSBM (8).gif",
    "204-202": "lib/assets/NSBM (9).gif",  // 204-202
    "204-205": "lib/assets/NSBM (10).gif", // 204- 205
    "203-202": "lib/assets/NSBM (11).gif",
    "203-206": "lib/assets/NSBM (12).gif",
    "203-207": "lib/assets/NSBM (13).gif",
    "203-205": "lib/assets/NSBM (14).gif",
    "203-204": "lib/assets/NSBM (15).gif",
    "202-203": "lib/assets/NSBM (16).gif",
    "202-204": "lib/assets/NSBM (17).gif",
    "202-205": "lib/assets/NSBM (18).gif",
    "202-206": "lib/assets/NSBM (19).gif",
    "202-207": "lib/assets/NSBM (20).gif",
    "207-202": "lib/assets/NSBM (21).gif",
    "207-203": "lib/assets/NSBM (22).gif",
    "207-204": "lib/assets/NSBM (23).gif",
    "207-205": "lib/assets/NSBM (24).gif",
    "207-206": "lib/assets/NSBM (25).gif",
    "206-207": "lib/assets/NSBM (26).gif",
    "206-202": "lib/assets/NSBM (27).gif",
    "206-203": "lib/assets/NSBM (28).gif",
    "206-204": "lib/assets/NSBM (29).gif",
    "206-205": "lib/assets/NSBM (30).gif",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LOWER LEVEL 2")),
      body: Column(
        children: [
          DropdownButton<String>(
            value: currentLocation,
            hint: Text("Select your current location"),
            onChanged: (value) {
              setState(() {
                currentLocation = value;
              });
            },
            items: lectureHalls.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: destination,
            hint: Text("Select your destination"),
            onChanged: (value) {
              setState(() {
                destination = value;
                selectedGif = getGifFile(currentLocation, destination) ?? 'lib/assets/LOWER LEVEL2.png'; 
              });
            },
            items: lectureHalls.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: selectedGif == null
              ? Center(child: Text("Select both locations to view map"))
              : PhotoView(
              imageProvider: AssetImage(selectedGif!),
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, error, stackTrace) => Center(
                child: Text('Failed to load image: $error'),
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          )
        ],
      ),
    );
  }

  String? getGifFile(String? current, String? dest) {
    if (current == null || dest == null) return null;
    return gifMap["${current.split(' - ').last}-${dest.split(' - ').last}"];
  }
}

