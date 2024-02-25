import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class User {
  final String uid;
  final String email;
  final String name;

  User({
    required this.uid,
    required this.email,
    required this.name,
  });

  factory User.fromFirebaseUser(FirebaseAuth.User user) {
    return User(
      uid: user.uid,
      email: user.email!,
      name: '',
    );
  }

  static Future<User?> fetchUserData() async {
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
