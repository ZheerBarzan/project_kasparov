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

  ChessPiece? selectedPiece;

  int selectedRow = -1;

  int selectedColumn = -1;

  List<List<int>> validMoves = [];

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
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "lib/images/rook.png",
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: "lib/images/rook.png",
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "lib/images/rook.png",
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: "lib/images/rook.png",
    );

    // place knights
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "lib/images/knight.png",
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: "lib/images/knight.png",
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "lib/images/knight.png",
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: "lib/images/knight.png",
    );

    // place bishops
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "lib/images/bishop.png",
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: "lib/images/bishop.png",
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "lib/images/bishop.png",
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: "lib/images/bishop.png",
    );

    // place queens
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: "lib/images/queen.png",
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: "lib/images/queen.png",
    );

    // place kings
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: "lib/images/king.png",
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: "lib/images/king.png",
    );

    board = newBoard;
  }

  void pieceSelected(int row, int column) {
    setState(
      () {
        if (board[row][column] != null) {
          selectedPiece = board[row][column];
          selectedRow = row;
          selectedColumn = column;
        }
        validMoves =
            calculateValidMoves(selectedRow, selectedColumn, selectedPiece);
      },
    );
  }

  List<List<int>> calculateValidMoves(int row, int column, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pwan:
        // pwan can move 1 squre forward at a time
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          candidateMoves.add([row + direction, column]);
        }
        // pwan can move 2 squres forward at the inital position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2, column) &&
              board[row + 2 * direction][column] == null &&
              board[row + direction][column] == null) {
            candidateMoves.add([row + 2 * direction, column]);
          }
        }
        // pwan can kill diagonally
        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite) {
          candidateMoves.add([row + direction, column - 1]);
        }
        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite) {
          candidateMoves.add([row + direction, column + 1]);
        }
        break;
      case ChessPieceType.rook:
        break;
      case ChessPieceType.knight:
        break;
      case ChessPieceType.bishop:
        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.king:
        break;
    }
    return candidateMoves;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
        padding: const EdgeInsets.only(top: 180),
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          final int row = ((index / 8).floor());
          final int column = (((index % 8)).ceil());
          bool isSelected = selectedRow == row && selectedColumn == column;

          // check is a valid move
          bool isValidMove = false;
          for (var position in validMoves) {
            // comapre rows and columns
            if (position[0] == row && position[1] == column) {
              isValidMove = true;
            }
          }
          return Squre(
            isWhite: isWhite(index),
            piece: board[row][column],
            isSelected: isSelected,
            onTap: () => pieceSelected(row, column),
            isValid: isValidMove,
          );
        },
      ),
    );
  }
}
