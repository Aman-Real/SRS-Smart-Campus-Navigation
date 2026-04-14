const String appName = 'Campus Navigation';
const String appVersion = '1.0.0';

// Firebase Collections
const String poiCollection = 'points_of_interest';
const String usersCollection = 'users';
const String developersCollection = 'developers';

// Default Campus Location 
const double defaultCampusLat = 30.400586;
const double defaultCampusLng = 78.078447;
const int defaultZoomLevel = 16;

// Search & Filter
const int searchDebounceMs = 500;
const int maxAutoSuggestions = 5;

// Map Constants
const int mapMinZoom = 10;
const int mapMaxZoom = 20;
const String mapTileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
const String mapAttribution =
    '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';

// Animation Durations
const Duration shortAnimationDuration = Duration(milliseconds: 300);
const Duration mediumAnimationDuration = Duration(milliseconds: 500);
const Duration longAnimationDuration = Duration(milliseconds: 800);

// UI Constants
const double defaultPadding = 16.0;
const double defaultBorderRadius = 12.0;
const double cardElevation = 2.0;

// Feature Flags
const bool enableDarkMode = true;
const bool enableVoiceSearch = false;
const bool enableOfflineMode = true;
const bool enableQRScanning = false;
