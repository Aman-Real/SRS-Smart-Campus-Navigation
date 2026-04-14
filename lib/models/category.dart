class Category {
  final String name;
  final String icon;
  final String color;

  Category({required this.name, required this.icon, required this.color});

  static final List<Category> defaultCategories = [
    Category(name: 'Academic', icon: '📚', color: '#3366CC'),
    Category(name: 'Laboratory', icon: '🔬', color: '#FF6633'),
    Category(name: 'Administrative', icon: '📋', color: '#99CC00'),
    Category(name: 'Facilities', icon: '🏢', color: '#CC0099'),
    Category(name: 'Cafeteria', icon: '🍽️', color: '#FF9900'),
    Category(name: 'Library', icon: '📖', color: '#00CC99'),
    Category(name: 'Sports', icon: '⚽', color: '#0099CC'),
    Category(name: 'Healthcare', icon: '🏥', color: '#CC3333'),
    Category(name: 'Parking', icon: '🅿️', color: '#666666'),
    Category(name: 'Other', icon: '📍', color: '#999999'),
  ];

  static Category getCategoryByName(String name) {
    try {
      return defaultCategories.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return defaultCategories.last; // Return 'Other'
    }
  }
}
