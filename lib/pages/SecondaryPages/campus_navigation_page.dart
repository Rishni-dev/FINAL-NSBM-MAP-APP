import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/nfc_location.dart';

class CampusNavigationPage extends StatefulWidget {
  final NFCLocation targetLocation;
  final Position? currentPosition;

  const CampusNavigationPage({
    super.key,
    required this.targetLocation,
    this.currentPosition,
  });

  @override
  State<CampusNavigationPage> createState() => _CampusNavigationPageState();
}

class _CampusNavigationPageState extends State<CampusNavigationPage> {
  Position? _currentPosition;
  double? _distance;
  double? _bearing;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.currentPosition;
    if (_currentPosition != null) {
      _calculateNavigation();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _calculateNavigation();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    }
  }

  void _calculateNavigation() {
    if (_currentPosition == null) return;

    final distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      widget.targetLocation.latitude,
      widget.targetLocation.longitude,
    );

    final bearing = Geolocator.bearingBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      widget.targetLocation.latitude,
      widget.targetLocation.longitude,
    );

    setState(() {
      _distance = distance;
      _bearing = bearing;
    });
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} meters';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} kilometers';
    }
  }

  String _getDirectionText(double bearing) {
    // Convert bearing to compass direction
    if (bearing >= -22.5 && bearing < 22.5) return 'North';
    if (bearing >= 22.5 && bearing < 67.5) return 'Northeast';
    if (bearing >= 67.5 && bearing < 112.5) return 'East';
    if (bearing >= 112.5 && bearing < 157.5) return 'Southeast';
    if (bearing >= 157.5 || bearing < -157.5) return 'South';
    if (bearing >= -157.5 && bearing < -112.5) return 'Southwest';
    if (bearing >= -112.5 && bearing < -67.5) return 'West';
    if (bearing >= -67.5 && bearing < -22.5) return 'Northwest';
    return 'Unknown';
  }

  IconData _getDirectionIcon(double bearing) {
    if (bearing >= -22.5 && bearing < 22.5) return Icons.north;
    if (bearing >= 22.5 && bearing < 67.5) return Icons.north_east;
    if (bearing >= 67.5 && bearing < 112.5) return Icons.east;
    if (bearing >= 112.5 && bearing < 157.5) return Icons.south_east;
    if (bearing >= 157.5 || bearing < -157.5) return Icons.south;
    if (bearing >= -157.5 && bearing < -112.5) return Icons.south_west;
    if (bearing >= -112.5 && bearing < -67.5) return Icons.west;
    if (bearing >= -67.5 && bearing < -22.5) return Icons.north_west;
    return Icons.explore;
  }

  List<String> _getNavigationInstructions() {
    final instructions = <String>[];

    // Basic campus navigation instructions
    instructions.add(
      'Head ${_bearing != null ? _getDirectionText(_bearing!) : 'towards'} ${widget.targetLocation.name}',
    );

    // Faculty-specific instructions
    if (widget.targetLocation.facultyName.isNotEmpty) {
      instructions.add(
        'Look for signs to ${widget.targetLocation.facultyName}',
      );
    }

    // Building-specific instructions
    if (widget.targetLocation.buildingCode.isNotEmpty) {
      instructions.add('Enter building ${widget.targetLocation.buildingCode}');
    }

    // Level-specific instructions
    if (widget.targetLocation.mapLevel != 'Ground') {
      if (widget.targetLocation.mapLevel.toLowerCase().contains('level')) {
        instructions.add('Go to ${widget.targetLocation.mapLevel}');
      } else {
        instructions.add('Go to ${widget.targetLocation.mapLevel} floor');
      }
    }

    // Room-specific instructions
    if (widget.targetLocation.roomNumber.isNotEmpty) {
      instructions.add('Find room ${widget.targetLocation.roomNumber}');
    }

    return instructions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        title: Text('Campus Navigation'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _getCurrentLocation),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Destination Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: Colors.red[700], size: 30),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Destination',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.targetLocation.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.targetLocation.fullLocationName,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Navigation Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (_isLoadingLocation) ...[
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Getting your location...'),
                    ] else if (_currentPosition == null) ...[
                      Icon(
                        Icons.location_disabled,
                        size: 50,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Location not available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enable location services to get navigation directions',
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      // Direction Indicator
                      if (_bearing != null) ...[
                        Transform.rotate(
                          angle:
                              (_bearing! * 3.14159) / 180, // Convert to radians
                          child: Icon(
                            _getDirectionIcon(_bearing!),
                            size: 80,
                            color: Colors.blue[700],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          _getDirectionText(_bearing!),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],

                      if (_distance != null) ...[
                        SizedBox(height: 16),
                        Text(
                          _formatDistance(_distance!),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'to destination',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Navigation Instructions Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.list, color: Colors.green[700]),
                        SizedBox(width: 8),
                        Text(
                          'Step-by-Step Directions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ...List.generate(_getNavigationInstructions().length, (
                      index,
                    ) {
                      final instruction = _getNavigationInstructions()[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                instruction,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Action Buttons
            if (_currentPosition != null) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: Icon(Icons.my_location),
                  label: Text('Update My Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
            ],

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _currentPosition == null
                    ? _getCurrentLocation
                    : null,
                icon: _isLoadingLocation
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.navigation),
                label: Text(
                  _currentPosition == null
                      ? (_isLoadingLocation
                            ? 'Getting Location...'
                            : 'Enable Location')
                      : 'Navigation Active',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPosition != null
                      ? Colors.green[700]
                      : Colors.grey[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
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
