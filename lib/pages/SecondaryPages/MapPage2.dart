import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class MapPage2 extends StatefulWidget {
  @override
  _MapPageState2 createState() => _MapPageState2();
}

class _MapPageState2 extends State<MapPage2> {
  String? currentLocation;
  String? destination;
  String selectedGif = 'lib/assets/GroundFloor.png';

  final List<String> lectureHalls = [
    "Lecture hall - 008", "Lecture hall - 007", "Lecture hall - 006", 
    "Lecture hall - 005", "Lecture hall - 004"
  ];

  final Map<String, String> gifMap = {
    "008-005": "lib/assets/NSBM2 (1).gif",
    "007-005": "lib/assets/NSBM2 (2).gif",
    "007-006": "lib/assets/NSBM2 (3).gif",
    "005-006": "lib/assets/NSBM2 (4).gif",
    "007-008": "lib/assets/NSBM2 (5).gif",
    "006-008": "lib/assets/NSBM2 (6).gif",
    "006-007": "lib/assets/NSBM2 (7).gif",
    "005-004": "lib/assets/NSBM2 (8).gif",
    "005-007": "lib/assets/NSBM2 (9).gif",
    "006-005": "lib/assets/NSBM2 (10).gif",
    "006-004": "lib/assets/NSBM2 (11).gif",
    "008-004": "lib/assets/NSBM2 (12).gif",
    "004-007": "lib/assets/NSBM2 (13).gif",
    "005-008": "lib/assets/NSBM2 (14).gif",
    "008-007": "lib/assets/NSBM2 (15).gif",
    "004-005": "lib/assets/NSBM2 (16).gif",
    "008-006": "lib/assets/NSBM2 (17).gif",
    "004-008": "lib/assets/NSBM2 (18).gif",
    "004-006": "lib/assets/NSBM2 (19).gif",
    "007-004": "lib/assets/NSBM2 (20).gif",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ground Floor")),
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
                selectedGif = getGifFile(currentLocation, destination) ?? 'lib/assets/GroundFloor.png'; 
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
)
,
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

