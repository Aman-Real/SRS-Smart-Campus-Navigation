# 🚀 Quick Start Guide

## 5-Minute Setup

### 1. Install Dependencies

```bash
# Navigate to project
cd campusnavigation

# Get Flutter packages
flutter pub get
```

### 2. Setup Firebase (Required)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project named "Campus Navigation"
3. For Android:
   - Add Android app with package: `com.example.campusnavigation`
   - Download `google-services.json`
   - Place in: `android/app/google-services.json`
4. For iOS:
   - Add iOS app with bundle: `com.example.campusnavigation`
   - Download `GoogleService-Info.plist`
   - Add to Xcode in Runner folder
5. Create Firestore Database (test mode for development)
6. Enable Email/Password Authentication

Detailed guide: See [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

### 3. Configure Maps (Leaflet.js)

Maps are already configured! Located at: `assets/html/map.html`
- Uses **Leaflet.js** for rendering
- Uses **OpenStreetMap** for tiles (free, no API key needed)
- Default location: 30.400586, 78.078447

**To change campus location:**
Edit `lib/utils/constants.dart`:
```dart
const double defaultCampusLat = 30.400586;   // Your latitude
const double defaultCampusLng = 78.078447;   // Your longitude
```

### 4. Run the App

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d iphone

# For Web (experimental)
flutter run -d chrome
```

### 5. Initialize Sample Data (Optional)

To populate with 15 sample locations:

```dart
// In main.dart, add to main():
import 'package:campusnavigation/utils/sample_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase first
  await Firebase.initializeApp();
  
  // Then initialize sample data
  await SampleData.initializeData();
  
  runApp(const CampusNavigationApp());
}
```

## App Features at a Glance

### 👤 User Features
- 🔍 Search locations by name or description
- 🏷️ Filter by category (Academic, Labs, Facilities, etc.)
- 🗺️ Interactive map with Leaflet.js
- 🧭 Get directions to any location
- ❤️ Save favorite locations
- 📱 Responsive mobile-first design
- 🌙 Dark mode support

### 🔐 Admin Features
- ➕ Add new campus locations
- ✏️ Edit existing locations
- 🗑️ Delete locations
- 📊 View statistics (total POIs, by category)
- 🖼️ Upload location images
- 🎯 Manage POI details (hours, contact, amenities)

## Navigation

```
Home Screen
├── Search Bar (with auto-suggestions)
├── Category Filters
├── POI List
│   └── Click → POI Details Screen
├── Map Button → Map Screen
│   └── See all locations on interactive map
└── Favorites Button → Favorites Screen
```

## File Structure Overview

```
campusnavigation/
├── lib/
│   ├── main.dart                 ← App entry point
│   ├── models/                   ← Data models
│   ├── services/                 ← Firebase, Location, Search
│   ├── screens/                  ← App pages
│   ├── widgets/                  ← Reusable UI components
│   └── utils/                    ← Constants, themes, sample data
├── assets/
│   └── html/
│       └── map.html              ← Leaflet.js map configuration
├── android/                      ← Android app configuration
├── ios/                          ← iOS app configuration
└── pubspec.yaml                  ← Dependencies
```

## Common Tasks

### Add a New Location

Option 1: **Via Flutter Code**
```dart
final poi = PointOfInterest(
  id: 'poi_new_001',
  name: 'New Building',
  description: 'Description here',
  category: 'Academic',
  latitude: 30.400586,
  longitude: 78.078447,
  // ... other fields
);
await FirebaseService().addPOI(poi);
```

Option 2: **Via Firebase Console**
- Go to Firestore Database
- Click "points_of_interest" collection
- Click "Add document"
- Enter location details

### Change the Theme Color

Edit `lib/utils/themes.dart`:
```dart
static const Color primaryColor = Color(0xFF2D6A7B);  // Change this
```

### Add a New Category

Edit `lib/models/category.dart`:
```dart
Category(
  name: 'New Category',
  icon: '🎯',
  color: '#FF6B6B',
),
```

### Customize Map Styling

Edit `assets/html/map.html` → `map.js` section to:
- Change map zoom
- Add custom overlays
- Modify marker styles
- Change tile provider

## Debugging

### Check Logs
```bash
flutter logs
```

### Firebase Debugging
```dart
// In Firebase Console, check:
- Authentication → Users
- Firestore → Data
- Cloud Functions → Logs
```

### Map Not Showing?
1. Check internet connectivity
2. Verify `assets/html/map.html` exists
3. Check WebView permissions in app settings
4. Try: `flutter clean && flutter pub get && flutter run`

## Deployment Checklist

- [ ] Firebase project created and configured
- [ ] Firestore rules updated for security
- [ ] All campus locations added
- [ ] Images uploaded for locations
- [ ] Admin accounts created
- [ ] App tested on Android and iOS
- [ ] Dark mode tested
- [ ] Map functionality tested
- [ ] Search and filtering tested
- [ ] Favorites system tested
- [ ] Build signed APK/IPA for production

## Important Notes

⚠️ **Security**: 
- Never commit `google-services.json` or `GoogleService-Info.plist`
- Add to `.gitignore` before pushing
- Use proper Firestore security rules (test mode is for development only)

💡 **Best Practices**:
- Test on actual devices, not just emulator
- Use proper error handling for Firebase operations
- Implement proper authentication for admin features
- Cache images when possible for better performance

🚀 **Performance Tips**:
- Use pagination for large location lists
- Cache network images
- Minimize map re-renders
- Use lazy loading for POI cards

## Next Steps

1. **Setup Firebase** - Follow FIREBASE_SETUP.md
2. **Add Locations** - Upload campus POI data
3. **Customize** - Update colors, app name, campus location
4. **Test** - Run on Android, iOS, and Web
5. **Deploy** - Build and release to app stores

## Support

- 📖 See [APP_GUIDE.md](APP_GUIDE.md) for detailed documentation
- 🔥 See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for Firebase setup
- 🐛 Check Flutter logs: `flutter logs`
- 📱 Test on actual device for best results

---

**Happy developing! 🎉**

Need help? Check the documentation files or review sample code in the project.
