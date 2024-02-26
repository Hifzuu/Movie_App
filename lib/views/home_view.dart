import 'package:flutter/material.dart';
import 'watched_movies_view.dart';
import 'to-watch_movies_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 2; // Default index for the "Home" view
  final String apiKey = '28bfc42e2b6e932f53de275690379158';
  String apiUrl = 'https://api.themoviedb.org/3/movie/popular';

  List<Map<String, dynamic>> movies = [];
  List<String> movieCategories = [
    'Popular',
    'Now Playing',
    'Upcoming',
    'Top Rated'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: movieCategories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    fetchData(apiUrl);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = 2; // Reset to 'Home' index
        switch (_tabController.index) {
          case 0:
            apiUrl = 'https://api.themoviedb.org/3/movie/popular';
            break;
          case 1:
            apiUrl = 'https://api.themoviedb.org/3/movie/now_playing';
            break;
          case 2:
            apiUrl = 'https://api.themoviedb.org/3/movie/upcoming';
            break;
          case 3:
            apiUrl = 'https://api.themoviedb.org/3/movie/top_rated';
            break;
        }
        fetchData(apiUrl);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?api_key=$apiKey'));
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> results = responseData['results'];

        setState(() {
          movies = List<Map<String, dynamic>>.from(results);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? Text('Reviews')
            : _currentIndex == 1
                ? Text('Watched Movies')
                : _currentIndex == 2
                    ? Text('Home')
                    : Text('To-Watch Movies'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
        bottom: _currentIndex == 2
            ? TabBar(
                controller: _tabController,
                tabs: movieCategories
                    .map(
                      (category) => Tab(
                        text: category,
                      ),
                    )
                    .toList(),
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
              )
            : null,
      ),
      body: _currentIndex == 2
          ? TabBarView(
              controller: _tabController,
              children: movieCategories.map((category) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMovieCard(movies[index]);
                  },
                );
              }).toList(),
            )
          : IndexedStack(
              index: _currentIndex,
              children: [
                //ReviewsView(),
                WatchedMoviesView(),
                const Center(
                  child: Text(
                    'Welcome to Movie Tracker! This is where users will be able to search for movies.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                ToWatchMoviesView(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue, // Set the color for the active item
        unselectedItemColor: Colors.grey, // Set the color for unselected items
        type: BottomNavigationBarType
            .fixed, // Set to fixed for persistent navigation bar
        showSelectedLabels: true, // Show labels for the selected item
        showUnselectedLabels: true, // Show labels for unselected items
        elevation: 8, // Set the elevation for a subtle shadow
        backgroundColor:
            Color.fromARGB(255, 235, 235, 235), // Set the background color
        selectedFontSize: 12, // Set font size for selected label
        unselectedFontSize: 12, // Set font size for unselected labels
        // Handle navigation events
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return ClipRRect(
      // elevation: 4.0,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12.0),
      // ),
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                      width: 120,
                      height: 160,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: [
            //         Text(
            //           movie['title'],
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black87,
            //           ),
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //         SizedBox(height: 4.0),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(Icons.access_time, size: 16.0, color: Colors.grey),
            //             SizedBox(width: 4.0),
            //             Text(
            //               '${movie['duration']} min', // Replace 'duration' with the actual key in your movie data
            //               style: TextStyle(fontSize: 14.0, color: Colors.grey),
            //             ),
            //             SizedBox(width: 16.0),
            //             Icon(Icons.star, size: 16.0, color: Colors.amber),
            //             SizedBox(width: 4.0),
            //             Text(
            //               '${movie['reviews']}', // Replace 'user_score' with the actual key in your movie data
            //               style: TextStyle(fontSize: 14.0, color: Colors.grey),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }
}
