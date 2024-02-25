import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_assignment/views/login_view.dart';
import 'package:movie_assignment/views/signup_view.dart';
import 'package:movie_assignment/widgets/login_scaffold.dart';
import 'package:movie_assignment/widgets/welcom_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
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
                          '\n Dive into a Cinematic Adventure! Track and discover movies that match your mood. Your movie sanctuary awaits – where every watchlist is a blockbuster journey! Welcome to your personalised movie haven.',
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
    );
  }
}
