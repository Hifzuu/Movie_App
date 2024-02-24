import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/widgets/movies_slider.dart';
import 'package:movie_assignment/widgets/trending_slider.dart';
import 'watched_movies_view.dart';
import 'to-watch_movies_view.dart';
import 'reviews_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

late Future<List<Movie>> trendingMovies;
late Future<List<Movie>> topRatedMovies;
late Future<List<Movie>> upcomingMovies;
int _currentIndex = 2; // Default index for the "Home" view
late PageController _pageController;

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    trendingMovies = api().getTrendingMovies();
    topRatedMovies = api().getTopRatedMovies();
    upcomingMovies = api().getUpcomingMovies();
    _pageController = PageController(initialPage: _currentIndex);
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text("WATCHPILOT"),
        centerTitle: true,
      ),
      body: PageView(
        //for navigation
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          // Reviews Page
          ReviewsView(),
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
                  Text(
                    'Trending Movies',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20.0, // Adjust the font size as needed
                    ),
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Top Rated Movies',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20.0,
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Upcoming Movies',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20.0,
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
                          return const Center(
                              child: CircularProgressIndicator());
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
          //SettingsView(),
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
                icon: Icon(Icons.reviews),
                label: 'Reviews',
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
