import 'package:flutter/material.dart';
import 'package:project_kasparov/Views/game_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage('lib/images/icon.png')),
            Text('P R O J E C T _ K A S P A R O V'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard()),
                );
              },
              child: Text('Classic Chess'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Quick Chess'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Blitz Chess'),
            ),
          ],
        ),
      ),
    );
  }
}
