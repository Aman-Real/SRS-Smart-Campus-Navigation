# Firebase Setup Guide

## 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name: `Campus Navigation`
4. Enable Google Analytics (optional)
5. Click "Create project"

## 2. Configure Firebase for Flutter

### Android Setup

1. **Add Firebase to your app:**
   - In Firebase Console, click "Add app" → Select "Android"
   - Package name: `com.example.campusnavigation`
   - App nickname: `Campus Navigation`
   - Click "Register app"

2. **Download google-services.json:**
   - Download the JSON file
   - Place it in: `android/app/google-services.json`

3. **Update Android build files:**
   - The files are already configured, but verify:
   - `android/build.gradle.kts` includes `id("com.google.gms.google-services")`
   - `android/app/build.gradle.kts` includes the plugin

### iOS Setup

1. **Add Firebase to iOS app:**
   - In Firebase Console, click "Add app" → Select "iOS"
   - Bundle ID: `com.example.campusnavigation`
   - Click "Register app"

2. **Download GoogleService-Info.plist:**
   - Download the plist file
   - Add to Xcode: Right-click `Runner` → "Add Files to Runner"
   - Select `GoogleService-Info.plist`

## 3. Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password" sign-in:
   - Click "Email/Password"
   - Toggle "Enable"
   - Save

4. (Optional) Enable other providers:
   - Google
   - Facebook
   - Apple

## 4. Create Firestore Database

1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select region closest to you
5. Click "Create"

6. **Create Collections:**

   a. Create `points_of_interest` collection:
   - Add document with sample data structure
   
   b. Create `users` collection:
   - Add document structure for user profiles

## 5. Set Firestore Security Rules

Replace default rules with these (production-ready):

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow public read access to POIs
    match /points_of_interest/{document=**} {
      allow read: if true;
      allow create, update, delete: if isAdmin();
    }
    
    // Allow users to read/write their own documents
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow read: if isAdmin();
    }
    
    // Helper function to check admin role
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 6. Upload Sample Data

### Option A: Using Firebase Console

1. Go to Firestore Database
2. Create `points_of_interest` collection
3. Add documents with this structure:

```json
{
  "id": "poi_001",
  "name": "Computer Science Department",
  "description": "Home of computer science and engineering programs",
  "category": "Academic",
  "latitude": 30.400586,
  "longitude": 78.078447,
  "buildingName": "CSE Building",
  "floorNumber": "3",
  "contactDetails": "+91-11-2659-1234",
  "openingHours": "9:00 AM - 5:00 PM",
  "amenities": ["Library", "Labs", "Conference Rooms"],
  "createdAt": "2024-01-15T10:00:00Z",
  "updatedAt": "2024-01-15T10:00:00Z"
}
```

### Option B: Using Flutter (Programmatic)

Add this function to initialize sample data:

```dart
Future<void> initializeSampleData() async {
  final firebaseService = FirebaseService();
  
  final samplePOIs = [
    PointOfInterest(
      id: 'poi_001',
      name: 'Computer Science Department',
      description: 'Home of computer science and engineering programs',
      category: 'Academic',
      latitude: 30.400586,
      longitude: 78.078447,
      buildingName: 'CSE Building',
      floorNumber: '3',
      contactDetails: '+91-11-2659-1234',
      openingHours: '9:00 AM - 5:00 PM',
      amenities: ['Library', 'Labs', 'Conference Rooms'],
    ),
    PointOfInterest(
      id: 'poi_002',
      name: 'AI Laboratory',
      description: 'Advanced AI research and learning facility',
      category: 'Laboratory',
      latitude: 30.400586,
      longitude: 78.078447,
      buildingName: 'Research Wing A',
      floorNumber: '2',
      contactDetails: '+91-11-2659-5678',
      openingHours: '10:00 AM - 6:00 PM',
      amenities: ['GPUs', 'Servers', 'Meeting Rooms'],
    ),
    // Add more POIs...
  ];
  
  await firebaseService.batchUploadPOIs(samplePOIs);
  print('Sample data uploaded successfully');
}
```

## 7. Enable Storage (Optional)

For image uploads:

1. Go to "Storage"
2. Click "Get started"
3. Choose "Start in test mode"
4. Select region
5. Create

## 8. Set Environment Variables (Optional)

Create `.env` file:
```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
```

## 9. Test the Connection

Add this debug code to `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Test Firestore connection
  FirebaseFirestore.instance
      .collection('points_of_interest')
      .snapshots()
      .listen((event) {
    print('Connected to Firestore! Found ${event.docs.length} documents');
  });
  
  runApp(const CampusNavigationApp());
}
```

## 10. Deploy Firestore Indexes (If Needed)

For complex queries, create indexes:

1. In Firebase Console, go to "Firestore Database"
2. Click "Indexes" tab
3. Create composite indexes if needed:
   - Collection: `points_of_interest`
   - Fields: `category` (Ascending), `createdAt` (Descending)

## Troubleshooting

### Authentication Issues
- Verify `google-services.json` path for Android
- Check `GoogleService-Info.plist` added to Xcode for iOS
- Ensure Firebase Authentication is enabled

### Firestore Connection Issues
- Check internet connectivity
- Verify Firestore rules allow your user role
- Check browser console for errors (Web)

### Missing Data
- Ensure Firestore database is created
- Verify security rules allow read access
- Check if sample data was uploaded

## Next Steps

1. Create admin accounts
2. Upload campus map and building layouts
3. Add more POI data
4. Configure custom domain (if deploying)
5. Set up Analytics for tracking usage

## Reference Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Integration](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
