import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';
import '../services/search_service.dart';
import '../models/poi.dart';
import '../utils/constants.dart';
import '../widgets/search_bar.dart';
import '../widgets/poi_card.dart';
import '../widgets/filter_chips.dart';
import 'map_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseService _firebaseService;
  late SearchService _searchService;

  List<PointOfInterest> _allPOIs = [];
  List<PointOfInterest> _filteredPOIs = [];
  List<String> _categories = [];
  List<String> _selectedCategories = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _searchService = SearchService();
    _loadPOIs();
  }

  void _loadPOIs() {
    _firebaseService.getAllPOIs().listen((pois) {
      setState(() {
        _allPOIs = pois;
        _categories = _searchService.getUniqueCategoriesFromPOIs(pois);
        _filterPOIs();
      });
    });
  }

  void _filterPOIs() {
    List<PointOfInterest> filtered = _allPOIs;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = _searchService.searchPOIs(filtered, _searchQuery);
    }

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      filtered = _searchService.filterByCategories(
        filtered,
        _selectedCategories,
      );
    }

    setState(() {
      _filteredPOIs = _searchService.sortByName(filtered);
    });
  }

  Future<void> _addToFavorites(String poiId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> favoriteIds = prefs.getStringList('favorite_poi_ids') ?? [];

      if (!favoriteIds.contains(poiId)) {
        favoriteIds.add(poiId);
        await prefs.setStringList('favorite_poi_ids', favoriteIds);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Added to favorites')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Already in favorites')));
      }
    } catch (e) {
      print('Error adding to favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding to favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Navigation'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(pois: _allPOIs),
                ),
              );
            },
            tooltip: 'Map View',
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            tooltip: 'Favorites',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  SearchBarWidget(
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                      _filterPOIs();
                    },
                    onSubmitted: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                      _filterPOIs();
                    },
                    suggestions: _searchService
                        .getAutoSuggestions(_allPOIs, _searchQuery)
                        .map((poi) => poi.name)
                        .toList(),
                    onClear: () {
                      setState(() {
                        _searchQuery = '';
                      });
                      _filterPOIs();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  if (_categories.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter by Category',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        FilterChips(
                          categories: _categories,
                          selectedCategories: _selectedCategories,
                          onSelectionChanged: (selected) {
                            setState(() {
                              _selectedCategories = selected;
                            });
                            _filterPOIs();
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  // Results Info
                  Text(
                    'Found ${_filteredPOIs.length} locations',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          // POI List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final poi = _filteredPOIs[index];
                return POICard(
                  poi: poi,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => POIDetailsScreen(poi: poi),
                      ),
                    );
                  },
                  onFavoriteTap: () => _addToFavorites(poi.id),
                  isFavorite: false,
                );
              }, childCount: _filteredPOIs.length),
            ),
          ),

          // Empty State
          if (_filteredPOIs.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No locations found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search or filters',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // Bottom padding
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ),
        ],
      ),
    );
  }
}

class POIDetailsScreen extends StatelessWidget {
  final PointOfInterest poi;

  const POIDetailsScreen({Key? key, required this.poi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(poi.name), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (poi.imageUrl != null && poi.imageUrl!.isNotEmpty)
              Image.network(
                poi.imageUrl!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: const Icon(Icons.location_on, size: 100),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              poi.name,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                poi.category,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () {
                          // TODO: Add to favorites
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text('About', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    poi.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 24),

                  // Details
                  if (poi.buildingName != null || poi.floorNumber != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        if (poi.buildingName != null)
                          _DetailRow(
                            icon: Icons.apartment,
                            label: 'Building',
                            value: poi.buildingName!,
                          ),
                        if (poi.floorNumber != null)
                          _DetailRow(
                            icon: Icons.stairs,
                            label: 'Floor',
                            value: poi.floorNumber!,
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Contact & Hours
                  if (poi.contactDetails != null || poi.openingHours != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        if (poi.contactDetails != null)
                          _DetailRow(
                            icon: Icons.phone,
                            label: 'Contact',
                            value: poi.contactDetails!,
                          ),
                        if (poi.openingHours != null)
                          _DetailRow(
                            icon: Icons.schedule,
                            label: 'Hours',
                            value: poi.openingHours!,
                          ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Amenities
                  if (poi.amenities != null && poi.amenities!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amenities',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: poi.amenities!
                              .map((amenity) => Chip(label: Text(amenity)))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.directions),
                          label: const Text('Navigate'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapScreen(pois: [], selectedPOI: poi),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                          onPressed: () {
                            // TODO: Implement share
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
