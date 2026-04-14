import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';
import '../models/poi.dart';
import '../models/user.dart';
import '../firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  // ===== POI Operations =====

  /// Get all POIs
  Stream<List<PointOfInterest>> getAllPOIs() {
    return _firestore.collection('points_of_interest').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => PointOfInterest.fromFirestore(doc))
          .toList();
    });
  }

  /// Get POIs by category
  Stream<List<PointOfInterest>> getPOIsByCategory(String category) {
    return _firestore
        .collection('points_of_interest')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PointOfInterest.fromFirestore(doc))
              .toList();
        });
  }

  /// Get single POI by ID
  Future<PointOfInterest?> getPOIById(String id) async {
    try {
      final doc = await _firestore
          .collection('points_of_interest')
          .doc(id)
          .get();
      if (doc.exists) {
        return PointOfInterest.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching POI: $e');
      return null;
    }
  }

  /// Add new POI (Admin only)
  Future<String?> addPOI(PointOfInterest poi) async {
    try {
      final docRef = _firestore.collection('points_of_interest').doc();
      await docRef.set(poi.copyWith(id: docRef.id).toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding POI: $e');
      return null;
    }
  }

  /// Update POI (Admin only)
  Future<bool> updatePOI(PointOfInterest poi) async {
    try {
      await _firestore
          .collection('points_of_interest')
          .doc(poi.id)
          .update(poi.toMap());
      return true;
    } catch (e) {
      print('Error updating POI: $e');
      return false;
    }
  }

  /// Delete POI (Admin only)
  Future<bool> deletePOI(String id) async {
    try {
      await _firestore.collection('points_of_interest').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting POI: $e');
      return false;
    }
  }

  /// Search POIs by name
  Future<List<PointOfInterest>> searchPOIs(String query) async {
    try {
      final snapshot = await _firestore.collection('points_of_interest').get();
      final allPOIs = snapshot.docs
          .map((doc) => PointOfInterest.fromFirestore(doc))
          .toList();

      final queryLower = query.toLowerCase();
      return allPOIs
          .where(
            (poi) =>
                poi.name.toLowerCase().contains(queryLower) ||
                poi.description.toLowerCase().contains(queryLower) ||
                poi.category.toLowerCase().contains(queryLower),
          )
          .toList();
    } catch (e) {
      print('Error searching POIs: $e');
      return [];
    }
  }

  // ===== User Operations =====

  /// Get current user
  fb_auth.User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign up
  Future<bool> signUp(String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(displayName);

      // Create user document
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'id': credential.user!.uid,
        'email': email,
        'displayName': displayName,
        'role': 'user',
        'favorites': [],
        'createdAt': DateTime.now(),
      });

      return true;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  /// Sign in
  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  /// Sign out
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('Sign out error: $e');
      return false;
    }
  }

  /// Get user by ID
  Future<User?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  /// Add to favorites
  Future<bool> addToFavorites(String userId, String poiId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([poiId]),
      });
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  /// Remove from favorites
  Future<bool> removeFromFavorites(String userId, String poiId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([poiId]),
      });
      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  /// Get user favorites
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return List<String>.from(doc['favorites'] ?? []);
      }
      return [];
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  /// Check if POI is favorite
  Future<bool> isFavorite(String userId, String poiId) async {
    try {
      final favorites = await getUserFavorites(userId);
      return favorites.contains(poiId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // ===== Admin Operations =====

  /// Check if user is admin
  Future<bool> isAdmin(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.isAdmin ?? false;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  /// Batch upload POIs
  Future<bool> batchUploadPOIs(List<PointOfInterest> pois) async {
    try {
      final batch = _firestore.batch();
      for (var poi in pois) {
        final docRef = _firestore.collection('points_of_interest').doc();
        batch.set(docRef, poi.copyWith(id: docRef.id).toMap());
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error batch uploading POIs: $e');
      return false;
    }
  }
}
