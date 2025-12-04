import 'package:flutter/material.dart';
import 'package:project_kasparov/Views/game_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage('lib/images/icon.png')),
            Text(
              'P R O J E C T _ K A S P A R O V',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(),
              child: Text('Quick Chess'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(),
              child: Text('Blitz Chess'),
            ),
            Spacer(),
            Text(
              'Made by Zheer in a Hurry',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
