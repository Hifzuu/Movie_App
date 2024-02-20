// lib/main.dart
import 'package:flutter/material.dart';
import 'package:movie_assignment/firebase_options.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/signup_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/signup': (context) => SignupView(),
      },
    );
  }
}
