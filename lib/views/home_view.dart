import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as signOut;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_assignment/services/movie_api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/models/user.dart';
import 'package:movie_assignment/services/shake_detection_provider.dart';
import 'package:movie_assignment/services/shake_detector.dart';
import 'package:movie_assignment/theme/theme_provider.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/views/search_view.dart';
import 'package:movie_assignment/views/settings_view.dart';
import 'package:movie_assignment/widgets/movies_slider.dart';
import 'package:movie_assignment/widgets/theme_switch.dart';
import 'package:movie_assignment/widgets/trending_slider.dart';
import 'package:provider/provider.dart';
import 'watched_movies_view.dart';
import 'to-watch_movies_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

late Future<List<Movie>> trendingMovies;
late Future<List<Movie>> topRatedMovies;
late Future<List<Movie>> upcomingMovies;
int _currentIndex = 2; // Default index for the "Home" view
late PageController _pageController;
late Future<List<String>> movieGenres;
late Future<List<Movie>> moviesByGenre;
int selectedGenreIndex = 0; //default index for the genre selection
late ShakeDetectionProvider shakeDetectionProvider;

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDisconnected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shakeDetectionProvider = Provider.of<ShakeDetectionProvider>(context);
    ShakeDetector.initialize();
    ShakeDetector.onShake = _handleShake;
  }

  @override
  void initState() {
    super.initState();
    trendingMovies = api().getTrendingMovies();
    topRatedMovies = api().getTopRatedMovies();
    upcomingMovies = api().getUpcomingMovies();
    _pageController = PageController(initialPage: _currentIndex);
    movieGenres = api().getMovieGenres();
    moviesByGenre = api().getMoviesByGenre('Action');
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      _handleConnectivityChange(result);
    });
  }

  void _handleShake() {
    if (shakeDetectionProvider.isShakeDetectionEnabled) {
      api().getRandomMovie().then((Movie movie) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsView(movie: movie),
          ),
        );
      });
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    setState(() {
      isDisconnected = result == ConnectivityResult.none;
    });

    if (isDisconnected) {
      // Show dialog when there is no connectivity
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal on outside tap
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'No Connection',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text('Please connect to Wi-Fi or cellular data.'),
            actions: [
              TextButton(
                onPressed: () {
                  if (isDisconnected == false) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text("WATCHPILOT", style: GoogleFonts.alef()),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              _onBottomNavTapped(0);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          )
        ],
      ),
      //sidebar
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32),
                      Text(
                        'WATCHPILOT',
                        style: GoogleFonts.alef(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                ListTile(
                  leading: Icon(Icons.home,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Home',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  onTap: () {
                    Navigator.pop(context);
                    _onBottomNavTapped(2);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Settings',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  onTap: () {
                    Navigator.pop(context);
                    _onBottomNavTapped(4);
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.dark_mode,
                              color: Theme.of(context).colorScheme.secondary),
                          SizedBox(width: 8.0),
                          Text('Toggle Theme',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ],
                      ),
                      ThemeSwitch(
                        themeProvider: Provider.of<ThemeProvider>(context),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                ),
                const Spacer(),
                ListTile(
                  leading: Icon(Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Logout',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  onTap: () async {
                    try {
                      await signOut.FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      print('Error signing out: $e');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        //for navigation
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          //search page
          SearchView(),
          // Watched Movies Page
          WatchedMoviesView(),
          //Home Page
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //personalised welcome message
                  FutureBuilder(
                    future: User.fetchUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'An error occurred: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final User user = snapshot.data as User;
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.color,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${user.name.toUpperCase()}!',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  //trending movies carousel slider
                  SizedBox(
                    child: FutureBuilder(
                      future: trendingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return TrendingSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return Center(
                            child: SpinKitCircle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 50.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // genre specific movie section (selectable list of genres)
                  SizedBox(
                    height: 34,
                    child: FutureBuilder(
                      future: movieGenres,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          List<String> genres = snapshot.data as List<String>;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: genres.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGenreIndex = index;
                                      // Fetch and set movies for the selected genre
                                      moviesByGenre =
                                          api().getMoviesByGenre(genres[index]);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: selectedGenreIndex == index
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context).primaryColorLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      genres[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: selectedGenreIndex == index
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: SpinKitCircle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 50.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  //section showing the movies that align with selected genre
                  FutureBuilder(
                    future: moviesByGenre,
                    builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        List<Movie> movies = snapshot.data!;
                        return MoviesSlider(
                          snapshot: AsyncSnapshot<List<Movie>>.withData(
                              ConnectionState.done, movies),
                        );
                      } else {
                        return Center(
                          child: SpinKitCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 50.0,
                          ),
                        );
                      }
                    },
                  ),
                  //top rated movies slider
                  const SizedBox(height: 32),
                  Text(
                    'Top Rated Movies',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    child: FutureBuilder(
                      future: topRatedMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return MoviesSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return Center(
                            child: SpinKitCircle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 50.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  //upcoming movies slider
                  const SizedBox(height: 32),
                  Text(
                    'Upcoming Movies',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    child: FutureBuilder(
                      future: upcomingMovies,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return MoviesSlider(
                            snapshot: snapshot,
                          );
                        } else {
                          return Center(
                            child: SpinKitCircle(
                              color: Theme.of(context).colorScheme.primary,
                              size: 50.0,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // To Watch Movies Page
          ToWatchMoviesView(),
          // Settings Page
          SettingsView(),
        ],
      ),
      //navigation bar
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        color: Theme.of(context).colorScheme.secondary,
        activeColor: Theme.of(context).colorScheme.primary,
        items: const [
          TabItem(icon: Icons.search, title: 'Search'),
          TabItem(icon: Icons.movie, title: 'Watched'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.star, title: 'To-Watch'),
          TabItem(icon: Icons.settings, title: 'Settings'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          _onBottomNavTapped(index);
        },
        style: TabStyle.reactCircle,
        curveSize: 5,
        height: 50,
        top: -12,
        curve: Curves.easeInOut,
      ),
    );
  }
}
