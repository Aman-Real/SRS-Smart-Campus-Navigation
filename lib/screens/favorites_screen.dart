import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poi.dart';
import '../widgets/poi_card.dart';
import '../services/firebase_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FirebaseService _firebaseService;
  List<PointOfInterest> _favoritePOIs = [];
  List<String> _favoriteIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      setState(() => _isLoading = true);

      // For now, use local storage since authentication isn't implemented
      final prefs = await SharedPreferences.getInstance();
      _favoriteIds = prefs.getStringList('favorite_poi_ids') ?? [];

      if (_favoriteIds.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      // Load POI details from Firebase
      _favoritePOIs = [];
      for (String id in _favoriteIds) {
        final poi = await _firebaseService.getPOIById(id);
        if (poi != null) {
          _favoritePOIs.add(poi);
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFromFavorites(String poiId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteIds.remove(poiId);
      await prefs.setStringList('favorite_poi_ids', _favoriteIds);

      setState(() {
        _favoritePOIs.removeWhere((poi) => poi.id == poiId);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from favorites')));
    } catch (e) {
      print('Error removing from favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing from favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites'), elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoritePOIs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add locations to your favorites for quick access',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _favoritePOIs.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final poi = _favoritePOIs[index];
                return POICard(
                  poi: poi,
                  onTap: () {
                    // TODO: Show POI details screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Details for ${poi.name}')),
                    );
                  },
                  onFavoriteTap: () => _removeFromFavorites(poi.id),
                  isFavorite: true,
                );
              },
            ),
    );
  }
}
