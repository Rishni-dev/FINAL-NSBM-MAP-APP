import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FULLMAP extends StatefulWidget {
  const FULLMAP({super.key});

  @override
  State<FULLMAP> createState() => _FULLMAPState();
}

class _FULLMAPState extends State<FULLMAP> {
  GoogleMapController? mapController;
  bool _isMapReady = false;
  bool _isLoading = true;
  String? _errorMessage;

  // NSBM Green University coordinates (more precise)
  // Location: Mahenwaththa, Pitipana, Homagama, Sri Lanka
  static const LatLng _nsbmLocation = LatLng(6.821100, 80.040900);
  
  final Set<Marker> _markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    try {
      // Create the NSBM campus marker
      final Marker nsbmMarker = Marker(
        markerId: const MarkerId('nsbm_campus'),
        position: _nsbmLocation,
        infoWindow: const InfoWindow(
          title: 'NSBM Green University',
          snippet: 'Mahenwaththa, Pitipana, Homagama, Sri Lanka',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      
      setState(() {
        _markers.add(nsbmMarker);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing map: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    try {
      if (!_isMapReady) {
        mapController = controller;
        setState(() {
          _isMapReady = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error creating map: ${e.toString()}';
      });
    }
  }

  void _onMapTap(LatLng position) {
    // Handle map tap if needed
    debugPrint('Map tapped at: ${position.latitude}, ${position.longitude}');
  }

  Future<void> _zoomToNSBM() async {
    if (mapController != null && _isMapReady) {
      try {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(
              target: _nsbmLocation,
              zoom: 17.0,
              bearing: 0.0,
              tilt: 0.0,
            ),
          ),
        );
      } catch (e) {
        debugPrint('Error zooming to NSBM: $e');
      }
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Map Loading Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                _initializeMap();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading Campus Map...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NSBM Campus Map'),
        backgroundColor: const Color.fromARGB(255, 132, 192, 2),
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isMapReady)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _zoomToNSBM,
              tooltip: 'Focus on NSBM Campus',
            ),
        ],
      ),
      body: _errorMessage != null
          ? _buildErrorWidget()
          : _isLoading
              ? _buildLoadingWidget()
              : Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      onTap: _onMapTap,
                      initialCameraPosition: const CameraPosition(
                        target: _nsbmLocation,
                        zoom: 16.0,
                      ),
                      markers: _markers,
                      mapType: MapType.satellite,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false, // We have our own button
                      zoomControlsEnabled: true,
                      compassEnabled: true,
                      mapToolbarEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      liteModeEnabled: false,
                      buildingsEnabled: true,
                      trafficEnabled: false,
                    ),
                    // Map controls overlay
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Column(
                        children: [
                          FloatingActionButton.small(
                            heroTag: "zoom_in",
                            onPressed: () async {
                              if (mapController != null) {
                                await mapController!.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              }
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.zoom_in, color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton.small(
                            heroTag: "zoom_out",
                            onPressed: () async {
                              if (mapController != null) {
                                await mapController!.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              }
                            },
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.zoom_out, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    // Map type toggle
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMapTypeButton('Satellite', MapType.satellite),
                            _buildMapTypeButton('Normal', MapType.normal),
                            _buildMapTypeButton('Hybrid', MapType.hybrid),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildMapTypeButton(String label, MapType mapType) {
    return InkWell(
      onTap: () {
        // This would require state management to change map type
        // For now, we'll keep it simple
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label view selected'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
