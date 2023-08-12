import 'package:flutter/material.dart';
import 'package:project_kasparov/components/piece.dart';
import 'package:project_kasparov/values/colors.dart';

class Squre extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final Function()? onTap;
  const Squre(
      {super.key,
      required this.isWhite,
      required this.piece,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color? squreColor;

    if (isSelected) {
      squreColor = Colors.green;
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
