import 'package:flutter/material.dart';
import 'watched_movies_view.dart';
import 'to-watch_movies_view.dart';
import 'reviews_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 2; // Default index for the "Home" view
  final String apiKey = '28bfc42e2b6e932f53de275690379158';
  final String apiUrl = 'https://api.themoviedb.org/3/movie/popular';

  List<Map<String, dynamic>> movies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
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
        title: Text(
          _currentIndex == 0
              ? 'Reviews'
              : (_currentIndex == 1
                  ? 'Watched Movies'
                  : (_currentIndex == 2 ? 'Home' : 'To-Watch Movies')),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Set your preferred app bar color
        elevation: 0, // Remove the app bar shadow
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: _currentIndex == 2 // Assuming 'Home' is at index 2
          ? Container(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final posterPath = movie['poster_path'];
                  final imageUrl = 'http://image.tmdb.org/t/p/w185$posterPath';

                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Handle the tap on the movie item
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              height: 330.0 * 2 / 3,
                              width: double.infinity,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie['title'],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines:
                                  2, // Adjust the number of lines as needed
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))
          : IndexedStack(
              index: _currentIndex,
              children: [
                ReviewsView(),
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
