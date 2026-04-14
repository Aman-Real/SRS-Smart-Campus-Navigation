# Development Architecture & Implementation Guide

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App Layer                     │
├──────────────────────┬──────────────────┬────────────────┤
│   Presentation       │   Business Logic │   Data Layer   │
├──────────────────────┼──────────────────┼────────────────┤
│ • Screens            │ • Services       │ • Models       │
│ • Widgets            │ • Providers      │ • Firebase     │
│ • Routes             │ • State Mgmt     │ • Local Storage│
│ • Themes             │                  │                │
└──────────────────────┴──────────────────┴────────────────┘
         │                      │                  │
         ▼                      ▼                  ▼
┌────────────────────────────────────────────────────────┐
│         Webview Layer (Leaflet.js Map)                  │
├────────────────────────────────────────────────────────┤
│ • HTML/JS map rendering                                │
│ • Marker management                                    │
│ • Route calculation (OSRM)                             │
│ • User location tracking                               │
└────────────────────────────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────────────────────┐
│         Backend Services (Firebase)                     │
├────────────────────────────────────────────────────────┤
│ • Firestore (Database)                                 │
│ • Firebase Auth (Authentication)                       │
│ • Firebase Storage (Images)                            │
│ • Firebase Hosting (Optional)                          │
└────────────────────────────────────────────────────────┘
```

## Core Components

### 1. Models (`lib/models/`)

**PointOfInterest (POI)**
- Represents a physical location on campus
- Fields: id, name, description, category, coordinates
- Firestore mapping: Direct to/from Map conversion

**User**
- Represents app users
- Fields: id, email, displayName, role (user/editor/admin)
- Role-based access control

**Category**
- Predefined location categories
- Includes icon, color, display name
- Static list of ~10 categories

### 2. Services (`lib/services/`)

**FirebaseService**
- Singleton pattern for single instance
- POI CRUD operations
- User management
- Query and search functionality
- Batch operations for bulk uploads

**LocationService**
- Wrapper around geolocator package
- Get current location
- Stream location updates
- Calculate distance between points
- Handle location permissions

**SearchService**
- Fuzzy string matching for search
- Category-based filtering
- Sorting (by name, distance, date)
- Auto-suggestions from POI list
- No external API calls (all client-side)

### 3. Screens (`lib/screens/`)

**HomeScreen**
- Main entry point
- Displays POI list with search/filter
- Tab-based navigation structure
- Real-time updates via Firebase streams

**MapScreen**
- WebViewController integration
- Leaflet.js map rendering
- Marker clustering
- Route calculation
- Bottom info panel for selected POI

**POIDetailsScreen**
- Full information display
- Image carousel
- Contact information
- Amenities list
- Action buttons (Navigate, Share, Favorite)

**AdminPanel**
- CRUD operations for POIs
- Statistics dashboard
- Image upload management
- User role management

**SearchScreen**
- Advanced search interface
- Category filters
- Sorting options
- Search history

**FavoritesScreen**
- Display saved locations
- Quick access to frequent locations
- Persistent storage (Firebase)

### 4. Widgets (`lib/widgets/`)

**SearchBarWidget**
- Text input with suggestions
- Clear button
- Focus management
- Auto-complete functionality

**POICard**
- Compact location display
- Image with fallback
- Category badge
- Favorite toggle
- Tap action handling

**FilterChips**
- Multi-select category filter
- Visual feedback
- Easy clearing of filters

### 5. Leaflet.js Map Integration

**Key Features:**
- OpenStreetMap tile layer (no API key needed)
- Custom marker icons with colors
- Popup info windows with POI details
- Routing Machine for directions
- Geolocation for user position
- Pan & zoom controls

**Communication Flow:**
```
Flutter ──── JavaScript ──── Browser
  ↓           ├─ Marker Add
  │           ├─ Route Calc
  │           └─ Location Upd
  ↓           Leaflet.js
 
WebView ←─── Message Handler ←─── Map
```

## Data Flow Diagram

```
User Action
    ↓
Screen/Widget
    ↓
