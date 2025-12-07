import 'package:flutter/material.dart';
import 'package:project_kasparov/Theme/colors.dart';
import 'package:project_kasparov/Views/game_board.dart';
import 'package:project_kasparov/viewmodels/game_view_model.dart';
import 'package:provider/provider.dart';

class GameModesPage extends StatelessWidget {
  const GameModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // ICON
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'lib/images/icon.png',

                height: 200, // slightly smaller to fit better in tab view
              ),
            ),

            // Text
            Text(
              'P R O J E C T _ K A S P A R O V',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.normal,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 50),

            // BUTTONS
            ElevatedButton(
              onPressed: () {
                // TODO: Implement AI Play
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Play with AI'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Stockfish Play
                Provider.of<GameViewModel>(context, listen: false)
                    .initializeGame(GameMode.classical);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard()),
                );
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Play with Stockfish'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Provider.of<GameViewModel>(context, listen: false)
                    .initializeGame(GameMode.classical);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard()),
                );
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Classic Chess'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Provider.of<GameViewModel>(context, listen: false)
                    .initializeGame(GameMode.quick);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard()),
                );
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Quick Chess'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Provider.of<GameViewModel>(context, listen: false)
                    .initializeGame(GameMode.blitz);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard()),
                );
              },
              style: ElevatedButton.styleFrom(),
              child: Text('Blitz Chess'),
            ),
          ],
        ),
      ),
    );
  }
}
