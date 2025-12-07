import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_kasparov/components/squre.dart';
import 'package:project_kasparov/helper/helper_functions.dart';
import 'package:project_kasparov/Theme/colors.dart';
import 'package:project_kasparov/viewmodels/game_view_model.dart';
import '../components/taken_pieces_display.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  bool _hasShownTimeoutDialog = false;

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
      body: SafeArea(
        child: Consumer<GameViewModel>(
          builder: (context, viewModel, child) {
            // Handle Timeout Dialog trigger
            if (viewModel.isTimeOver && !_hasShownTimeoutDialog) {
              _hasShownTimeoutDialog = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showTimeoutDialog(context, viewModel);
              });
            }
            // Reset dialog flag if game is reset
            if (!viewModel.isTimeOver && _hasShownTimeoutDialog) {
              _hasShownTimeoutDialog = false;
            }

            return Column(
              children: [
                // white pieces taken on the screen
                TakenPiecesDisplay(
                  pieces: viewModel.whitePiecesTaken,
                  isWhite: true,
                ),

                // BLACK TIMER
                if (viewModel.gameMode != GameMode.classical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: !viewModel.isWhiteTurn && !viewModel.isTimeOver
                          ? Colors.lightGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatTime(viewModel.blackTimeRemaining),
                      style: TextStyle(
                        color: !viewModel.isWhiteTurn && !viewModel.isTimeOver
                            ? Colors.black // Make text readable on green
                            : Colors.white,
                        fontSize: 32, // Bigger clock
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: (viewModel.checkStatus)
                      ? BoxDecoration(
                          border: Border.all(color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.redAccent,
                        )
                      : null,
                  child: Text(
                    viewModel.checkStatus ? "Check!" : "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(
                    height: 10), // Space between status/timer and board

                // CHESS BOARD
                AspectRatio(
                  aspectRatio: 1.0,
                  child: GridView.builder(
                    itemCount: 8 * 8,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                    itemBuilder: (context, index) {
                      final int row = index ~/ 8;
                      final int column = index % 8;

                      bool isSelected = viewModel.selectedRow == row &&
                          viewModel.selectedColumn == column;

                      bool isValidMove = false;
                      for (var position in viewModel.validMoves) {
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

                const SizedBox(
                    height: 10), // Space between board and white timer

                // WHITE TIMER
                if (viewModel.gameMode != GameMode.classical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: viewModel.isWhiteTurn && !viewModel.isTimeOver
                          ? Colors.lightGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatTime(viewModel.whiteTimeRemaining),
                      style: TextStyle(
                        color: viewModel.isWhiteTurn && !viewModel.isTimeOver
                            ? Colors.black // Make text readable on green
                            : Colors.white,
                        fontSize: 32, // Bigger clock
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // white pieces taken by the black player (displayed at bottom, but these are black pieces captured by white? No, name is blackPiecesTaken)
                // Wait, viewModel.blackPiecesTaken usually means "Pieces that are Black, and have been Taken".
                // So these are Black pieces.
                TakenPiecesDisplay(
                  pieces: viewModel.blackPiecesTaken,
                  isWhite: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showTimeoutDialog(BuildContext context, GameViewModel viewModel) {
    // Determine winner based on whose turn triggered the timeout
    String winner = viewModel.isWhiteTurn ? "Black" : "White";
    String loser = viewModel.isWhiteTurn ? "White" : "Black";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Time Out!"),
        content: Text("$loser time out. $winner wins!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to Home
            },
            child: const Text("Back to Home"),
          ),
          TextButton(
            onPressed: () {
              // Reset game (this closes dialog in its implementation, but we need to ensure flow)
              // The viewModel.resetGame pops the context.
              // Since we are in a dialog, resetGame's pop will close the dialog.
              viewModel.resetGame(context);
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  // Helper to format duration
  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
