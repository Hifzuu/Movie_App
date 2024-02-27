import 'package:firebase_auth/firebase_auth.dart' as signOut;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/models/user.dart';
import 'package:movie_assignment/theme/theme_provider.dart';
import 'package:movie_assignment/views/search_view.dart';
import 'package:movie_assignment/views/settings_view.dart';
import 'package:movie_assignment/widgets/movies_slider.dart';
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

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    trendingMovies = api().getTrendingMovies();
    topRatedMovies = api().getTopRatedMovies();
    upcomingMovies = api().getUpcomingMovies();
    _pageController = PageController(initialPage: _currentIndex);
    movieGenres = api().getMovieGenres();
    moviesByGenre = api().getMoviesByGenre('Action');
  }

  @override
  void dispose() {
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
        duration: Duration(milliseconds: 300),
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
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
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
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
                  Navigator.pop(context); // Close the drawer
                  _onBottomNavTapped(4);
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_6,
                    color: Theme.of(context).colorScheme.secondary),
                title: Text('Toggle Dark Mode',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
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
                  //------------------------------------------------------------------------------------------
                  Container(
                    height: 60,
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
                                    width: 120,
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

                  //
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1, // Adjust the height as needed
            thickness: 0.1, // Adjust the thickness for a subtle appearance
            color: Colors.grey.shade500, // Use the desired color
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onBottomNavTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.movie),
                label: 'Watched',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'To-Watch',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedItemColor: Theme.of(context)
                .colorScheme
                .primary, // Set the color for the active item
            unselectedItemColor: Theme.of(context)
                .colorScheme
                .secondary, // Set the color for unselected items
            type: BottomNavigationBarType
                .fixed, // Set to fixed for persistent navigation bar
            showSelectedLabels: true, // Show labels for the selected item
            showUnselectedLabels: true, // Show labels for unselected items
            elevation: 8, // Set the elevation for a subtle shadow
            backgroundColor: Theme.of(context)
                .colorScheme
                .background, // Set the background color
            selectedFontSize: 12, // Set font size for selected label
            unselectedFontSize: 12, // Set font size for unselected labels
            // Handle navigation events
          ),
        ],
      ),
    );
  }
}
