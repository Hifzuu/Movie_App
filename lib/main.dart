import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_assignment/firebase_options.dart';
import 'package:movie_assignment/services/shake_detection_provider.dart';
import 'package:movie_assignment/theme/theme_provider.dart';
import 'package:movie_assignment/views/forgot_pwd_view.dart';
import 'package:movie_assignment/views/search_view.dart';
import 'package:movie_assignment/views/splash_screen.dart';
import 'package:movie_assignment/views/welcome_view.dart';
import 'package:provider/provider.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/signup_view.dart';
import 'views/watched_movies_view.dart';
import 'views/to-watch_movies_view.dart';
import 'views/settings_view.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeProvider themeProvider = ThemeProvider();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  ShakeDetectionProvider shakeDetectionProvider = ShakeDetectionProvider();
  await themeProvider.loadTheme();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<ShakeDetectionProvider>.value(
            value: shakeDetectionProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WATCHPILOT',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
      //initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeView(),
        '/login': (context) => LoginView(),
        '/forgot_password': (context) => ForgotPasswordView(),
        '/home': (context) => HomeView(),
        '/signup': (context) => SignupView(),
        '/watched_movies': (context) => const WatchedMoviesView(),
        '/to_watch_movies': (context) => ToWatchMoviesView(),
        '/settings': (context) => SettingsView(),
        '/search': (context) => SearchView(),
      },
    );
  }
}
