import 'package:flutter/material.dart';
import 'package:project_kasparov/components/piece.dart';
import 'package:project_kasparov/components/squre.dart';
import 'package:project_kasparov/helper/helper_functions.dart';
import 'package:project_kasparov/values/colors.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    super.initState();
    initalizeState();
  }

  void initalizeState() {
    // initalize the board with nulls meaning no pices in the positions
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // place pwans
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pwan,
        isWhite: false,
        imagePath: "lib/images/pwan.png",
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pwan,
        isWhite: true,
        imagePath: "lib/images/pwan.png",
      );
    }

    // place rooks

    // place knights

    // place bishops

    // place queens

    // place kings

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: GridView.builder(
          itemCount: 8 * 8,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8),
          itemBuilder: (context, index) {
            final int row = ((index / 8).floor());
            final int col = (((index % 8)).ceil());

            return Squre(
              isWhite: isWhite(index),
              piece: board[row][col],
            );
          },
        ),
      ),
    );
  }
}
