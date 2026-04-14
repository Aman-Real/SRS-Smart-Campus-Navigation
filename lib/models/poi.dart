import 'package:cloud_firestore/cloud_firestore.dart';

class PointOfInterest {
  final String id;
  final String name;
  final String description;
  final String category; // Academic, Administrative, Facilities, etc.
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final String? contactDetails;
  final String? openingHours;
  final List<String>? amenities;
  final String? floorNumber;
  final String? buildingName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PointOfInterest({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.contactDetails,
    this.openingHours,
    this.amenities,
    this.floorNumber,
    this.buildingName,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'contactDetails': contactDetails,
      'openingHours': openingHours,
      'amenities': amenities ?? [],
      'floorNumber': floorNumber,
      'buildingName': buildingName,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
    };
  }

  // Create from Firestore document
  factory PointOfInterest.fromMap(Map<String, dynamic> map) {
    return PointOfInterest(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'],
      contactDetails: map['contactDetails'],
      openingHours: map['openingHours'],
      amenities: List<String>.from(map['amenities'] ?? []),
      floorNumber: map['floorNumber'],
      buildingName: map['buildingName'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory PointOfInterest.fromFirestore(DocumentSnapshot doc) {
    return PointOfInterest.fromMap(doc.data() as Map<String, dynamic>);
  }

  PointOfInterest copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? contactDetails,
    String? openingHours,
    List<String>? amenities,
    String? floorNumber,
    String? buildingName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PointOfInterest(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      contactDetails: contactDetails ?? this.contactDetails,
      openingHours: openingHours ?? this.openingHours,
      amenities: amenities ?? this.amenities,
      floorNumber: floorNumber ?? this.floorNumber,
      buildingName: buildingName ?? this.buildingName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
