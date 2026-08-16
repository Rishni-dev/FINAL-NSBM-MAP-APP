import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapPage1 extends StatefulWidget {
  @override
  _MapPageState1 createState() => _MapPageState1();
}

class _MapPageState1 extends State<MapPage1> {
  String? currentLocation;
  String? destination;
  String selectedGif = 'lib/assets/LOWER LEVEL1.png';

  final List<String> lectureHalls = [
    "Lecture hall - 107", "Lecture hall - 106", "Lecture hall - 105", 
    "Lecture hall - 104", "Lecture hall - 102"
  ];

  final Map<String, String> gifMap = {
   "106-105": "lib/assets/NSBML1 (1).gif",
    "102-107": "lib/assets/NSBML1 (2).gif",
    "106-102": "lib/assets/NSBML1 (3).gif",
    "105-106": "lib/assets/NSBML1 (4).gif",
    "102-104": "lib/assets/NSBML1 (5).gif",
    "106-104": "lib/assets/NSBML1 (6).gif",
    "107-104": "lib/assets/NSBML1 (7).gif",
    "107-102": "lib/assets/NSBML1 (8).gif",
    "102-106": "lib/assets/NSBML1 (9).gif",
    "107-106": "lib/assets/NSBML1 (10).gif",
    "106-107": "lib/assets/NSBML1 (11).gif",
    "105-107": "lib/assets/NSBML1 (12).gif",
    "104-106": "lib/assets/NSBML1 (13).gif",
    "102-105": "lib/assets/NSBML1 (15).gif",
    "105-102": "lib/assets/NSBML1 (16).gif",
    "104-102": "lib/assets/NSBML1 (17).gif",
    "107-105": "lib/assets/NSBML1 (18).gif",
    "105-104": "lib/assets/NSBML1 (19).gif",
    "104-105": "lib/assets/NSBML1 (20).gif",
    "104-107": "lib/assets/NSBML1 (21).gif",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LOWER LEVEL 1")),
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
                selectedGif = getGifFile(currentLocation, destination) ?? 'lib/assets/LOWER LEVEL1.png'; 
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
            child: PhotoView(
              imageProvider: AssetImage(selectedGif),
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
