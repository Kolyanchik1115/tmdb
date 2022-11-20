// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tmdb/domain/data_providers/session_data_provider.dart';
import 'package:tmdb/ui/naviagation/main_navigation.dart';
import 'package:tmdb/ui/naviagation/main_navigation_action.dart';

class MainScreenWidget extends StatefulWidget {
  final ScreenFactory screenFactory;
  final SessionDataProvider sessionDataProvider;
  final MainNavigationAction navigationAction;

  const MainScreenWidget({
    Key? key,
    required this.screenFactory,
    required this.sessionDataProvider,
    required this.navigationAction,
  }) : super(key: key);

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDB'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              widget.sessionDataProvider.setSessionId(null);
              widget.navigationAction.resetNavigation(context);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          const Center(child: Text('Новости')),
          widget.screenFactory.makeMovieList(),
          widget.screenFactory.makeTVShowList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Фильмы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Шоу',
          )
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
