import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_assignment/theme/theme.dart';
import 'package:movie_assignment/theme/theme_provider.dart';

class ThemeSwitch extends StatelessWidget {
  final ThemeProvider themeProvider;

  const ThemeSwitch({Key? key, required this.themeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: themeProvider.themeData == darkMode,
      onChanged: (value) {
        themeProvider.toggleTheme();
      },
    );
  }
}
