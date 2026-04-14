import 'package:flutter/material.dart';
import '../models/poi.dart';

class SearchScreen extends StatefulWidget {
  final List<PointOfInterest> pois;

  const SearchScreen({Key? key, required this.pois}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  List<PointOfInterest> _results = [];
  String _filterCategory = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final filtered = widget.pois
        .where(
          (poi) =>
              (query.isEmpty ||
                  poi.name.toLowerCase().contains(query.toLowerCase()) ||
                  poi.description.toLowerCase().contains(
                    query.toLowerCase(),
                  )) &&
              (_filterCategory == 'All' || poi.category == _filterCategory),
        )
        .toList();

    setState(() {
      _results = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Locations'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Search locations...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _filterCategory == 'All',
                        onSelected: (selected) {
                          setState(() {
                            _filterCategory = 'All';
                          });
                          _performSearch(_searchController.text);
                        },
                      ),
                      ...widget.pois
                          .map((poi) => poi.category)
                          .toSet()
                          .map(
                            (category) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: FilterChip(
                                label: Text(category),
                                selected: _filterCategory == category,
                                onSelected: (selected) {
                                  setState(() {
                                    _filterCategory = selected
                                        ? category
                                        : 'All';
                                  });
                                  _performSearch(_searchController.text);
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final poi = _results[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(poi.name),
                        subtitle: Text(poi.category),
                        onTap: () {
                          Navigator.pop(context, poi);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
