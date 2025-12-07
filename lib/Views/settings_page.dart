import 'package:flutter/material.dart';
import 'package:project_kasparov/Theme/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
