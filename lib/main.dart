// lib/main.dart
import 'package:flutter/material.dart';
import 'package:movie_assignment/firebase_options.dart';
import 'package:movie_assignment/theme/theme_provider.dart';
import 'package:movie_assignment/views/search_view.dart';
import 'package:movie_assignment/views/splash_screen.dart';
import 'package:movie_assignment/views/welcome_view.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'views/home_view copy.dart';
import 'views/signup_view.dart';
import 'views/watched_movies_view.dart';
import 'views/to-watch_movies_view.dart';
import 'views/settings_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watch Pilot',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: SplashScreen(),
      //initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeView(),
        '/login': (context) => LoginView(),
        '/home': (context) => HomeView(),
        '/signup': (context) => SignupView(),
        '/watched_movies': (context) => WatchedMoviesView(),
        '/to_watch_movies': (context) => ToWatchMoviesView(),
        '/settings': (context) => SettingsView(),
        '/search': (context) => SearchView(),
      },
    );
  }
}
