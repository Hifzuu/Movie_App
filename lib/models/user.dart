import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

// Represents a user with basic information
class User {
  final String uid;
  final String email;
  final String name;

  // Constructor to create a User instance
  User({
    required this.uid,
    required this.email,
    required this.name,
  });

  // Factory method to create a User instance from a Firebase User
  factory User.fromFirebaseUser(FirebaseAuth.User user) {
    // Create and return a User instance
    return User(
      uid: user.uid,
      email: user.email!,
      name: '',
    );
  }

  // Static method to fetch user data from Firestore
  static Future<User?> fetchUserData() async {
    // Get the currently authenticated user
    FirebaseAuth.User? user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Replace 'users' with the actual collection or node where user data is stored
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      // Access the user data from the snapshot
      Map<String, dynamic> userData = userSnapshot.data()!;

      // Return a User object with the fetched data
      return User(
        uid: user.uid,
        email: user.email!,
        name: userData['name'], // Assuming 'name' is a field in your user data
      );
    } else {
      return null; // Return null if the user is not authenticated
    }
  }
}
