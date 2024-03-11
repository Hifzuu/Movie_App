import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_assignment/views/login_view.dart';
import 'package:movie_assignment/views/signup_view.dart';
import 'package:movie_assignment/widgets/welcom_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Flexible(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 40,
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'Welcome User!\n',
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\n Welcome to your personalised movie haven. Dive into a cinematic adventure, track and discover movies that match your mood!',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        Expanded(
                            child: WelcomeButton(
                          buttonText: 'Log In',
                          onTap: LoginView(),
                          color: Colors.transparent,
                          textColor: Colors.white,
                        )),
                        Expanded(
                            child: WelcomeButton(
                          buttonText: 'Sign Up',
                          onTap: SignupView(),
                          color: Colors.white,
                          textColor: Theme.of(context).colorScheme.primary,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
