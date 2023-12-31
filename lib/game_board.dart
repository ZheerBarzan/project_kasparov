import 'package:flutter/material.dart';
import 'package:project_kasparov/components/piece.dart';
import 'package:project_kasparov/components/squre.dart';
import 'package:project_kasparov/helper/helper_functions.dart';
import 'package:project_kasparov/values/colors.dart';

import 'components/DeadPiece.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
// a 2-dimentional list representing the chess board
//each postion contains a chess piece
  late List<List<ChessPiece?>> board;

// if no piece is selected this is null
  ChessPiece? selectedPiece;
// the row index of the selectd piece
  int selectedRow = -1;
// the column index of the selectd piece
  int selectedColumn = -1;

// a list of move for the currently selected piece whatever the piece is
//each move is represented as a list of 2 elements: row and column
  List<List<int>> validMoves = [];

// a list of the white pieces taken by the black player
  List<ChessPiece> whitePiecesTaken = [];
// a list of the white pieces taken by the white player
  List<ChessPiece> blackPiecesTaken = [];

// a boolean to determine whos turn it is
  bool isWhiteTurn = true;

// keeping track of the positions of the kings and check weather they are in check or no
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
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
        // if there is a piece in that postion and no piece has been selected
        if (selectedPiece == null && board[row][column] != null) {
          if (board[row][column]!.isWhite == isWhiteTurn) {
            selectedPiece = board[row][column];
            selectedRow = row;
            selectedColumn = column;
          }
        } else if (board[row][column] != null &&
            board[row][column]!.isWhite == selectedPiece!.isWhite) {
          selectedPiece = board[row][column];
          selectedRow = row;
          selectedColumn = column;
        }
        // if a piece is selectd and the moves is valid user taps on a squre, move there
        else if (selectedPiece != null &&
            validMoves
                .any((element) => element[0] == row && element[1] == column)) {
          movePiece(row, column);
        }

        // if the piece is selected calculate the valid moves
        validMoves = calculateRealValidMoves(
            selectedRow, selectedColumn, selectedPiece, true);
      },
    );
  }

  List<List<int>> calculateValidMoves(int row, int column, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    // diffrent directions based on thier color
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pwan:
        // pwan can move 1 squre forward at a time
        if (isInBoard(row + direction, column) &&
            board[row + direction][column] == null) {
          candidateMoves.add([row + direction, column]);
        }
        // pwan can move 2 squres forward at the inital position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, column) &&
              board[row + 2 * direction][column] == null &&
              board[row + direction][column] == null) {
            candidateMoves.add([row + 2 * direction, column]);
          }
        }
        // pwan can kill diagonally
        if (isInBoard(row + direction, column - 1) &&
            board[row + direction][column - 1] != null &&
            board[row + direction][column - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, column - 1]);
        }
        if (isInBoard(row + direction, column + 1) &&
            board[row + direction][column + 1] != null &&
            board[row + direction][column + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, column + 1]);
        }
        break;
      case ChessPieceType.rook:
        // rook can move to the end of the board only horizontlly and vertically
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            // if empty move
            if (board[newRow][newColumn] != null) {
              // if not empty and not our piece
              if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newColumn]); // rook kill
              }
              break; // blocked
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        // all possible moves for the knight which moves in the shape of letter "L"
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];
        for (var moves in knightMoves) {
          var newRow = row + moves[0];
          var newColumn = column + moves[1];
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          if (board[newRow][newColumn] != null) {
            // if there is a piece and it not out piece
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]); // kill
            }
            continue;
          }
          candidateMoves.add([newRow, newColumn]);
        }
        break;
      case ChessPieceType.bishop:
        // bishop can move to the end of the board only diagonaly
        var directions = [
          [-1, -1], //up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1] // down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            // if its out of the board stop
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            // a piece is detected
            if (board[newRow][newColumn] != null) {
              // if not the same color
              if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newColumn]); // kill
              }
              break;
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }

        break;
      case ChessPieceType.queen:
        // rook can move to the end of the board all directions
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1] // down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newColumn = column + i * direction[1];
            // if its out of the board stop
            if (!isInBoard(newRow, newColumn)) {
              break;
            }
            // a piece is detected
            if (board[newRow][newColumn] != null) {
              // if not the same color
              if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newColumn]); // kill
              }
              break;
            }
            candidateMoves.add([newRow, newColumn]);
            i++;
          }
        }

        break;
      case ChessPieceType.king:
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], // up right
          [1, -1], // down left
          [1, 1] // down right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newColumn = column + direction[1];
          // if its out of the board stop
          if (!isInBoard(newRow, newColumn)) {
            continue;
          }
          // a piece is detected
          if (board[newRow][newColumn] != null) {
            // if not the same color
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]); // kill
            }
            continue;
          }
          candidateMoves.add([newRow, newColumn]);
        }

        break;
    }
    return candidateMoves;
  }

  List<List<int>> calculateRealValidMoves(
      int row, int column, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realMoves = [];
    List<List<int>> candidateMoves = calculateValidMoves(row, column, piece);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endColumn = move[1];

        if (simulateMoveIsSafe(piece!, row, column, endRow, endColumn)) {
          realMoves.add(move);
        }
      }
    } else {
      realMoves = candidateMoves;
    }
    return realMoves;
  }

  // move the pieces
  void movePiece(int newRow, int newColumn) {
    if (board[newRow][newColumn] != null) {
      var capturedPiece = board[newRow][newColumn];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newColumn];
      } else {
        blackKingPosition = [newRow, newColumn];
      }
    }
    //move the piece and clear the old spot
    board[newRow][newColumn] = selectedPiece;
    board[selectedRow][selectedColumn] = null;
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }
    // clear the selection
    setState(() {
      selectedRow = -1;
      selectedColumn = -1;
      selectedPiece = null;
      validMoves = [];
    });

    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("CHECK MATE!"),
                actions: [
                  TextButton(
                      onPressed: resetGame, child: const Text("Play Again"))
                ],
              ));
    }

    isWhiteTurn = !isWhiteTurn;
  }

  bool isKingInCheck(bool isKing) {
    List<int> kingPosition = isKing ? whiteKingPosition : blackKingPosition;

    // check if the enemy piece can attack the king

    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        // skip the empty squares and pieces that are similer to the king
        if (board[row][column] == null ||
            board[row][column]!.isWhite == isKing) {
          continue;
        }
        List<List<int>> pieceValidMove =
            calculateRealValidMoves(row, column, board[row][column], false);

        if (pieceValidMove.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool simulateMoveIsSafe(ChessPiece piece, int startRow, int startColumn,
      int endRow, int endColumn) {
    ChessPiece? originalDestinationPiece = board[endRow][endColumn];

    List<int>? originalKingPosition;

    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endColumn];
      } else {
        blackKingPosition = [endRow, endColumn];
      }
    }

    board[endRow][endColumn] = piece;
    board[startRow][startColumn] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    board[startRow][startColumn] = piece;
    board[endRow][endColumn] = originalDestinationPiece;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  bool isCheckMate(bool isKing) {
    if (!isKingInCheck(isKing)) {
      return false;
    }
    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        // skip the empty squares and pieces that are similer to the king
        if (board[row][column] == null ||
            board[row][column]!.isWhite != isKing) {
          continue;
        }

        List<List<int>> pieceValidMove =
            calculateRealValidMoves(row, column, board[row][column], true);
        if (pieceValidMove.isNotEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // white pieces taken on the screen
          Expanded(
            child: GridView.builder(
              itemCount: whitePiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: whitePiecesTaken[index].imagePath,
                isWhite: true,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(8.0),
            decoration: checkStatus
                ? BoxDecoration(
                    border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.redAccent,
                  )
                : null,
            child: Text(
              checkStatus ? "Check!" : "",
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
                final int column = index % 8; // remaider divison for the column

                bool isSelected =
                    selectedRow == row && selectedColumn == column;

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
          ),
          // white pieces taken on the screen
          Expanded(
            child: GridView.builder(
              itemCount: blackPiecesTaken.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemBuilder: (context, index) => DeadPiece(
                imagePath: blackPiecesTaken[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
