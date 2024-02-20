import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_flushbar/flushbar.dart';

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SignupForm(),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signup() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        // Add more fields as needed
      });

      // Debug print to verify successful account creation
      print('Account created successfully for email: $email');

      // Navigate back to the login screen
      Navigator.pushReplacementNamed(context, '/login',
          arguments: {'email': email});
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      String errorMessage = 'An error occurred, please try again.';

      if (e.code == 'weak-password') {
        errorMessage =
            'The password provided is too weak. Please choose a stronger password.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage =
            'An account already exists for the provided email. Please use a different email.';
      }

      // Show an error message
      _showErrorMessage(context, errorMessage);
    } catch (e) {
      // Handle other exceptions
      print('Error during account creation: ${e.toString()}');
      // Show a generic error message
      _showErrorMessage(context, 'An error occurred, please try again. ');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 10),
      backgroundColor: Colors.red,
      borderRadius: BorderRadius.circular(10),
      flushbarStyle: FlushbarStyle.GROUNDED, // Adjusted flushbar style
      flushbarPosition: FlushbarPosition.TOP, // Positioned at the bottom
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ), // Add an error icon
      leftBarIndicatorColor: Colors.red,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      isDismissible: true, // Allow manual dismissal
      dismissDirection:
          FlushbarDismissDirection.VERTICAL, // Dismiss horizontally
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 3, 7, 32), // Dark blue color
          ),
        ),
        SizedBox(height: 24.0),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 24.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Perform signup authentication
              _signup();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 3, 7, 32),
              ),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.0),
        GestureDetector(
          onTap: () {
            // Navigate to the login page when the link is tapped
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "Already signed up? Log In",
            style: TextStyle(
              color: Color.fromARGB(255, 3, 7, 32), // Dark blue color
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
