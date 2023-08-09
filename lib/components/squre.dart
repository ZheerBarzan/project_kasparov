import 'package:flutter/material.dart';
import 'package:project_kasparov/components/piece.dart';
import 'package:project_kasparov/values/colors.dart';

class Squre extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Squre({super.key, required this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? foregroundColor : backgroundColor,
      child: piece != null
          ? Image.asset(
              piece!.imagePath,
              color: piece!.isWhite ? Colors.white : Colors.black,
            )
          : null,
    );
  }
}
