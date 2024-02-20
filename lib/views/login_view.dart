import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _authenticateUser() async {
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _showErrorMessage(
            context, 'Please fill in both email and password fields.');
        return;
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Successful login
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      String errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid credentials';
      }

      // Show an error message
      _showErrorMessage(context, errorMessage);
    } catch (e) {
      // Handle other exceptions
      print(e.toString());
      // Show a generic error message
      _showErrorMessage(context, 'An error occurred. Please try again.');
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 3, 7, 32),
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
              TextFormField(
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
                    // Authenticate user using Firebase
                    _authenticateUser();
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
                    'Login',
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
                  // Navigate to the signup page when the link is tapped
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 3, 7, 32),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
