import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'dart:math';
import '../models/poi.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();

  SearchService._internal();

  factory SearchService() {
    return _instance;
  }

  /// Search POIs with fuzzy matching
  List<PointOfInterest> searchPOIs(
    List<PointOfInterest> pois,
    String query, {
    double scoreThreshold = 70,
  }) {
    if (query.isEmpty) {
      return [];
    }

    final results = <(PointOfInterest, int)>[];

    for (var poi in pois) {
      final nameScore = ratio(query.toLowerCase(), poi.name.toLowerCase());
      final descScore = ratio(
        query.toLowerCase(),
        poi.description.toLowerCase(),
      );
      final categoryScore = ratio(
        query.toLowerCase(),
        poi.category.toLowerCase(),
      );

      final maxScore = [
        nameScore,
        descScore,
        categoryScore,
      ].reduce((a, b) => a > b ? a : b);

      if (maxScore >= scoreThreshold) {
        results.add((poi, maxScore));
      }
    }

    // Sort by score (descending)
    results.sort((a, b) => b.$2.compareTo(a.$2));
    return results.map((r) => r.$1).toList();
  }

  /// Filter POIs by category
  List<PointOfInterest> filterByCategory(
    List<PointOfInterest> pois,
    String category,
  ) {
    return pois
        .where((poi) => poi.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Filter POIs by multiple categories
  List<PointOfInterest> filterByCategories(
    List<PointOfInterest> pois,
    List<String> categories,
  ) {
    if (categories.isEmpty) {
      return pois;
    }

    return pois
        .where(
          (poi) => categories
              .map((cat) => cat.toLowerCase())
              .contains(poi.category.toLowerCase()),
        )
        .toList();
  }

  /// Sort by name
  List<PointOfInterest> sortByName(List<PointOfInterest> pois) {
    final sorted = List<PointOfInterest>.from(pois);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  /// Sort by distance from a given point
  List<PointOfInterest> sortByDistance(
    List<PointOfInterest> pois,
    double userLat,
    double userLng,
  ) {
    final sorted = List<PointOfInterest>.from(pois);
    sorted.sort((a, b) {
      final distA = _calculateDistance(
        userLat,
        userLng,
        a.latitude,
        a.longitude,
      );
      final distB = _calculateDistance(
        userLat,
        userLng,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });
    return sorted;
  }

  /// Get auto suggestions based on query
  List<PointOfInterest> getAutoSuggestions(
    List<PointOfInterest> pois,
    String query, {
    int maxSuggestions = 5,
  }) {
    if (query.isEmpty) {
      return pois.take(maxSuggestions).toList();
    }

    final searchResults = searchPOIs(pois, query, scoreThreshold: 50);
    return searchResults.take(maxSuggestions).toList();
  }

  /// Calculate distance using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double p = 0.017453292519943295;
    final double d = 0.017453292519943295 * (lon2 - lon1);
    final a =
        0.5 -
        0.5 * cos(3.141592653589793 - ((lat2 - lat1).abs() * p)) +
        0.25 * cos(d) * cos((lat2 - lat1).abs() * p) * (1 - cos(d));
    return 12742 * asin(sqrt(2 * a)).abs();
  }

  /// Get categories from POIs
  List<String> getUniqueCategoriesFromPOIs(List<PointOfInterest> pois) {
    final categories = <String>{};
    for (var poi in pois) {
      categories.add(poi.category);
    }
    return categories.toList()..sort();
  }
}
