import 'package:flutter/material.dart';
import '../models/poi.dart';
import '../services/firebase_service.dart';
import '../utils/constants.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late FirebaseService _firebaseService;
  List<PointOfInterest> _pois = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _loadPOIs();
  }

  void _loadPOIs() {
    _firebaseService.getAllPOIs().listen((pois) {
      setState(() {
        _pois = pois;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Manage POIs'),
              Tab(text: 'Statistics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // POI Management
            _buildPOIManagement(context),
            // Statistics
            _buildStatistics(context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddPOIDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildPOIManagement(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: _pois.length,
      itemBuilder: (context, index) {
        final poi = _pois[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(poi.name),
            subtitle: Text(poi.category),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditPOIDialog(context, poi);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, poi.id);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatistics(BuildContext context) {
    // Count POIs by category
    Map<String, int> categoryCount = {};
    for (var poi in _pois) {
      categoryCount[poi.category] = (categoryCount[poi.category] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Locations',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pois.length.toString(),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('By Category', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...categoryCount.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showAddPOIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildPOIForm(context, null),
    );
  }

  void _showEditPOIDialog(BuildContext context, PointOfInterest poi) {
    showDialog(
      context: context,
      builder: (context) => _buildPOIForm(context, poi),
    );
  }

  Widget _buildPOIForm(BuildContext context, PointOfInterest? poi) {
    return AlertDialog(
      title: Text(poi == null ? 'Add Location' : 'Edit Location'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Name'),
              controller: TextEditingController(text: poi?.name ?? ''),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Description'),
              controller: TextEditingController(text: poi?.description ?? ''),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Category'),
              controller: TextEditingController(text: poi?.category ?? ''),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Latitude'),
              controller: TextEditingController(
                text: poi?.latitude.toString() ?? '',
              ),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Longitude'),
              controller: TextEditingController(
                text: poi?.longitude.toString() ?? '',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Save POI
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String poiId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: const Text('Are you sure you want to delete this location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firebaseService.deletePOI(poiId);
              Navigator.pop(context);
              setState(() {
                _pois.removeWhere((poi) => poi.id == poiId);
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
