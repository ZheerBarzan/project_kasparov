import 'package:flutter/material.dart';
import 'package:project_kasparov/models/piece.dart';
import 'package:project_kasparov/Theme/colors.dart';

class TakenPiecesDisplay extends StatelessWidget {
  final List<ChessPiece> pieces;
  final bool isWhite; // Color of the dead pieces

  const TakenPiecesDisplay({
    super.key,
    required this.pieces,
    required this.isWhite,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Group pieces by type
    Map<ChessPieceType, int> counts = {};
    for (var piece in pieces) {
      counts[piece.type] = (counts[piece.type] ?? 0) + 1;
    }

    // 2. Define sort order (high value to low value)
    final List<ChessPieceType> sortOrder = [
      ChessPieceType.queen,
      ChessPieceType.rook,
      ChessPieceType.bishop,
      ChessPieceType.knight,
      ChessPieceType.pwan,
    ];

    // 3. Create sorted list of types that are present
    final sortedTypes =
        sortOrder.where((type) => counts.containsKey(type)).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        children: sortedTypes.map((type) {
          final count = counts[type]!;
          // Get image path from a piece instance (or hardcode based on type)
          // Since we have the piece object, we can find one of that type to get the path
          final samplePiece = pieces.firstWhere((p) => p.type == type);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                samplePiece.imagePath,
                color: isWhite ? foregroundColor : deadPieceColor,
                height: 40, // Fixed height for consistency
                width: 40,
              ),
              if (count > 1)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
