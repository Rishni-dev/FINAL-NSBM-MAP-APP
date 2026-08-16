import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nsbm_map/services/nfc_service.dart';
import 'package:nsbm_map/models/nfc_scan_result.dart';
import 'package:nsbm_map/models/nfc_location.dart';
import 'location_details_page.dart';

class NFCScannerPage extends StatefulWidget {
  const NFCScannerPage({super.key});

  @override
  State<NFCScannerPage> createState() => _NFCScannerPageState();
}

class _NFCScannerPageState extends State<NFCScannerPage>
    with TickerProviderStateMixin {
  final NFCService _nfcService = NFCService();
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  StreamSubscription<NFCScanResult>? _scanSubscription;
  
  bool _isNFCAvailable = false;
  bool _isScanning = false;
  String _statusMessage = 'Checking NFC availability...';
  NFCScanResult? _lastScanResult;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeNFC();
    _setupScanListener();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeNFC() async {
    try {
      final isAvailable = await _nfcService.isNFCAvailable();
      final hasPermission = await _nfcService.checkNFCPermissions();
      
      setState(() {
        _isNFCAvailable = isAvailable && hasPermission;
        _statusMessage = _isNFCAvailable 
          ? 'Tap to start NFC scanning'
          : 'NFC is not available or permission denied';
      });
    } catch (e) {
      setState(() {
        _isNFCAvailable = false;
        _statusMessage = 'Error initializing NFC: ${e.toString()}';
      });
    }
  }

  void _setupScanListener() {
    _scanSubscription = _nfcService.scanStream.listen(
      (scanResult) {
        setState(() {
          _lastScanResult = scanResult;
          _isScanning = false;
          _statusMessage = scanResult.location != null 
            ? 'Location found: ${scanResult.location!.name}'
            : 'NFC tag scanned but location not found';
        });
        
        _animationController.stop();
        
        if (scanResult.location != null) {
          _showLocationFoundDialog(scanResult.location!);
        } else {
          _showUnknownTagDialog(scanResult.tagId);
        }
      },
      onError: (error) {
        setState(() {
          _isScanning = false;
          _statusMessage = 'Scan error: ${error.toString()}';
        });
        _animationController.stop();
      },
    );
  }

  Future<void> _startScanning() async {
    if (!_isNFCAvailable || _isScanning) return;
    
    setState(() {
      _isScanning = true;
      _statusMessage = 'Hold your device near an NFC tag...';
    });
    
    _animationController.repeat(reverse: true);
    
    final success = await _nfcService.startNFCScan();
    
    if (!success) {
      setState(() {
        _isScanning = false;
        _statusMessage = 'Failed to start NFC scanning';
      });
      _animationController.stop();
    }
    
    // Auto stop scanning after 30 seconds
    Timer(const Duration(seconds: 30), () {
      if (_isScanning) {
        _stopScanning();
      }
    });
  }

  Future<void> _stopScanning() async {
    if (!_isScanning) return;
    
    await _nfcService.stopNFCScan();
    setState(() {
      _isScanning = false;
      _statusMessage = 'Tap to start NFC scanning';
    });
    _animationController.stop();
  }

  void _showLocationFoundDialog(NFCLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.green),
            SizedBox(width: 8),
            Text('Location Found!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Faculty: ${location.facultyName}'),
            Text('Building: ${location.buildingCode}'),
            Text('Room: ${location.roomNumber}'),
            if (location.description.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(location.description),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationDetailsPage(location: location),
                ),
              );
            },
            child: Text('View Details'),
          ),
        ],
      ),
    );
  }

  void _showUnknownTagDialog(String tagId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: Colors.orange),
            SizedBox(width: 8),
            Text('Unknown Tag'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('NFC tag detected but no location information found.'),
            SizedBox(height: 8),
            Text('Tag ID: $tagId', style: TextStyle(fontFamily: 'monospace')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 184, 245, 205),
      appBar: AppBar(
        title: Text('NFC Campus Navigator'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // NFC Icon with Animation
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isScanning ? _pulseAnimation.value : 1.0,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: _isNFCAvailable 
                                ? (_isScanning ? Colors.green : Colors.green[300])
                                : Colors.grey,
                              borderRadius: BorderRadius.circular(75),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.nfc,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Status Message
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // Scan Button
                    if (_isNFCAvailable) ...[
                      ElevatedButton(
                        onPressed: _isScanning ? _stopScanning : _startScanning,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isScanning ? Colors.red : Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          _isScanning ? 'Stop Scanning' : 'Start Scanning',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange, size: 30),
                            SizedBox(height: 8),
                            Text(
                              'NFC not available',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Please check if NFC is enabled in your device settings.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Instructions
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use NFC Scanner:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildInstructionRow('1. Tap "Start Scanning"'),
                    _buildInstructionRow('2. Hold your device near NFC tag'),
                    _buildInstructionRow('3. Get instant location information'),
                    _buildInstructionRow('4. Navigate to your destination'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scanSubscription?.cancel();
    _nfcService.stopNFCScan();
    super.dispose();
  }
}