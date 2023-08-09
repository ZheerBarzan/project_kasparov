import 'package:flutter/material.dart';
import 'package:project_kasparov/components/squre.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          final int row = ((index / 8).floor());
          final int col = (((index % 8)).ceil()) - 1;

          bool isWhite = (row + col) % 2 == 0;
          return Squre(isWhite: isWhite);
        },
      ),
    );
  }
}
