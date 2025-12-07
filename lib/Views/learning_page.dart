import 'package:flutter/material.dart';
import 'package:project_kasparov/Theme/colors.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          "Learn Chess",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
