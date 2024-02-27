import 'package:flutter/material.dart';
import 'package:movie_assignment/theme/theme_provider.dart';
import 'package:movie_assignment/widgets/theme_switch.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Light / Dark Mode'),
                Spacer(),
                ThemeSwitch(themeProvider: themeProvider),
              ],
            ),
            Divider(),
            SizedBox(height: 16.0),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            _buildNotificationSwitch(context),
            Divider(),
            SizedBox(height: 16.0),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(BuildContext context) {
    return Row(
      children: [
        const Text('Receive Notifications'),
        const Spacer(),
        Switch(
          value: true, // Replace with your notification logic
          onChanged: (value) {
            // Add your notification settings logic here
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Version: 1.0.0'),
        SizedBox(height: 8.0),
        Text('Developer: Hifzurr R Moosa'),
        SizedBox(height: 8.0),
        Text('Email: hrmoosa@uclan.ac.uk'),
      ],
    );
  }
}
