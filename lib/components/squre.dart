import 'package:flutter/material.dart';
import 'package:project_kasparov/models/piece.dart';
import 'package:project_kasparov/Theme/colors.dart';

class Squre extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValid;
  final Function()? onTap;
  const Squre(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap,
      required this.isValid});

  @override
  Widget build(BuildContext context) {
    Color? squreColor;

    if (isSelected) {
      squreColor = Colors.green;
    } else if (isValid) {
      squreColor = Colors.green.shade200;
    } else {
      squreColor = isWhite ? foregroundColor : backgroundColor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squreColor,
        child: piece != null
            ? Image.asset(
                piece!.imagePath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
