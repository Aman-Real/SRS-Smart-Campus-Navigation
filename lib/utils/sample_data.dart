import 'package:campusnavigation/models/poi.dart';
import 'package:campusnavigation/services/firebase_service.dart';

/// Sample data for initializing the database
class SampleData {
  static final FirebaseService _firebaseService = FirebaseService();

  /// All sample POIs for campus
  static final List<PointOfInterest> samplePOIs = [
    // Academic Buildings (Central Campus Area)
    PointOfInterest(
      id: 'poi_001',
      name: 'Computer Science Department',
      description:
          'Building dedicated to Computer Science and Engineering programs. Houses classrooms, labs, and faculty offices.',
      category: 'Academic',
      latitude: 30.4006, // Central location
      longitude: 78.0784,
      buildingName: 'CSE Building',
      floorNumber: '5',
      contactDetails: '+91-135-300-0300',
      openingHours: '8:00 AM - 6:00 PM',
      amenities: [
        'Library',
        'Computer Labs',
        'Lecture Halls',
        'Faculty Offices',
      ],
    ),
    PointOfInterest(
      id: 'poi_002',
      name: 'Mechanical Engineering',
      description:
          'Mechanical Engineering department with workshops and testing facilities.',
      category: 'Academic',
      latitude: 30.4008, // Slightly north
      longitude: 78.0782,
      buildingName: 'ME Building',
      floorNumber: '4',
      contactDetails: '+91-135-300-0301',
      openingHours: '7:30 AM - 6:30 PM',
      amenities: ['Workshop', 'Labs', 'Testing Chambers', 'Library'],
    ),
    PointOfInterest(
      id: 'poi_003',
      name: 'Civil Engineering',
      description: 'Civil Engineering department and materials lab.',
      category: 'Academic',
      latitude: 30.4004, // Slightly south
      longitude: 78.0786,
      buildingName: 'CE Building',
      floorNumber: '3',
      contactDetails: '+91-135-300-0302',
      openingHours: '8:00 AM - 6:00 PM',
      amenities: ['Materials Lab', 'Testing Lab', 'Classrooms'],
    ),

    // Laboratories (Research Wing - East Side)
    PointOfInterest(
      id: 'lab_001',
      name: 'AI & Machine Learning Lab',
      description:
          'State-of-the-art laboratory for AI research with GPU clusters.',
      category: 'Laboratory',
      latitude: 30.4009, // North-east
      longitude: 78.0787,
      buildingName: 'Research Wing A',
      floorNumber: '2',
      contactDetails: '+91-135-300-0303',
      openingHours: '9:00 AM - 10:00 PM',
      amenities: ['GPUs', 'Servers', 'Meeting Rooms', 'Workstations'],
    ),
    PointOfInterest(
      id: 'lab_002',
      name: 'Electronics Lab',
      description: 'Electronics and circuit design laboratory.',
      category: 'Laboratory',
      latitude: 30.4007, // East
      longitude: 78.0788,
      buildingName: 'CSE Building',
      floorNumber: '2',
      contactDetails: '+91-135-300-0304',
      openingHours: '8:00 AM - 8:00 PM',
      amenities: ['PCB Design Tools', 'Oscilloscopes', 'Component Library'],
    ),
    PointOfInterest(
      id: 'lab_003',
      name: 'Robotics Lab',
      description: 'Robotics research and development facility.',
      category: 'Laboratory',
      latitude: 30.4010, // Further north-east
      longitude: 78.0789,
      buildingName: 'Research Wing B',
      floorNumber: '3',
      contactDetails: '+91-135-300-0305',
      openingHours: '10:00 AM - 8:00 PM',
      amenities: ['Robot Arms', '3D Printers', 'Motion Capture'],
    ),

    // Administrative (South Entrance Area)
    PointOfInterest(
      id: 'admin_001',
      name: 'Administration Building',
      description: 'Main administrative office for campus management.',
      category: 'Administrative',
      latitude: 30.4002, // South
      longitude: 78.0783,
      buildingName: 'Admin Block',
      floorNumber: '1-3',
      contactDetails: '+91-135-300-0306',
      openingHours: '9:00 AM - 5:00 PM (Weekdays)',
      amenities: ['Reception', 'Registrar', 'Finance Office'],
    ),
    PointOfInterest(
      id: 'admin_002',
      name: 'Student Services',
      description: 'Office providing student support services.',
      category: 'Administrative',
      latitude: 30.4003, // South-east
      longitude: 78.0785,
      buildingName: 'Student Center',
      floorNumber: '1',
      contactDetails: '+91-135-300-0307',
      openingHours: '8:00 AM - 6:00 PM',
      amenities: ['Counseling', 'Career Services', 'Placement Office'],
    ),

    // Facilities (Spread around campus)
    PointOfInterest(
      id: 'facility_001',
      name: 'Main Library',
      description:
          'Central library with extensive book collection and digital resources.',
      category: 'Library',
      latitude: 30.4005, // Central-west
      longitude: 78.0781,
      buildingName: 'Library Complex',
      floorNumber: '5',
      contactDetails: '+91-135-300-0308',
      openingHours: '7:00 AM - 11:00 PM',
      amenities: [
        'Reading Rooms',
        'Computer Lab',
        'WiFi',
        'Study Carrels',
        'Café',
      ],
    ),
    PointOfInterest(
      id: 'facility_002',
      name: 'Cafeteria',
      description: 'Main dining facility serving breakfast, lunch and dinner.',
      category: 'Cafeteria',
      latitude: 30.4001, // South-west
      longitude: 78.0780,
      buildingName: 'Dining Hall',
      floorNumber: '1',
      contactDetails: '+91-135-300-0309',
      openingHours: '7:00 AM - 9:00 PM',
      amenities: ['Seating 500+', 'Vegetarian Options', 'WiFi'],
    ),
    PointOfInterest(
      id: 'facility_003',
      name: 'Gymnasium',
      description: 'Fitness center with gym equipment and sports facilities.',
      category: 'Sports',
      latitude: 30.4011, // North
      longitude: 78.0782,
      buildingName: 'Sports Complex',
      floorNumber: '1-2',
      contactDetails: '+91-135-300-0310',
      openingHours: '6:00 AM - 9:00 PM',
      amenities: [
        'Cardio Equipment',
        'Weights',
        'Basketball Court',
        'Badminton Court',
      ],
    ),
    PointOfInterest(
      id: 'facility_004',
      name: 'Health Center',
      description:
          'Medical facility providing healthcare services to students.',
      category: 'Healthcare',
      latitude: 30.4000, // South-west corner
      longitude: 78.0779,
      buildingName: 'Medical Block',
      floorNumber: '1',
      contactDetails: '+91-135-300-0311',
      openingHours: '9:00 AM - 5:00 PM (24/7 Emergency)',
      amenities: ['Doctor', 'Pharmacy', 'Emergency', 'Ambulance'],
    ),
    PointOfInterest(
      id: 'facility_005',
      name: 'Parking - Block A',
      description: 'Multi-level parking facility for cars and motorcycles.',
      category: 'Parking',
      latitude: 30.3999, // South entrance
      longitude: 78.0781,
      buildingName: 'Parking Block A',
      floorNumber: '4',
      contactDetails: '+91-135-300-0312',
      openingHours: '24/7',
      amenities: ['Car Parking', 'Bike Parking', 'Security'],
    ),
  ];

  /// Initialize sample data in Firebase
  static Future<void> initializeData() async {
    try {
      print('Checking for existing sample data...');

      // Check if sample data already exists by trying to get POIs
      final existingPOIs = await _firebaseService.getAllPOIs().first;

      if (existingPOIs.isNotEmpty) {
        print('Sample data already exists. Skipping upload.');
        return;
      }

      print('Uploading sample POIs...');
      bool success = await _firebaseService.batchUploadPOIs(samplePOIs);
      if (success) {
        print('Successfully uploaded ${samplePOIs.length} sample locations!');
      } else {
        print('Error uploading sample data');
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }
}
