# NSBM University Campus Navigation Map

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![NFC](https://img.shields.io/badge/NFC-Integrated-green.svg)](https://developer.android.com/guide/topics/connectivity/nfc)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)](https://flutter.dev/docs/deployment)

A comprehensive Flutter-based mobile application for NSBM Green University that provides advanced campus navigation with cutting-edge NFC (Near Field Communication) integration. Students can scan NFC tags throughout the campus for instant location identification, detailed facility information, and turn-by-turn navigation assistance.

## 🌟 Features

### 🏛️ Core Campus Features
- **Interactive Campus Maps** - Detailed floor plans and building layouts
- **Lecture Schedule Management** - Personal timetable and class notifications  
- **News & Announcements** - Latest university updates and events
- **Campus Information** - Comprehensive facility and service details
- **User Authentication** - Secure Firebase-based login system

### 🔲 Advanced NFC Integration
- **Smart Tag Scanning** - Instant location identification via NFC tags
- **Real-Time Navigation** - Turn-by-turn directions with live distance tracking
- **Facility Information** - Detailed amenities, services, and operating hours
- **Scan History** - Personal navigation history and frequently visited locations
- **Multi-Building Support** - Coverage across all university faculties and facilities

### 🗺️ Navigation System
- **Google Maps Integration** - Satellite and hybrid map views
- **GPS Navigation** - Real-time positioning and route optimization
- **Indoor Wayfinding** - Floor-by-floor navigation assistance
- **Distance Calculation** - Accurate distance and estimated travel time
- **Accessibility Support** - Wheelchair-accessible route planning

## 🏗️ Architecture Overview

```
NSBM University Map App
├── 🎯 Frontend (Flutter)
│   ├── User Interface & Navigation
│   ├── NFC Tag Processing
│   ├── Map Integration
│   └── Real-time Updates
├── 🔥 Backend (Firebase)
│   ├── User Authentication
│   ├── Firestore Database
│   ├── Real-time Sync
│   └── Cloud Functions
├── 🔲 NFC System
│   ├── Tag Detection & Reading
│   ├── Location Database Lookup
│   ├── Navigation Processing
│   └── History Tracking
└── 🗺️ Mapping Services
    ├── Google Maps Platform
    ├── GPS & Location Services
    ├── Route Calculation
    └── Offline Caching
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.9.2 or later
- Android Studio or VS Code with Flutter extensions
- Firebase project with Authentication and Firestore enabled
- Android device with NFC capability (for full testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-organization/nsbm-university-map.git
   cd nsbm-university-map
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in `lib/firebase_options.dart`

4. **Setup Firestore Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Allow authenticated users to access NFC data
       match /nfc_locations/{locationId} {
         allow read, write: if request.auth != null;
       }
       match /nfc_scan_history/{scanId} {
         allow read, write: if request.auth != null;
       }
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Usage Guide

### Initial Setup
1. **Launch the app** and complete user registration/login
2. **Initialize NFC database** by tapping the blue NFC button on homepage
3. **Grant permissions** for location services and NFC access
4. **Explore features** through the main navigation grid

### NFC Campus Navigation
1. **Open NFC Scanner** from the main menu
2. **Tap "Start Scanning"** to activate NFC reader
3. **Hold phone near NFC tag** (2-4cm distance)
4. **View location details** and navigation options
5. **Navigate to destination** using turn-by-turn directions

### Campus Map Navigation
1. **Access Campus Map** from homepage
2. **Select faculty** or tap "FULL VIEW" for complete campus
3. **Use map controls** for zoom, pan, and layer switching
4. **Tap locations** for detailed information and directions

## 🏛️ Campus Coverage

### Pre-configured Locations (10 Campus Facilities)

| Faculty/Department | Location | Features |
|-------------------|----------|----------|
| **Faculty of Computing** | Computer Lab 1, Network Security Lab | 75+ workstations, development tools |
| **Faculty of Engineering** | Electronics Lab | Advanced testing equipment |
| **Faculty of Business** | Business Simulation Lab | SAP, Oracle, Bloomberg Terminal |
| **Library Services** | Main Library | 50,000+ books, digital databases |
| **Administration** | Student Services | Registration, counseling, financial aid |
| **Student Life** | Cafeteria, Sports Complex | Dining, gymnasium, fitness center |
| **Health Services** | Medical Center | Healthcare, emergency services |
| **Events** | Main Auditorium | 500-seat venue, A/V systems |

### Location Data Structure
Each NFC location includes:
- **Basic Information**: Name, building code, room number
- **GPS Coordinates**: Precise latitude/longitude positioning
- **Detailed Amenities**: Equipment, services, operating hours
- **Accessibility**: Wheelchair access, special accommodations
- **Contact Information**: Phone numbers, email contacts

## 🔲 NFC Technology Integration

### Supported NFC Tags
- **NTAG213** (180 bytes) - Basic location identification
- **NTAG215** (924 bytes) - Extended location data
- **NTAG216** (8K bytes) - Maximum capacity for detailed information

### NFC Tag Programming
```bash
# Example tag data structure
Tag ID: fc_101
Location: Faculty of Computing - Room 101
Coordinates: 6.8211, 80.0409
Amenities: 50 workstations, high-speed internet, projector
Level: Ground Floor
```

### Implementation Benefits
- **Instant Access**: Sub-second location identification
- **Offline Capability**: Works without internet connection
- **Universal Compatibility**: Standard NFC technology
- **Cost Effective**: Inexpensive tag deployment
- **Maintenance Free**: No battery or power requirements

## 🛠️ Development Guide

### Project Structure
```
lib/
├── main.dart                          # Application entry point
├── homebase.dart                      # Bottom navigation controller
├── firebase_options.dart              # Firebase configuration
├── models/
│   ├── nfc_location.dart             # Location data model
│   └── nfc_scan_result.dart          # Scan tracking model
├── services/
│   └── nfc_service.dart              # Core NFC functionality
├── pages/
│   ├── mainPages/
│   │   ├── homepage.dart             # Main dashboard
│   │   ├── profilepage.dart          # User profile management
│   │   └── notificataionpage.dart    # Notifications center
│   ├── SecondaryPages/
│   │   ├── nfc_scanner_page.dart     # NFC scanning interface
│   │   ├── location_details_page.dart # Location information
│   │   ├── campus_navigation_page.dart # Navigation assistance
│   │   ├── fullmap.dart              # Google Maps integration
│   │   └── campusmap.dart            # Campus map selector
│   └── Components/
│       └── gridcon.dart              # Reusable grid component
└── utils/
    ├── nfc_setup.dart                # Database initialization
    └── firestore_seed_data.dart      # Sample data generator
```

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  
  # Firebase & Authentication
  firebase_core: ^4.6.0
  firebase_auth: ^6.3.0
  cloud_firestore: ^6.2.0
  
  # NFC & Permissions
  nfc_manager: ^3.3.0
  permission_handler: ^11.3.1
  
  # Maps & Location
  google_maps_flutter: ^2.6.1
  geolocator: ^10.1.0
  flutter_map: ^8.2.2
  
  # UI & Navigation
  google_nav_bar: ^5.0.6
  photo_view: ^0.15.0
  
  # Utilities
  intl: ^0.20.2
  uuid: ^4.4.0
  http: ^1.2.1
```

### Adding New Locations
```dart
// Example: Adding new NFC location
NFCLocation newLocation = NFCLocation(
  id: 'eng_lab_205',
  name: 'Advanced Robotics Lab',
  facultyName: 'Faculty of Engineering',
  buildingCode: 'ENG',
  roomNumber: '205',
  latitude: 6.8215,
  longitude: 80.0408,
  description: 'State-of-the-art robotics laboratory with industrial robots.',
  amenities: {
    'Robots': '6 industrial robot arms',
    'Workstations': '12 development stations',
    'Software': 'ROS, MATLAB, SolidWorks',
    'Safety': 'Emergency stop systems'
  },
  mapLevel: 'Level2',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Register with NFC service
await NFCService().registerNFCLocation('eng_205_tag_id', newLocation);
```

## 🔧 Configuration & Deployment

### Android Configuration
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<!-- NFC Permissions -->
<uses-permission android:name="android.permission.NFC" />
<uses-feature android:name="android.hardware.nfc" android:required="false" />

<!-- Location Permissions -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<!-- Google Maps API Key -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

### iOS Configuration
Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access for campus navigation.</string>
<key>NFCReaderUsageDescription</key>
<string>This app uses NFC to identify campus locations.</string>
```

### Firebase Setup
1. **Create Firebase Project**
2. **Enable Authentication** (Email/Password, Google Sign-in)
3. **Setup Firestore Database** with security rules
4. **Configure Firebase Functions** (optional, for advanced features)
5. **Add platform configurations** (Android/iOS)

## 📊 Analytics & Monitoring

### Built-in Analytics
- **NFC Scan Tracking**: Popular locations, usage patterns
- **Navigation Metrics**: Most requested routes, travel times  
- **User Engagement**: Feature usage, session duration
- **Error Monitoring**: NFC failures, permission issues

### Performance Monitoring
- **App Performance**: Launch time, navigation speed
- **Network Usage**: Data consumption, offline capability
- **Battery Impact**: NFC scanning efficiency
- **Memory Management**: Resource optimization

## 🔒 Security & Privacy

### Data Protection
- **Encrypted Communication**: All Firebase data transfer encrypted
- **User Privacy**: Minimal personal data collection
- **Local Processing**: Location calculations performed locally when possible
- **Secure Storage**: Sensitive data stored in encrypted format

### NFC Security
- **Tag Validation**: Verify tag authenticity and data integrity
- **Access Control**: User authentication required for sensitive features
- **Audit Trails**: Log all location access and modifications
- **Regular Updates**: Security patches and vulnerability fixes

## 🧪 Testing

### Automated Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run widget tests
flutter test test/widget_test.dart
```

### Manual Testing Scenarios
1. **NFC Functionality**: Test with various tag types and positions
2. **Network Conditions**: Verify offline/online behavior
3. **Permission Handling**: Test location and NFC permission flows
4. **Error Recovery**: Validate error handling and user feedback
5. **Performance**: Test on various device specifications

### Device Compatibility
- **Android**: 5.0+ (API 21+) with NFC hardware
- **iOS**: 11.0+ with iPhone 7 or newer for NFC
- **Hardware**: GPS, NFC, camera, network connectivity
- **Performance**: 2GB RAM minimum, 4GB recommended

## 🎯 Deployment

### Production Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# iOS Build
flutter build ios --release
```

### Distribution
- **Google Play Store**: Android App Bundle deployment
- **Apple App Store**: iOS App Store Connect
- **Enterprise Distribution**: Internal university deployment
- **APK Distribution**: Direct installation for testing

## 🤝 Contributing

### Development Workflow
1. **Fork the repository** and create feature branch
2. **Follow coding standards** and add comprehensive tests
3. **Update documentation** for new features
4. **Submit pull request** with detailed description
5. **Code review** and integration testing

### Coding Standards
- **Dart Style Guide**: Follow official Dart conventions
- **Documentation**: Document all public APIs
- **Testing**: Maintain 80%+ code coverage
- **Performance**: Optimize for mobile constraints
- **Accessibility**: Support screen readers and navigation

## 📞 Support & Maintenance

### Technical Support
- **Documentation**: Comprehensive guides in `/docs` folder
- **Issue Tracking**: GitHub Issues for bug reports
- **Feature Requests**: Community-driven enhancement proposals
- **Developer Forums**: Stack Overflow, Flutter Community

### Maintenance Schedule
- **Security Updates**: Monthly security patch reviews
- **Feature Updates**: Quarterly major feature releases  
- **Bug Fixes**: Weekly patch releases as needed
- **Dependency Updates**: Monthly dependency updates

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏫 About NSBM Green University

NSBM Green University is a leading private university in Sri Lanka, known for its innovative approach to education and technology integration. This campus navigation app represents our commitment to leveraging cutting-edge technology to enhance the student experience.

**Location**: Mahenwaththa, Pitipana, Homagama, Sri Lanka  
**Coordinates**: 6.8211° N, 80.0409° E  
**Website**: [www.nsbm.ac.lk](https://www.nsbm.ac.lk)

---

## 🎉 Project Status

**Current Version**: 1.0.0  
**Status**: Production Ready ✅  
**Last Updated**: December 2024  
**Maintainers**: NSBM University Development Team

### Recent Achievements
- ✅ **Complete NFC Integration** - Advanced location identification system
- ✅ **Google Maps Integration** - Comprehensive campus mapping
- ✅ **Firebase Backend** - Scalable cloud infrastructure  
- ✅ **Mobile Optimization** - Optimized for university deployment
- ✅ **Security Implementation** - Enterprise-grade security measures

### Upcoming Features
- 🔄 **AR Navigation** - Augmented reality wayfinding
- 🔄 **Voice Guidance** - Audio navigation instructions
- 🔄 **Multi-language Support** - Sinhala and Tamil localization
- 🔄 **Offline Maps** - Enhanced offline navigation capability
- 🔄 **Integration APIs** - LMS and timetable system integration

---

**Ready for University-wide deployment! 🚀**

*This application showcases the future of campus navigation technology, combining NFC innovation with intuitive mobile design to create an exceptional user experience for university students, staff, and visitors.*