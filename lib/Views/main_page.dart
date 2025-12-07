import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_kasparov/Theme/colors.dart';
import 'package:project_kasparov/Views/game_modes_page.dart';
import 'package:project_kasparov/Views/learning_page.dart';
import 'package:project_kasparov/Views/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 1; // Default to Game Tab (middle)

  final List<Widget> _pages = [
    const LearningPage(),
    const GameModesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: backgroundColor, // Match background
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: GNav(
            backgroundColor: backgroundColor,
            color: Colors.white, // Inactive icon color
            activeColor: Colors.black, // Active icon color
            tabBackgroundColor: Colors.white, // Active tab background
            gap: 8, // Gap between icon and text
            padding: const EdgeInsets.all(16),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.school,
                text: 'Learn',
              ),
              GButton(
                icon: Icons.videogame_asset, // Or Icons.home
                text: 'Play',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
