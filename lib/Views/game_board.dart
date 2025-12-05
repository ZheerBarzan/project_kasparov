import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_kasparov/components/squre.dart';
import 'package:project_kasparov/helper/helper_functions.dart';
import 'package:project_kasparov/Theme/colors.dart';
import 'package:project_kasparov/viewmodels/game_view_model.dart';
import '../components/DeadPiece.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              Provider.of<GameViewModel>(context, listen: false)
                  .resetGame(context);
            },
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: backgroundColor,
      body: Consumer<GameViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // white pieces taken on the screen
              Expanded(
                child: GridView.builder(
                  itemCount: viewModel.whitePiecesTaken.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) => DeadPiece(
                    imagePath: viewModel.whitePiecesTaken[index].imagePath,
                    isWhite: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(8.0),
                decoration: viewModel.checkStatus
                    ? BoxDecoration(
                        border: Border.all(color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.redAccent,
                      )
                    : null,
                child: Text(
                  viewModel.checkStatus ? "Check!" : "",
                ),
              ),

              Expanded(
                flex: 3,
                child: GridView.builder(
                  // padding: const EdgeInsets.only(top: 180),
                  itemCount: 8 * 8,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    final int row = index ~/ 8; // integer divison for the row
                    final int column =
                        index % 8; // remaider divison for the column

                    bool isSelected = viewModel.selectedRow == row &&
                        viewModel.selectedColumn == column;

                    // check is a valid move
                    bool isValidMove = false;
                    for (var position in viewModel.validMoves) {
                      // comapre rows and columns
                      if (position[0] == row && position[1] == column) {
                        isValidMove = true;
                      }
                    }
                    return Squre(
                      isWhite: isWhite(index),
                      piece: viewModel.board[row][column],
                      isSelected: isSelected,
                      onTap: () =>
                          viewModel.pieceSelected(row, column, context),
                      isValid: isValidMove,
                    );
                  },
                ),
              ),
              // white pieces taken on the screen
              Expanded(
                child: GridView.builder(
                  itemCount: viewModel.blackPiecesTaken.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) => DeadPiece(
                    imagePath: viewModel.blackPiecesTaken[index].imagePath,
                    isWhite: false,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
