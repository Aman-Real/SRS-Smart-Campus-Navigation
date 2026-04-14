import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'utils/themes.dart';
import 'utils/sample_data.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SampleData.initializeData();

  // Test Firestore connection
  FirebaseFirestore.instance
      .collection('points_of_interest')
      .snapshots()
      .listen((event) {
        print('Connected to Firestore! Found ${event.docs.length} documents');
      });
  runApp(const CampusNavigationApp());
}

class CampusNavigationApp extends StatelessWidget {
  const CampusNavigationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Navigation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
      routes: {'/home': (context) => const HomeScreen()},
    );
  }
}
