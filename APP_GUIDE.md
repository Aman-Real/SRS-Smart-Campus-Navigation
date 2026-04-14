# 🎓 Campus Navigation App - Smart Campus Explorer

A cross-platform mobile and web application built with **Flutter** and **Leaflet.js** that helps students, visitors, and staff easily navigate campus locations and discover amenities.

## ✨ Features

### Core Features
- 🔍 **Smart Search & Filtering** - Search by department, lab, or amenity name with fuzzy matching
- 🗺️ **Interactive Map Interface** - Powered by Leaflet.js with custom markers and real-time location tracking
- 📍 **Points of Interest (POI) Management** - Detailed information for each location including:
  - Description and operating hours
  - Contact details and amenities
  - Category-based organization
  - Building location and floor information
- 🧭 **Navigation & Routing** - Get directions between your location and any POI
- ❤️ **Favorites System** - Save favorite locations for quick access
- 📊 **Admin Dashboard** - Manage campus locations with full CRUD operations

### Additional Features
- 🌙 **Dark Mode Support** - Beautiful light and dark themes
- 📱 **Mobile-First Design** - Responsive UI optimized for all devices
- 🔐 **Firebase Integration** - Cloud-based data storage and authentication
- 🎨 **Material Design** - Clean, intuitive user interface

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform mobile & web framework
- **Material Design 3** - Modern UI components
- **Provider** - State management
- **WebView** - Embedded Leaflet.js maps

### Backend
- **Firebase**
  - Firestore - Real-time database
  - Firebase Authentication - User management
  - Firebase Storage - Image storage

### Maps
- **Leaflet.js** - Open-source mapping library
- **OpenStreetMap** - Free map tiles
- **OSRM** - Open Source Routing Machine

## 📋 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── poi.dart             # Point of Interest model
│   ├── user.dart            # User model
│   └── category.dart        # Category definitions
├── services/
│   ├── firebase_service.dart    # Firebase operations
│   ├── location_service.dart    # Geolocation services
│   └── search_service.dart      # Search & filtering
├── screens/
│   ├── home_screen.dart         # Main home screen
│   ├── map_screen.dart          # Map view
│   ├── search_screen.dart       # Search view
│   ├── favorites_screen.dart    # Favorites management
│   └── admin_panel.dart         # Admin dashboard
├── widgets/
│   ├── search_bar.dart          # Search input widget
│   ├── poi_card.dart            # Location card
│   ├── filter_chips.dart        # Category filters
│   └── map_widget.dart          # Map container
└── utils/
    ├── constants.dart           # App constants
    └── themes.dart              # Theme definitions

assets/
└── html/
    └── map.html                 # Leaflet.js map configuration
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.11.4 or higher)
- Dart SDK
- Firebase Project
- Android SDK / iOS SDK

### Installation

1. **Clone the repository**
   ```bash
   cd campusnavigation
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at https://firebase.google.com
   - Download `google-services.json` (Android) and place in `android/app/`
   - Download `GoogleService-Info.plist` (iOS) and add to Xcode
   - Enable Firestore Database and Authentication

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

Key packages used:
- `firebase_core: ^2.24.2` - Firebase integration
- `cloud_firestore: ^4.14.0` - Realtime database
- `firebase_auth: ^4.15.2` - Authentication
- `webview_flutter: ^4.2.4` - WebView for Leaflet.js
- `geolocator: ^10.0.0` - Location services
- `provider: ^6.0.0` - State management
- `cached_network_image: ^3.3.0` - Image caching
- `fuzzywuzzy: ^1.1.1` - Fuzzy search matching

## 🎯 Usage

### For End Users
1. **Search** - Use the search bar to find locations
2. **Filter** - Apply category filters to narrow down results
3. **View Map** - Click map icon to see location on interactive map
4. **Navigate** - Select a location and tap "Navigate" to get directions
5. **Save Favorites** - Add frequently visited locations to favorites

### For Admins
1. **Login** - Access admin panel with admin credentials
2. **Manage POIs** - Add, edit, or delete campus locations
3. **Upload Images** - Add photos for each location
4. **View Statistics** - Monitor total locations and category distribution

## 🗺️ Map Configuration

The Leaflet.js map is configured in `assets/html/map.html` with:
- **Base Layer** - OpenStreetMap tiles
- **Default Location** - 30.400586, 78.078447
- **Zoom Level** - 16 (adjustable)
- **Custom Markers** - Colored circles with category icons
- **Routing** - OSRM-powered directions

### Customizing Campus Location
Edit `lib/utils/constants.dart`:
```dart
const double defaultCampusLat = 30.400586;  // Your latitude
const double defaultCampusLng = 78.078447;  // Your longitude
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✈️ macOS (coming soon)
- ✈️ Windows (coming soon)

## 🔐 Firebase Security Rules

Example Firestore rules:
```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Public read access for POIs
    match /points_of_interest/{document=**} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'editor'];
    }
    
    // User data
    match /users/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }
  }
}
```

## 🎨 Customization

### Colors
Edit `lib/utils/themes.dart` to customize the color scheme:
- Primary: `#2D6A7B`
- Secondary: `#FF6B6B`
- Accent: `#FFA500`

### Categories
Modify categories in `lib/models/category.dart`:
```dart
static final List<Category> defaultCategories = [
  Category(name: 'Academic', icon: '📚', color: '#3366CC'),
  // Add more categories...
];
```

## 🐛 Troubleshooting

### Map Not Loading
- Ensure `assets/html/map.html` exists
- Check WebView permissions in Android/iOS settings
- Verify internet connectivity

### Firebase Connection Issues
- Verify `google-services.json` is correctly placed
- Check Firebase project ID in configuration
- Ensure database rules are properly configured

### Location Permission Denied
- Check app permissions in device settings
- Request permission again when launching app

## 📚 Sample Data

To populate the database with sample data, run:
```dart
// Create sample POIs in Firebase
final firebaseService = FirebaseService();
final sampledPOIs = [
  PointOfInterest(
    id: '1',
    name: 'Computer Science Building',
    description: 'Home to the Computer Science Department',
    category: 'Academic',
    latitude: 30.400586,
    longitude: 78.078447,
    // ... more details
  ),
  // Add more POIs
];
await firebaseService.batchUploadPOIs(sampledPOIs);
```

## 👥 Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the MIT License.

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact the development team

## 🙏 Acknowledgments

- Leaflet.js community for the excellent mapping library
- Firebase for backend infrastructure
- Flutter and Dart teams for the framework
- OpenStreetMap contributors for map data

---

**Happy Navigating! 🚀**