Service Layer (Firebase/Location/Search)
    ↓
Data Model (POI/User/Category)
    ↓
UI Update (Provider/setState)
    ↓
Visual Feedback
```

## Authentication Flow

```
User Input
    ↓
Firebase Auth
    ├─ Email/Password
    ├─ Token Generation
    └─ User Session
    ↓
User Document Creation (Firestore)
    ├─ Profile Data
    ├─ Role Assignment
    └─ Preferences
    ↓
Role-Based Access Control
    ├─ User: Read-only
    ├─ Editor: Create/Update
    └─ Admin: Full CRUD
```

## Performance Optimizations

### Image Caching
- Uses `cached_network_image` package
- Reduces network calls
- Faster UI rendering

### Database Queries
- Indexed searches on Firestore
- Pagination for large lists
- Cloud functions for complex queries

### Map Optimization
- Lazy load markers
- Cluster markers on zoom out
- Debounce pan/zoom handlers

### State Management
- Provider for efficient rebuilds
- Only redraw changed widgets
- Minimize setState calls

## Security Considerations

### Firestore Rules
```
- Public read access for POIs
- Authenticated write access
- Role-based admin operations
- User document privacy
```

### API Keys
- No API keys in client code
- Server-side validation for sensitive ops
- Token-based authentication

### Data Privacy
- User data encrypted in transit
- No sensitive data in logs
- Secure token storage

## Scaling Strategy

### Database
- Partition by category
- Index frequently queried fields
- Archive old data
- Use Cloud Functions for heavy ops

### Backend
- Cloud Functions for business logic
- CDN for static assets
- Caching layer for popular queries
- Load balancing for APIs

### Frontend
- Code splitting
- Lazy loading of modules
- Image optimization
- Service workers for offline

## Testing Strategy

### Unit Tests
- Test services independently
- Mock Firebase operations
- Test data models

### Widget Tests
- Test UI components
- Test user interactions
- Test navigation

### Integration Tests
- Full app flow testing
- Firebase integration
- Map functionality

## Deployment Pipeline

```
Development Branch
    ↓ (Test & Review)
Staging Branch
    ↓ (Build & Test)
Production Branch
    ↓ (Build APK/IPA)
App Stores
    ├─ Google Play Store
    ├─ Apple App Store
    └─ Firebase Hosting
```

## Common Issues & Solutions

### Map Not Loading
- **Cause**: Asset not found, WebView permission
- **Solution**: Verify assets in pubspec.yaml, check manifest

### Firebase Connection Failed
- **Cause**: google-services.json missing/incorrect
- **Solution**: Re-download from Firebase console

### Slow Search
- **Cause**: Large unindexed queries
- **Solution**: Add Firestore indexes, implement pagination

### Memory Leak in WebView
- **Cause**: Not disposing WebViewController
- **Solution**: Implement proper lifecycle management

## Future Enhancements

1. **Advanced Features**
   - Voice search
   - AR campus navigation
   - QR code scanning
   - Push notifications

2. **Performance**
   - Service workers for offline
   - Advanced caching strategies
   - Real-time collaboration

3. **Analytics**
   - User behavior tracking
   - Popular locations analysis
   - Usage patterns

4. **Internationalization**
   - Multi-language support
   - Localization strings
   - RTL support

## Key Dependencies & Versions

See `pubspec.yaml` for:
- Firebase packages (v4+)
- Flutter WebView (v4+)
- Provider state management
- Geolocator for location
- Fuzzy search library

## Code Style Guidelines

- Use meaningful variable names
- Follow Dart naming conventions
- Add documentation comments
- Keep functions small and focused
- Use constants for magic values
- Error handling with try-catch

## Monitoring & Logging

- Firebase Crashlytics for errors
- Cloud Logging for events
- Local device logging with debug prints
- Analytics events for tracking

---

This architecture provides:
✅ Scalability - Easy to add features
✅ Maintainability - Clear separation of concerns
✅ Testability - Mockable services
✅ Performance - Optimized queries and caching
✅ Security - Role-based access control
