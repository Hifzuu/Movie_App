import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final String currentSort;
  final Function(String) onSelectFilter;

  const FilterDropdown({
    required this.currentSort,
    required this.onSelectFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Filter List By',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Alphabetical Order (A-Z)'),
            tileColor: currentSort == 'Alphabetical Order (A-Z)'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Alphabetical Order (A-Z)');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Alphabetical Order (Z-A)'),
            tileColor: currentSort == 'Alphabetical Order (Z-A)'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Alphabetical Order (Z-A)');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Top Rated First'),
            tileColor: currentSort == 'Top Rated First'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Top Rated First');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Lowest Rated First'),
            tileColor: currentSort == 'Lowest Rated First'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Lowest Rated First');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Newest Release First'),
            tileColor: currentSort == 'Newest Release First'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Newest Release First');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Oldest Release First'),
            tileColor: currentSort == 'Oldest Release First'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Oldest Release First');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Longest Duration First'),
            tileColor: currentSort == 'Longest Duration First'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Longest Duration First');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Shortest Duration First'),
            tileColor: currentSort == 'Shortest Duration First'
                ? Theme.of(context).colorScheme.primary
                : null,
            onTap: () {
              onSelectFilter('Shortest Duration First');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
