import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_kasparov/Theme/themes.dart';
import 'package:project_kasparov/Views/home_page.dart';
import 'package:project_kasparov/viewmodels/game_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Project Kasparov',
        theme: AppTheme.dark,
        home: HomePage(),
      ),
    );
  }
}
