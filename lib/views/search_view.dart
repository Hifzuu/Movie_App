import 'package:flutter/material.dart';
import 'package:movie_assignment/widgets/back_button.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const backButton(),
            backgroundColor: Theme.of(context).colorScheme.background,
            expandedHeight: 350,
            pinned: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
