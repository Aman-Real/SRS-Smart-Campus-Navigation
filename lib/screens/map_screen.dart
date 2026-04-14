import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';
import '../models/poi.dart';
import '../models/category.dart';
import '../utils/constants.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  final List<PointOfInterest> pois;
  final PointOfInterest? selectedPOI;

  const MapScreen({Key? key, required this.pois, this.selectedPOI})
    : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final WebViewController _webViewController;
  late LocationService _locationService;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _initializeWebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _getUserLocation,
            tooltip: 'My Location',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMap,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView for Map
          WebViewWidget(controller: _webViewController),

          // Loading indicator
          if (!_mapReady) const Center(child: CircularProgressIndicator()),

          // Bottom sheet with POI info (if selected)
          if (widget.selectedPOI != null && _mapReady)
            _buildPOIInfoPanel(context),
        ],
      ),
    );
  }

  WebViewController _initializeWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterConsole',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('JS Console: ${message.message}');
        },
      )
      ..addJavaScriptChannel(
        'MapEvents',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final data = jsonDecode(message.message);
            final event = data['event'];
            switch (event) {
              case 'onMapReady':
                debugPrint('Map is ready');
                setState(() {
                  _mapReady = true;
                });
                _addMarkersToMap();
                if (widget.selectedPOI != null) {
                  _navigateToPOI(widget.selectedPOI!);
                }
                break;
              case 'onMarkerClick':
                debugPrint('Marker clicked: ${data['data']}');
                break;
              case 'onRouteCalculated':
                debugPrint('Route calculated: ${data['data']}');
                break;
              case 'onFavoriteAdded':
                debugPrint('Favorite added: ${data['data']}');
                break;
            }
          } catch (e) {
            debugPrint('Error parsing MapEvents message: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            // Map ready will be set via JavaScript event
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
            debugPrint('URL: ${error.url}');
            debugPrint('Error code: ${error.errorCode}');
            debugPrint('Is for main frame: ${error.isForMainFrame}');
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation request: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadFlutterAsset('assets/html/map.html');

    return _webViewController;
  }

  void _addMarkersToMap() {
    for (var poi in widget.pois) {
      final category = Category.getCategoryByName(poi.category);
      final colorHex = category.color;

      String amenitiesJson = _jsonEncode(poi.amenities ?? []);

      String script =
          '''
        try {
          mapFunctions.addMarker(
            '${poi.id}',
            '${_escapeString(poi.name)}',
            ${poi.latitude},
            ${poi.longitude},
            '${_escapeString(poi.description)}',
            '${_escapeString(poi.category)}',
            '$colorHex',
            {
              buildingName: '${_escapeString(poi.buildingName ?? '')}',
              floorNumber: '${_escapeString(poi.floorNumber ?? '')}',
              contactDetails: '${_escapeString(poi.contactDetails ?? '')}',
              openingHours: '${_escapeString(poi.openingHours ?? '')}',
              amenities: $amenitiesJson
            }
          );
        } catch(e) {
          console.log('Error adding marker: ' + e.toString());
        }
      ''';

      _webViewController.runJavaScript(script);
    }
  }

  void _navigateToPOI(PointOfInterest poi) {
    String script =
        'mapFunctions.centerMapOnLocation(${poi.latitude}, ${poi.longitude});';
    _webViewController.runJavaScript(script);
  }

  void _getUserLocation() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      String script =
          'mapFunctions.showUserLocation(${position.latitude}, ${position.longitude});';
      _webViewController.runJavaScript(script);

      String centerScript =
          'mapFunctions.centerMapOnLocation(${position.latitude}, ${position.longitude});';
      _webViewController.runJavaScript(centerScript);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get current location')),
      );
    }
  }

  void _refreshMap() {
    setState(() {
      _mapReady = false;
    });
    _webViewController.reload();
  }

  Widget _buildPOIInfoPanel(BuildContext context) {
    final poi = widget.selectedPOI!;
    final category = Category.getCategoryByName(poi.category);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poi.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          poi.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                poi.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.directions),
                      label: const Text('Navigate'),
                      onPressed: () {
                        String script =
                            'mapFunctions.navigateTo(${poi.latitude}, ${poi.longitude});';
                        _webViewController.runJavaScript(script);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Details'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper function to encode JSON
  String _jsonEncode(List<dynamic> list) {
    return '[${list.map((e) => '"${_escapeString(e.toString())}"').join(',')}]';
  }

  /// Helper function to escape strings for JavaScript
  String _escapeString(String str) {
    return str
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }
}
