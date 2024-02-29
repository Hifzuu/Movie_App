import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:movie_assignment/widgets/login_scaffold.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      child: ForgotPasswordForm(),
    );
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    try {
      if (_emailController.text.isEmpty) {
        _showErrorMessage(context, 'Please enter your email.');
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      // Successful password reset request
      _showSuccessMessage(
        context,
        'Password reset email sent. Please check your email.',
      );
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      String errorMessage = 'Password reset failed. Please try again.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with that email.';
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
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
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
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    ).show(context);
  }

  void _showSuccessMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 10),
      backgroundColor: Colors.green,
      borderRadius: BorderRadius.circular(10),
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.green,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      boxShadows: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            height: 10,
          ),
        ),
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                    const SizedBox(height: 12.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                        ),
                        child: const Text(
                          'RESET',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        // Navigate back to the login page
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Return to Log In',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
