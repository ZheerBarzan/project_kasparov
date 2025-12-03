import 'package:flutter/material.dart';
import 'package:project_kasparov/Views/game_board.dart';
import 'package:project_kasparov/Views/launch_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LaunchScreen(),
      ),
    );
  }
}
