import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
      body: SingleChildScrollView(
        child: Padding(
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
                'Additional Settings',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              _buildDarkModeSchedule(context),
              Divider(),
              SizedBox(height: 16.0),
              _buildFeedbackButton(context),
              Divider(),
              SizedBox(height: 16.0),
              _buildClearCacheButton(context),
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

  Widget _buildDarkModeSchedule(BuildContext context) {
    return Row(
      children: [
        const Text('Set Dark Mode Schedule'),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.background),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Row(
      children: [
        const Text('Provide Feedback'),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.background),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildClearCacheButton(BuildContext context) {
    return Row(
      children: [
        const Text('Clear Cache'),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            _showClearCacheConfirmationDialog(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.background),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  void _showClearCacheConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text('Are you sure you want to clear the app cache?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                await _clearAppCache(context);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearAppCache(BuildContext context) async {
    try {
      await DefaultCacheManager().emptyCache(); // Clear the app cache
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache cleared successfully!'),
        ),
      );
    } catch (error) {
      print('Error clearing cache: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to clear cache. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
