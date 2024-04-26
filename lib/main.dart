import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dharma_00_01/firebase_options.dart';
import 'screens/main_screen.dart'; // Import the MainScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(), // Set MainScreen as the root of the app
    );
  }
}
