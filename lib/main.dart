// lib/main.dart
import 'package:flutter/material.dart';
import 'package:movie_assignment/firebase_options.dart';
import 'package:movie_assignment/theme/theme.dart';
import 'views/login_view.dart';
import 'views/home_view copy.dart';
import 'views/signup_view.dart';
import 'views/watched_movies_view.dart';
import 'views/to-watch_movies_view.dart';
import 'views/reviews_view.dart';
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
      title: 'Watch Pilot',
      theme: lightMode,
      darkTheme: darkMode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/signup': (context) => SignupView(),
        '/watched_movies': (context) => WatchedMoviesView(),
        '/to_watch_movies': (context) => ToWatchMoviesView(),
        '/reviews': (context) => ReviewsView(),
      },
    );
  }
}
